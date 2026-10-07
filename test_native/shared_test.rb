# frozen_string_literal: true

require_relative "test_helper"

# Every client in a process is a light view on one runtime and one connection pool.
# rubocop:disable Minitest/MultipleAssertions
class SharedTest < NativeTest
  def test_clients_views_and_lwa_reuse_one_connection
    tokens = JSON.generate(access_token: "from-lwa", token_type: "bearer", expires_in: 3600)
    responder = ->(_method, target, *) { [200, target == "/auth" ? tokens : "{}"] }
    serve_keep_alive(responder: responder) do |url, accepted, requests|
      first = Peddler::Client.new(base_url: url, access_token: "seller-a")
      second = Peddler::Client.new(base_url: url, access_token: "seller-b", timeout: 5, retries: 1)

      assert_equal(200, first.request("GET", "/").status)
      assert_equal(200, second.orders_v0.get_order("1").status)
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
      document = instance.download_document("#{url}/document")

      assert_equal("{}", document.each_chunk.to_a.join)
      reader, writer = IO.pipe
      pid = fork do
        reader.close
        results = [
          -> { instance.request("GET", "/inherited") },
          -> { instance.orders_v0.get_order("1") },
          -> { instance.with_access_token("child") },
          -> { instance.upload_document("#{url}/inherited", "x", content_type: "text/plain") },
          -> { instance.reports.open_report_document("d") },
          -> { instance.reports.wait_for_report("r") },
          -> { instance.feeds.create_and_upload_feed_document("x", content_type: "text/xml") },
          -> { document.closed? },
          -> { document.close },
          -> { lwa.refresh(refresh_token: "refresh") },
          -> { lwa.exchange_authorization_code(code: "code") },
          -> { lwa.client_credentials(scope: "scope") },
        ].map do |call|
          call.call
          "accepted"
        rescue Peddler::ForkError => error
          error.message
        end
        # A client built here works, on a runtime and a pool of the child's own.
        fresh = Peddler::Client.new(base_url: url, access_token: "child-secret")
        results << fresh.request("GET", "/child").status
        results << fresh.with_access_token("child-view").request("GET", "/child").status
        fresh_lwa = Peddler::LWA.new(client_id: "id", client_secret: "secret", lwa_endpoint: "#{url}/auth")
        results << fresh_lwa.refresh(refresh_token: "refresh").access_token
        instance = lwa = document = fresh = fresh_lwa = nil
        GC.start
        writer.write(JSON.generate(results))
        writer.close
        exit!(0)
      end
      writer.close

      assert(reader.wait_readable(10), "fork deadline")
      # The error names what to build again.
      guarded = ["create a new client after fork"] * 9 + ["create a new Peddler::LWA after fork"] * 3

      assert_equal(guarded + [200, 200, "from-lwa"], JSON.parse(reader.read))
      Process.wait(pid)

      assert_predicate($?, :success?)
      # The parent still works, on the connection it opened before the fork.
      assert_equal(200, instance.request("GET", "/parent").status)
      seen = Array.new(6) { requests.pop }

      assert_equal(["/parent", "/document", "/child", "/child", "/auth", "/parent"], seen.map { |_, target, _, _| target })
      assert_equal(["local-secret", nil, "child-secret", "child-view", nil, "local-secret"],
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
