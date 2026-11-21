# frozen_string_literal: true

require_relative "test_helper"

# A native call asks Ruby in the middle of its work, as it asks a token source before each attempt. Ruby is called
# on the calling thread, between the passes of the call, so everything a Ruby thread can do there still works.
# rubocop:disable Minitest/MultipleAssertions
class HookTest < NativeTest
  TOKENS = JSON.generate(access_token: "from-lwa", token_type: "bearer", expires_in: 3600)

  def test_a_source_is_called_on_the_calling_thread_and_may_make_native_calls_of_its_own
    responder = lambda do |_method, target, *|
      case target
      when "/auth" then [200, TOKENS]
      when "/issue" then [200, '{"token":"issued"}']
      else [200, "{}"]
      end
    end
    serve_keep_alive(responder: responder) do |url, accepted, requests|
      threads = []
      lwa = Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "#{url}/auth")
      inner = Peddler::Client.new(base_url: url, access_token: -> { lwa.refresh(refresh_token: "r").access_token })
      source = lambda do
        threads << Thread.current
        inner.request("GET", "/issue").to_h.fetch("token")
      end
      outer = Peddler::Client.new(base_url: url, access_token: source)

      assert_equal(200, outer.request("GET", "/").status)
      assert_equal(200, Thread.new { outer.orders_v0.get_order("1") }.value.status)
      seen = Array.new(6) { requests.pop }

      assert_equal(["/auth", "/issue", "/", "/auth", "/issue", "/orders/v0/orders/1"], seen.map { |_, target, *| target })
      assert_equal([nil, "from-lwa", "issued"] * 2, seen.map { |_, _, headers, _| headers["x-amz-access-token"] })
      assert_same(Thread.current, threads.first)
      refute_same(Thread.current, threads.last)
      # A call inside a call waits for nothing: all three took turns on the pool.
      assert_operator(accepted.size, :<=, 2)
    end
  end

  def test_an_exception_before_a_retry_ends_the_call_and_the_client_stays_usable
    failure = Class.new(StandardError).new("cache is down")
    statuses = [429, 200, "IN_PROGRESS", "DONE"]
    responder = lambda do |*|
      status = statuses.shift
      next [status, "{}", [["Retry-After", "0"]]] if status.is_a?(Integer)

      [200, JSON.generate(reportId: "r1", reportType: "T", processingStatus: status, createdTime: "2024-01-01T00:00:00Z")]
    end
    serve_keep_alive(responder: responder) do |url, accepted, requests|
      calls = 0
      failing = [2, 5]
      source = lambda do
        calls += 1
        raise failure if failing.include?(calls)

        "token-#{calls}"
      end
      instance = Peddler::Client.new(base_url: url, access_token: source, retries: 1)
      # The first attempt is throttled, and the source fails when the retry asks it.
      raised = assert_raises(failure.class) { instance.request("GET", "/") }

      assert_same(failure, raised)
      assert_nil(raised.cause)
      assert_equal(200, instance.request("GET", "/").status)
      # The same in a helper whose loop runs in Rust: the second poll asks, and the source fails.
      assert_same(failure, assert_raises(failure.class) { instance.reports.wait_for_report("r1", interval: 0.01) })
      assert_equal("DONE", instance.reports.wait_for_report("r1", interval: 0.01).to_h.fetch("processingStatus"))
      assert_equal(["token-1", "token-3", "token-4", "token-6"], Array.new(4) { requests.pop }.map { |_, _, headers, _| headers["x-amz-access-token"] })
      assert_operator(accepted.size, :<=, 2)
    end
  end

  def test_thread_raise_kill_and_timeout_land_while_ruby_is_being_called
    serve_keep_alive do |url, accepted, _requests|
      entered = Queue.new
      blocking = lambda do
        entered << true
        sleep
      end
      instance = Peddler::Client.new(base_url: url, access_token: blocking, timeout: 5)

      raised = Thread.new do
        instance.request("GET", "/")
      rescue Interrupt => error
        error
      end
      Timeout.timeout(3) { entered.pop }
      raised.raise(Interrupt, "stop")

      assert(raised.join(2), "the call outlived the exception")
      assert_equal("stop", raised.value.message)

      unwound = Queue.new
      killed = Thread.new do
        instance.request("GET", "/")
      ensure
        unwound << true
      end
      Timeout.timeout(3) { entered.pop }
      killed.kill

      assert(killed.join(2), "the call outlived the kill")
      assert_nil(killed.value)
      assert_equal(1, unwound.size)

      assert_raises(Timeout::Error) { Timeout.timeout(0.05) { instance.request("GET", "/") } }
      assert_equal(0, accepted.size, "no request was sent")
      assert_equal(200, instance.with_access_token("fixed").request("GET", "/").status)
    ensure
      [raised, killed].each { |thread| thread&.kill&.join }
    end
  end

  def test_throw_and_an_exception_that_is_no_standard_error_unwind_through_the_call
    serve_keep_alive do |url, accepted, _requests|
      thrower = Peddler::Client.new(base_url: url, access_token: -> { throw(:halt, :thrown) })

      assert_equal(:thrown, catch(:halt) { thrower.request("GET", "/") })
      fatal = Class.new(Exception)
      raiser = Peddler::Client.new(base_url: url, access_token: -> { raise fatal, "not standard" })

      assert_equal("not standard", assert_raises(fatal) { raiser.orders_v0.get_order("1") }.message)
      assert_equal(0, accepted.size)
    end
  end

  def test_a_source_runs_under_the_mask_of_its_caller
    serve_keep_alive do |url, *|
      entered = Queue.new
      release = Queue.new
      source = lambda do
        entered << true
        release.pop
        "token"
      end
      instance = Peddler::Client.new(base_url: url, access_token: source)
      worker = Thread.new do
        Thread.handle_interrupt(Interrupt => :never) { instance.request("GET", "/").status }
      rescue Interrupt
        :interrupted_outside
      end
      Timeout.timeout(3) { entered.pop }
      worker.raise(Interrupt)
      release << true

      # The masked exception neither ends the source nor the request after it. It lands once the mask ends.
      assert(worker.join(3))
      assert_equal(:interrupted_outside, worker.value)
    ensure
      worker&.kill&.join
    end
  end

  def test_a_source_that_forks_returns_in_the_child_where_the_call_raises_fork_error
    skip "fork unavailable" unless Process.respond_to?(:fork)

    parent = Process.pid
    child = nil
    reader, writer = IO.pipe
    serve_keep_alive do |url, accepted, requests|
      source = lambda do
        child = fork
        "token"
      end
      instance = Peddler::Client.new(base_url: url, access_token: source)
      outcome = begin
        instance.request("GET", "/").status
      rescue Peddler::ForkError => error
        error.message
      end
      unless Process.pid == parent
        writer.write(JSON.generate(outcome))
        writer.close
        exit!(0)
      end
      writer.close

      assert_equal(200, outcome)
      assert(reader.wait_readable(5), "the child hangs in the call it inherited")
      assert_equal("create a new client after fork", JSON.parse(reader.read))
      assert_equal(1, requests.size, "the child sent nothing")
      assert_equal(1, accepted.size)
    ensure
      # The child never returns into the suite.
      exit!(1) unless Process.pid == parent
      reader&.close
      writer&.close unless writer&.closed?
      if child
        begin
          Process.kill("KILL", child)
        rescue Errno::ESRCH
          nil
        end
        Process.wait(child)
      end
    end
  end

  def test_calls_with_a_source_run_side_by_side_on_many_threads
    serve_keep_alive do |url, _accepted, requests|
      mutex = Mutex.new
      calls = 0
      source = -> { mutex.synchronize { "token-#{calls += 1}" } }
      instance = Peddler::Client.new(base_url: url, access_token: source)
      statuses = Array.new(8) { Thread.new { Array.new(25) { instance.request("GET", "/").status } } }.flat_map(&:value)

      assert_equal([200] * 200, statuses)
      assert_equal(200, calls)
      sent = Array.new(200) { requests.pop }.map { |_, _, headers, _| headers["x-amz-access-token"] }

      assert_equal((1..200).map { |number| "token-#{number}" }.sort, sent.sort)
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
