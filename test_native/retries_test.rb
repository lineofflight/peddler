# frozen_string_literal: true

require_relative "test_helper"

# What `retries:` does: which requests are sent again, how long each waits first and what `timeout:` limits.
#
# No test waits a second. A reply asks for its retry at once with `Retry-After: 0`, or the operation is one Amazon
# documents a high rate for, so that the wait by its rate is short. A wait that must not end is a minute long,
# and the test interrupts it.
# rubocop:disable Minitest/MultipleAssertions
class RetriesTest < NativeTest
  AT_ONCE = [["Retry-After", "0"]].freeze
  MARKETPLACE = ["ATVPDKIKX0DER"].freeze
  QUOTA_EXCEEDED = '{"errors":[{"code":"QuotaExceeded","message":"You exceeded your quota for the requested resource."}]}'

  # Answers the first request with the first reply, the second with the second, and any after the last with the
  # last. A reply is [status, headers, seconds before it is sent]. Returns the methods of the requests.
  def replying(*replies)
    served = 0
    responder = lambda do |*|
      status, headers, delay = replies.fetch(served, replies.last)
      served += 1
      sleep(delay) if delay
      [status, status == 429 ? QUOTA_EXCEEDED : "{}", headers]
    end
    serve_keep_alive(responder: responder) do |url, _accepted, requests|
      yield url
      Array.new(requests.size) { requests.pop }.map(&:first)
    end
  end

  def seconds
    started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    yield
    Process.clock_gettime(Process::CLOCK_MONOTONIC) - started
  end

  def test_nothing_is_sent_again_by_default
    [429, 503].each do |status|
      requests = replying([status, AT_ONCE]) do |url|
        assert_equal(status, assert_raises(Peddler::Error) { client(url).request("GET", "/") }.status)
      end

      assert_equal(["GET"], requests)
    end
  end

  def test_a_throttled_request_is_sent_again_whatever_its_method
    ["GET", "POST", "PUT", "PATCH", "DELETE"].each do |method|
      requests = replying([429, AT_ONCE], [429, AT_ONCE], [200]) do |url|
        assert_equal(200, client(url, retries: 2).request(method, "/").status)
      end

      assert_equal([method] * 3, requests)
    end
  end

  def test_a_write_that_failed_is_not_sent_again_but_a_get_is
    [500, 502, 503, 504].each do |status|
      requests = replying([status, AT_ONCE], [status, AT_ONCE], [200]) do |url|
        instance = client(url, retries: 2)
        error = assert_raises(Peddler::Error) { instance.shipping_v2.get_rates({}) }

        assert_equal(status, error.status)
        assert_equal(200, instance.shipping_v2.get_tracking("tracking", "carrier").status)
      end

      assert_equal(["POST", "GET", "GET"], requests)
    end
  end

  def test_a_request_amazon_rejects_is_not_sent_again
    [400, 403, 404, 501].each do |status|
      requests = replying([status, AT_ONCE]) do |url|
        assert_equal(status, assert_raises(Peddler::Error) { client(url, retries: 3).request("GET", "/") }.status)
      end

      assert_equal(["GET"], requests)
    end
  end

  def test_the_last_response_raises_when_the_retries_run_out
    requests = replying([429, AT_ONCE]) do |url|
      error = assert_raises(Peddler::Error) { client(url, retries: 3).orders_v0.get_orders(MARKETPLACE) }

      assert_equal([429, "QuotaExceeded"], [error.status, error.code])
      assert_equal("You exceeded your quota for the requested resource.", error.message)
    end

    assert_equal(["GET"] * 4, requests)
  end

  # Shipping v2 allows 80 requests a second: the first retry waits 12.5 milliseconds and the second 25, and up to
  # 100 more each. Without the rate the second wait alone would be a second or more.
  def test_an_operation_waits_by_the_rate_amazon_documents_for_it
    requests = replying([429], [429], [200], [429], [200]) do |url|
      instance = client(url, retries: 2)
      elapsed = seconds do
        assert_equal(200, instance.shipping_v2.get_tracking("tracking", "carrier").status)
        assert_equal(200, instance.shipping_v2.get_rates({}).status)
      end

      assert_operator(elapsed, :>=, 0.05)
      assert_operator(elapsed, :<, 1)
    end

    assert_equal(["GET", "GET", "GET", "POST", "POST"], requests)
  end

  # `get_orders` allows 1 request a minute, so by its rate the retry would wait a minute.
  def test_retry_after_replaces_the_wait_by_the_rate
    requests = replying([429, AT_ONCE], [200]) do |url|
      response = Timeout.timeout(5) { client(url, retries: 1).orders_v0.get_orders(MARKETPLACE) }

      assert_equal(200, response.status)
    end

    assert_equal(["GET", "GET"], requests)
  end

  def test_a_wait_longer_than_600_seconds_ends_retrying_and_the_last_response_raises
    requests = replying([429, [["Retry-After", "601"]]]) do |url|
      elapsed = seconds do
        error = assert_raises(Peddler::Error) { client(url, retries: 3).shipping_v2.get_tracking("tracking", "carrier") }

        assert_equal([429, "QuotaExceeded"], [error.status, error.code])
      end

      assert_operator(elapsed, :<, 1)
    end

    assert_equal(["GET"], requests)
  end

  def test_600_seconds_is_the_longest_wait_and_no_number_of_retries_makes_it_longer
    # A second request would mean the wait was followed. None comes: the 429 raises at once.
    ["601", "86400", "18446744073709551616"].each do |asked|
      requests = replying([429, [["Retry-After", asked]]]) do |url|
        Timeout.timeout(5) { assert_raises(Peddler::Error) { client(url, retries: 10).request("POST", "/", body: {}) } }
      end

      assert_equal(["POST"], requests, asked)
    end
  end

  def test_timeout_limits_each_attempt_and_not_the_waits_between_them
    slow = 0.08
    requests = replying([429, [], slow], [429, [], slow], [429, [], slow], [200, [], slow]) do |url|
      instance = client(url, retries: 3, timeout: 0.25)
      elapsed = seconds { assert_equal(200, instance.shipping_v2.get_tracking("tracking", "carrier").status) }

      # 4 attempts of 0.08 seconds and 3 waits: more than `timeout:` would allow a whole call.
      assert_operator(elapsed, :>, 0.4)
    end

    assert_equal(["GET"] * 4, requests)
  end

  # A write that got no answer may have been processed.
  def test_an_attempt_past_the_timeout_is_cut_off_and_a_write_is_not_sent_again
    requests = replying([200, [], 5]) do |url|
      elapsed = seconds do
        assert_raises(Peddler::TimeoutError) { client(url, retries: 3, timeout: 0.1).shipping_v2.get_rates({}) }
      end

      assert_operator(elapsed, :<, 1)
    end

    assert_equal(["POST"], requests)
  end

  # `get_orders` allows 1 request a minute, so the retry of a throttled one waits a minute. Only the first request
  # is answered 429.
  def waiting_a_minute
    answered = Queue.new
    responder = lambda do |_method, target, *|
      next [200, "{}"] unless target.start_with?("/orders/v0/orders")

      answered << true
      [429, "{}"]
    end
    serve_keep_alive(responder: responder) do |url, _accepted, requests|
      instance = client(url, retries: 1)
      yield(instance, lambda {
        Timeout.timeout(3) { answered.pop }
        # The reply reaches the client, which then waits.
        sleep(0.05)
      })

      # Nothing was sent again, and the client goes on working.
      assert_equal(1, requests.size)
      assert_equal(200, instance.request("GET", "/").status)
    end
  end

  def test_thread_raise_ends_the_wait_before_a_retry
    waiting_a_minute do |instance, waiting|
      worker = Thread.new do
        instance.orders_v0.get_orders(MARKETPLACE)
      rescue Interrupt => error
        error
      end
      waiting.call
      worker.raise(Interrupt, "stop waiting")

      assert(worker.join(2), "the wait went on")
      assert_instance_of(Interrupt, worker.value)
      assert_equal("stop waiting", worker.value.message)
    ensure
      worker&.kill
      worker&.join
    end
  end

  def test_thread_kill_ends_the_wait_before_a_retry
    waiting_a_minute do |instance, waiting|
      worker = Thread.new { instance.orders_v0.get_orders(MARKETPLACE) }
      waiting.call
      worker.kill

      assert(worker.join(2), "the wait went on")
      assert_nil(worker.value)
    ensure
      worker&.kill
      worker&.join
    end
  end

  def test_timeout_ends_the_wait_before_a_retry
    waiting_a_minute do |instance, _waiting|
      elapsed = seconds do
        assert_raises(Timeout::Error) { Timeout.timeout(0.2) { instance.orders_v0.get_orders(MARKETPLACE) } }
      end

      assert_operator(elapsed, :>=, 0.2)
      assert_operator(elapsed, :<, 2)
    end
  end

  # `get_listings_item` allows 5 requests a second, so its retry waits 0.2 seconds and up to 0.1 more. The thread
  # is woken 4 times early in that wait. Nothing is raised, so the retry is sent when the wait is over and not
  # before.
  def test_a_wakeup_or_a_trapped_signal_neither_shortens_nor_cancels_the_wait
    trapped = Queue.new
    previous = trap("USR1") { trapped << true }
    arrived = Queue.new
    times = []
    responder = lambda do |*|
      times << Process.clock_gettime(Process::CLOCK_MONOTONIC)
      arrived << true
      times.size == 1 ? [429, "{}"] : [200, "{}"]
    end
    serve_keep_alive(responder: responder) do |url, *|
      main = Thread.current
      waker = Thread.new do
        Timeout.timeout(3) { arrived.pop }
        sleep(0.05)
        3.times { main.wakeup }
        Process.kill("USR1", Process.pid)
      end

      # Ruby runs a trap on the main thread, which is the thread of this test.
      response = client(url, retries: 1).listings_items_2021_08_01.get_listings_item("seller", "sku", MARKETPLACE)
      waker.join

      assert_equal(200, response.status)
      Timeout.timeout(3) { trapped.pop }

      assert_equal(2, times.size)
      assert_operator(times[1] - times[0], :>=, 0.2)
      assert_operator(times[1] - times[0], :<, 1)
    ensure
      waker&.kill
      waker&.join
    end
  ensure
    trap("USR1", previous || "DEFAULT")
  end

  # `get_report` allows 2 requests a second, so the retry of a throttled poll waits half a second.
  def test_a_wait_for_a_job_never_sleeps_past_its_own_timeout
    requests = replying([429]) do |url|
      elapsed = seconds do
        assert_raises(Peddler::WorkflowTimeoutError) do
          client(url, retries: 3).reports.wait_for_report("r1", interval: 0.01, timeout: 0.15)
        end
      end

      assert_operator(elapsed, :>=, 0.15)
      assert_operator(elapsed, :<, 0.45)
    end

    assert_equal(["GET"], requests)
  end

  # The 429 is the error, not the timeout of the wait, which has 5 seconds left.
  def test_a_poll_told_to_wait_longer_than_600_seconds_raises_its_429_at_once
    requests = replying([429, [["Retry-After", "601"]]]) do |url|
      elapsed = seconds do
        error = assert_raises(Peddler::Error) do
          client(url, retries: 3).reports.wait_for_report("r1", interval: 0.01, timeout: 5)
        end

        assert_equal(429, error.status)
      end

      assert_operator(elapsed, :<, 1)
    end

    assert_equal(["GET"], requests)
  end

  def test_a_throttled_poll_is_sent_again_within_the_wait
    done = JSON.generate(reportId: "r1", reportType: "T", processingStatus: "DONE", createdTime: "2024-01-01T00:00:00Z")
    polls = 0
    responder = ->(*) { (polls += 1) == 1 ? [429, "{}", AT_ONCE] : [200, done] }
    serve_keep_alive(responder: responder) do |url, _accepted, requests|
      response = client(url, retries: 1).reports.wait_for_report("r1", interval: 0.01, timeout: 2)

      assert_equal("DONE", response.to_h["processingStatus"])
      assert_equal(2, requests.size)
    end
  end

  # `get_report_document` allows 1 request a minute, so the retry of a throttled lookup waits a minute. The limit
  # of the whole call comes first, and the lookup has timed out as a request does.
  def test_a_document_helper_keeps_the_limit_of_its_whole_call
    requests = replying([429]) do |url|
      elapsed = seconds do
        assert_raises(Peddler::TimeoutError) { client(url, retries: 3).reports.open_report_document("d1", timeout: 0.15) }
      end

      assert_operator(elapsed, :>=, 0.15)
      assert_operator(elapsed, :<, 0.45)
    end

    assert_equal(["GET"], requests)
  end

  # A throttled create made no document, so it is sent again. An upload is never sent twice.
  def test_creating_a_feed_document_is_retried_after_a_429_and_the_upload_never
    base = nil
    creates = 0
    responder = lambda do |_method, target, *|
      next [503, "busy", AT_ONCE] if target.start_with?("/signed")

      (creates += 1) == 1 ? [429, "{}", AT_ONCE] : [201, JSON.generate(feedDocumentId: "fd1", url: "#{base}/signed?sig=x")]
    end
    serve_keep_alive(responder: responder) do |url, _accepted, requests|
      base = url
      instance = client(url, retries: 2)
      error = assert_raises(Peddler::Error) { instance.feeds.create_and_upload_feed_document("x", content_type: "text/xml") }

      assert_equal(503, error.status)
      assert_equal(["POST", "POST", "PUT"], Array.new(requests.size) { requests.pop }.map(&:first))
    end
  end
end

# rubocop:enable Minitest/MultipleAssertions
