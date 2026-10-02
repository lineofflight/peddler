# frozen_string_literal: true

module Peddler
  class LWA
    # Keeps one access token in this process and refreshes it a little before it expires
    #
    # Build one with {Peddler::LWA#token_source} and pass it to {Peddler::Client} as `access_token:`. It refreshes
    # only when called, on the calling thread, and callers that arrive during a refresh wait for it and share its
    # result. A failed refresh is not kept: the callers waiting on it raise the same error, each an object of its
    # own, and the next call tries again.
    #
    # It is in-process only. Several processes each refresh for themselves, so pass the client a source of your own,
    # such as a lambda around a shared cache, when they should share a token. Create it after `fork`: one created
    # before raises {Peddler::ForkError} in the child.
    class TokenSource
      # A token is refreshed this many seconds early, or by a tenth of its lifetime when that is shorter.
      MARGIN = 60

      Refresh = Struct.new(:done, :token, :refresh_at, :error)
      private_constant :Refresh

      # @yieldreturn [Peddler::LWA::Tokens] new tokens from Login with Amazon
      def initialize(&grant)
        @grant = grant
        @pid = Process.pid
        @mutex = Mutex.new
        @finished = ConditionVariable.new
        @token = nil
        @refresh_at = 0.0
        @refresh = nil
      end

      # @return [String] the access token
      # @raise [Peddler::AuthenticationError] if Login with Amazon rejects the refresh
      def call
        raise ForkError, "create a new token source after fork" unless Process.pid == @pid

        # Thread#raise, Thread#kill and Timeout may only land while the grant runs or while a waiter waits. Anywhere
        # else they could leave a refresh marked as running that nobody runs, and every later call would wait forever.
        Thread.handle_interrupt(Object => :never) do
          leading = false
          refresh = @mutex.synchronize do
            token = @token
            return token if token && now < @refresh_at

            @refresh || begin
              leading = true
              @refresh = Refresh.new
            end
          end
          leading ? lead(refresh) : Thread.handle_interrupt(Object => :immediate) { follow(refresh) }
        end
      end

      def inspect = "#<Peddler::LWA::TokenSource>"
      alias_method :to_s, :inspect

      private

      # The lifetime counts from the start of the request, on the monotonic clock.
      def lead(refresh)
        started = now
        tokens = Thread.handle_interrupt(Object => :immediate) { @grant.call }
        lifetime = tokens.expires_in
        refresh.refresh_at = started + lifetime - [MARGIN, lifetime / 10.0].min
        refresh.token = tokens.access_token
      rescue AuthenticationError, TransportError => error
        refresh.error = error
        raise
      ensure
        @mutex.synchronize do
          @token = refresh.token
          @refresh_at = refresh.refresh_at || 0.0
          @refresh = nil
          refresh.done = true
          @finished.broadcast
        end
      end

      def follow(refresh)
        @mutex.synchronize { @finished.wait(@mutex) until refresh.done }
        error = refresh.error
        raise replica(error) if error

        # The thread that was refreshing was interrupted before it had a result, so ask again.
        refresh.token || call
      end

      # A waiter raises an error of its own, so its backtrace and cause are its own and nobody else's change.
      def replica(error)
        case error
        when AuthenticationError then error.class.new(error.message, error.status, code: error.code)
        else error.class.new(error.message)
        end
      end

      def now
        Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end
    end
  end
end
