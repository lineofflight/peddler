# frozen_string_literal: true

require_relative "test_helper"

# Every client in a process is a light view on one runtime and one connection pool.
# rubocop:disable Minitest/MultipleAssertions
class SharedTest < NativeTest
  # Operating system threads of this process, which is where a runtime per client showed up
  def native_thread_count
    return Dir.children("/proc/self/task").size if File.directory?("/proc/self/task")

    %x(ps -M -p #{Process.pid}).lines.size - 1
  end

  def test_many_clients_do_not_grow_the_thread_count
    serve_keep_alive do |url, _accepted, _requests|
      warm = client(url)

      assert_equal(200, warm.request("GET", "/").status)
      native_thread_count
      before = native_thread_count
      clients = Array.new(200) { |index| Peddler::Client.new(base_url: url, access_token: "token-#{index}") }
      lwas = Array.new(20) { Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: url) }
      views = clients.map { |instance| instance.with_access_token("rotated") }

      assert_equal(200, clients.last.request("GET", "/").status)
      assert_equal(200, views.last.request("GET", "/").status)
      assert_operator(native_thread_count, :<=, before)
      # All of them are still alive here, so none of the count above was freed by GC.
      assert_equal([200, 20, 200], [clients.size, lwas.size, views.size])
    end
  end

  def test_clients_views_and_lwa_reuse_one_connection
    tokens = JSON.generate(access_token: "from-lwa", token_type: "bearer", expires_in: 3600)
    responder = ->(_method, target, *) { [200, target == "/auth" ? tokens : "{}"] }
    serve_keep_alive(responder: responder) do |url, accepted, requests|
      first = Peddler::Client.new(base_url: url, access_token: "seller-a")
      second = Peddler::Client.new(base_url: url, access_token: "seller-b", timeout: 5, retries: 1)

      assert_equal(200, first.request("GET", "/").status)
      assert_equal(200, second.orders_v0.get_order(order_id: "1").status)
      fresh = Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "#{url}/auth").refresh(refresh_token: "refresh")

      assert_equal(200, first.with_access_token(fresh.access_token).request("GET", "/").status)
      seen = Array.new(4) { requests.pop }

      assert_equal(["seller-a", "seller-b", nil, "from-lwa"], seen.map { |_, _, headers, _| headers["x-amz-access-token"] })
      assert_equal([gem_user_agent, gem_user_agent, hostless_user_agent, gem_user_agent],
        seen.map { |_, _, headers, _| headers["user-agent"] })
      assert_equal(1, accepted.size)
    end
  end

  def test_fork_child_builds_fresh_shared_state_and_the_parent_keeps_its_own
    skip "fork unavailable" unless Process.respond_to?(:fork)

    tokens = JSON.generate(access_token: "from-lwa", token_type: "bearer", expires_in: 3600)
    responder = ->(_method, target, *) { [200, target == "/auth" ? tokens : "{}"] }
    serve_keep_alive(responder: responder) do |url, accepted, requests|
      instance = client(url)
      lwa = Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "#{url}/auth")

      assert_equal(200, instance.request("GET", "/parent").status)
      reader, writer = IO.pipe
      pid = fork do
        reader.close
        results = [
          -> { instance.request("GET", "/inherited") },
          -> { instance.orders_v0.get_order(order_id: "1") },
          -> { instance.with_access_token("child") },
          -> { lwa.refresh(refresh_token: "refresh") },
        ].map do |call|
          call.call
          "accepted"
        rescue Peddler::ForkError
          "guarded"
        end
        # A client built here works, on a runtime and a pool of the child's own.
        fresh = Peddler::Client.new(base_url: url, access_token: "child-secret")
        results << fresh.request("GET", "/child").status
        results << fresh.with_access_token("child-view").request("GET", "/child").status
        fresh_lwa = Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "#{url}/auth")
        results << fresh_lwa.refresh(refresh_token: "refresh").access_token
        instance = lwa = fresh = fresh_lwa = nil
        GC.start
        writer.write(JSON.generate(results))
        writer.close
        exit!(0)
      end
      writer.close

      assert(reader.wait_readable(10), "fork deadline")
      assert_equal(["guarded", "guarded", "guarded", "guarded", 200, 200, "from-lwa"], JSON.parse(reader.read))
      Process.wait(pid)

      assert_predicate($?, :success?)
      # The parent still works, on the connection it opened before the fork.
      assert_equal(200, instance.request("GET", "/parent").status)
      seen = Array.new(5) { requests.pop }

      assert_equal(["/parent", "/child", "/child", "/auth", "/parent"], seen.map { |_, target, _, _| target })
      assert_equal(["local-secret", "child-secret", "child-view", nil, "local-secret"],
        seen.map { |_, _, headers, _| headers["x-amz-access-token"] })
      # One connection for the parent and one for the child, which never used the inherited one.
      assert_equal(2, accepted.size)
    ensure
      reader&.close
      writer&.close unless writer&.closed?
      if pid
        begin
          Process.kill("KILL", pid)
          Process.wait(pid)
        rescue Errno::ESRCH, Errno::ECHILD
          nil
        end
      end
    end
  end
end
# rubocop:enable Minitest/MultipleAssertions
