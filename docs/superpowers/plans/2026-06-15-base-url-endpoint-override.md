# base_url Endpoint Override Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a `base_url:` constructor option to `Peddler::API` that redirects all of a client's requests to a custom backend (local AI Sandbox, mock, proxy, or unmapped region).

**Architecture:** `base_url` is parsed and validated once at construction and stored as a `URI`. `endpoint_uri` returns it (duped) ahead of the existing production/sandbox logic. The Amazon-sandbox guards step aside when it is set, and the `.sandbox` setter refuses to combine with it. `Peddler::Endpoint` is untouched.

**Tech Stack:** Ruby, Minitest, RBS/Steep, RuboCop. Standard library `URI`.

**Reference:** Design spec at `docs/superpowers/specs/2026-06-15-endpoint-override-design.md`.

---

## File Structure

- Modify: `lib/peddler/api.rb` — add `base_url:` option, `parse_base_url`, `host_header`; change `endpoint_uri`, `http`, `sandbox`, `cannot_sandbox!`, `must_sandbox!`.
- Modify: `sig/peddler/api.rbs` — types for the new option, reader, and private helpers; broaden `endpoint_uri` return type.
- Modify: `test/peddler/api_test.rb` — new tests (no network; follows existing in-file patterns).
- Modify: `README.md` — a short `### Sandbox and custom endpoints` subsection under `## Usage`.
- Modify: `CHANGELOG.md` — `### Added` entry under `## [Unreleased]`.

`lib/peddler/api.rb` is hand-maintained (not generated). `sig/peddler/api.rbs` is hand-maintained (only `sig/peddler/{apis,notifications,reports,feeds}/*` are generated).

---

## Task 1: `base_url` option, validation, and routing

**Files:**
- Modify: `lib/peddler/api.rb:29-35` (initialize), `lib/peddler/api.rb:38-40` (endpoint_uri), readers near `lib/peddler/api.rb:14-23`
- Modify: `sig/peddler/api.rbs`
- Test: `test/peddler/api_test.rb`

- [ ] **Step 1: Write the failing tests**

Add these methods inside `class APITest` in `test/peddler/api_test.rb` (after `test_sandbox`, around line 20):

```ruby
def test_base_url_overrides_endpoint_uri
  api = API.new("eu-west-1", "access_token", base_url: "http://localhost:9001")
  assert_equal("http://localhost:9001", api.endpoint_uri.to_s)
end

def test_base_url_accepts_https
  api = API.new("eu-west-1", "access_token", base_url: "https://example.test")
  assert_equal("https://example.test", api.endpoint_uri.to_s)
end

def test_base_url_does_not_mutate_across_calls
  api = API.new("eu-west-1", "access_token", base_url: "http://localhost:9001")
  api.endpoint_uri.path = "/mutated"

  assert_equal("", api.endpoint_uri.path)
end

def test_base_url_reader
  api = API.new("eu-west-1", "access_token", base_url: "http://localhost:9001")
  assert_kind_of(URI::HTTP, api.base_url)
end

def test_base_url_rejects_url_without_scheme
  assert_raises(ArgumentError) do
    API.new("eu-west-1", "access_token", base_url: "localhost:9001")
  end
end

def test_base_url_rejects_garbage
  assert_raises(ArgumentError) do
    API.new("eu-west-1", "access_token", base_url: "not a url")
  end
end

def test_nil_base_url_uses_production
  assert_nil(@api.base_url)
  assert_kind_of(URI::HTTPS, @api.endpoint_uri)
end
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `bundle exec ruby -Itest test/peddler/api_test.rb`
Expected: FAIL — `unknown keyword: :base_url` (and `NoMethodError` for `base_url`).

- [ ] **Step 3: Implement the option, validation, reader, and routing**

In `lib/peddler/api.rb`, add a reader alongside the existing ones (after `attr_reader :retries` block, near line 23):

```ruby
    # @return [URI::HTTP, nil] Custom backend the client points at, if overridden
    attr_reader :base_url
```

Change `initialize` (currently lines 29-35) to:

```ruby
    def initialize(aws_region, access_token, retries: 0, http: HTTP::Client.new, base_url: nil)
      @endpoint = Endpoint.find(aws_region)
      @access_token = access_token
      @retries = retries
      @http = http
      @sandbox = false
      @base_url = parse_base_url(base_url)
    end
```

Change `endpoint_uri` (currently lines 38-40) to:

```ruby
    def endpoint_uri
      return base_url.dup if base_url

      sandbox? ? endpoint.sandbox : endpoint.production
    end
```

Add this private method (place it just above `user_agent`, near line 135):

```ruby
    def parse_base_url(value)
      return unless value

      uri =
        begin
          URI.parse(value)
        rescue URI::InvalidURIError
          nil
        end
      return uri if uri.is_a?(URI::HTTP) && uri.host

      raise ArgumentError, "base_url must be a full http(s) URL, e.g. http://localhost:9001"
    end
```

(`URI::HTTPS` is a subclass of `URI::HTTP`, so the `is_a?(URI::HTTP)` check accepts both http and https.)

- [ ] **Step 4: Update RBS**

In `sig/peddler/api.rbs`, add the instance variable and reader (in the `@...`/`attr_reader` block):

```rbs
    @base_url: URI::HTTP?
```

```rbs
    attr_reader base_url: URI::HTTP?
```

Change the `initialize` and `endpoint_uri` signatures:

```rbs
    def initialize: (String aws_region, String access_token, ?retries: Integer, ?http: HTTP::Client, ?base_url: String?) -> void

    def endpoint_uri: () -> URI::HTTP
```

Add to the private section:

```rbs
    def parse_base_url: (String? value) -> URI::HTTP?
```

- [ ] **Step 5: Run tests and type check to verify they pass**

Run: `bundle exec ruby -Itest test/peddler/api_test.rb`
Expected: PASS (all, including the pre-existing tests).

Run: `bundle exec steep check`
Expected: No new errors.

Run: `bundle exec rubocop lib/peddler/api.rb -A`
Expected: No offenses (auto-corrects formatting if needed).

- [ ] **Step 6: Commit**

```bash
git add lib/peddler/api.rb sig/peddler/api.rbs test/peddler/api_test.rb
git commit -m "Add base_url endpoint override"
```

---

## Task 2: Host header carries non-default port

**Files:**
- Modify: `lib/peddler/api.rb:59-66` (http) and add private `host_header`
- Modify: `sig/peddler/api.rbs`
- Test: `test/peddler/api_test.rb`

- [ ] **Step 1: Write the failing tests**

Add inside `class APITest` (near the existing `test_host_header`, around line 24):

```ruby
def test_host_header_includes_non_default_port
  api = API.new("eu-west-1", "access_token", base_url: "http://localhost:9001")
  assert_equal("localhost:9001", api.http.default_options.headers["Host"])
end

def test_host_header_omits_default_port
  assert_equal("sellingpartnerapi-eu.amazon.com", @api.http.default_options.headers["Host"])
end
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `bundle exec ruby -Itest test/peddler/api_test.rb -n /host_header/`
Expected: FAIL — `test_host_header_includes_non_default_port` gets `"localhost"` instead of `"localhost:9001"`.

- [ ] **Step 3: Implement `host_header` and use it**

In `lib/peddler/api.rb`, change the `Host` header line inside `http` (line 62) from:

```ruby
        "Host" => endpoint_uri.host,
```

to:

```ruby
        "Host" => host_header,
```

Add this private method (just above `parse_base_url`):

```ruby
    def host_header
      uri = endpoint_uri
      uri.port == uri.default_port ? uri.host : "#{uri.host}:#{uri.port}"
    end
```

- [ ] **Step 4: Update RBS**

In `sig/peddler/api.rbs` private section, add:

```rbs
    def host_header: () -> String
```

- [ ] **Step 5: Run tests, type check, lint**

Run: `bundle exec ruby -Itest test/peddler/api_test.rb`
Expected: PASS (all).

Run: `bundle exec steep check`
Expected: No new errors.

Run: `bundle exec rubocop lib/peddler/api.rb -A`
Expected: No offenses.

- [ ] **Step 6: Commit**

```bash
git add lib/peddler/api.rb sig/peddler/api.rbs test/peddler/api_test.rb
git commit -m "Include port in Host header for custom endpoints"
```

---

## Task 3: Sandbox interaction (mutual exclusion + guard bypass)

**Files:**
- Modify: `lib/peddler/api.rb:46-49` (sandbox), `lib/peddler/api.rb:127-133` (guards)
- Test: `test/peddler/api_test.rb`

- [ ] **Step 1: Write the failing tests**

Add inside `class APITest`:

```ruby
def test_sandbox_with_base_url_raises
  api = API.new("eu-west-1", "access_token", base_url: "http://localhost:9001")
  assert_raises(ArgumentError) { api.sandbox }
end

def test_sandbox_predicate_false_with_base_url
  api = API.new("eu-west-1", "access_token", base_url: "http://localhost:9001")
  refute_predicate(api, :sandbox?)
end

def test_guards_bypassed_with_base_url
  test_api_class = Class.new(API) do
    def perform_must_sandbox_operation = must_sandbox!
    def perform_cannot_sandbox_operation = cannot_sandbox!
  end
  api = test_api_class.new("eu-west-1", "access_token", base_url: "http://localhost:9001")

  assert_nil(api.perform_must_sandbox_operation)
  assert_nil(api.perform_cannot_sandbox_operation)
end
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `bundle exec ruby -Itest test/peddler/api_test.rb -n /base_url/`
Expected: FAIL — `test_sandbox_with_base_url_raises` does not raise; `test_guards_bypassed_with_base_url` raises `MustSandbox` instead of returning nil.

- [ ] **Step 3: Implement the guard bypass and mutual exclusion**

In `lib/peddler/api.rb`, change `sandbox` (currently lines 46-49) to:

```ruby
    def sandbox
      raise ArgumentError, "cannot use sandbox with a custom base_url" if base_url

      @sandbox = true
      self
    end
```

Change `cannot_sandbox!` and `must_sandbox!` (currently lines 127-133) to:

```ruby
    def cannot_sandbox!
      return if base_url

      raise CannotSandbox, "cannot run in a sandbox" if sandbox?
    end

    def must_sandbox!
      return if base_url

      raise MustSandbox, "must run in a sandbox" unless sandbox?
    end
```

- [ ] **Step 4: Run tests, type check, lint**

Run: `bundle exec ruby -Itest test/peddler/api_test.rb`
Expected: PASS (all, including pre-existing `test_cannot_sandbox!` and `test_must_sandbox!`).

Run: `bundle exec steep check`
Expected: No new errors (signatures unchanged in this task).

Run: `bundle exec rubocop lib/peddler/api.rb -A`
Expected: No offenses.

- [ ] **Step 5: Commit**

```bash
git add lib/peddler/api.rb test/peddler/api_test.rb
git commit -m "Bypass sandbox guards under base_url override"
```

---

## Task 4: Documentation (README + CHANGELOG)

**Files:**
- Modify: `README.md` (new subsection before `### Available APIs`, currently line 215)
- Modify: `CHANGELOG.md` (under `## [Unreleased]`, around line 5)

- [ ] **Step 1: Add the README subsection**

In `README.md`, insert this new subsection immediately before the `### Available APIs` heading:

```markdown
### Sandbox and custom endpoints

Switch a client to Amazon's hosted sandbox with `sandbox`:

```ruby
api = Peddler.orders_v0.new(aws_region, access_token).sandbox
```

To point a client at a different backend entirely — a local mock, a recording proxy, or Amazon's [Sample AI Sandbox for SP-API](https://github.com/amzn/selling-partner-api-samples/tree/main/local-ai-sandbox) (default `http://localhost:9001`) — pass `base_url`:

```ruby
api = Peddler.orders_v0.new(aws_region, access_token, base_url: "http://localhost:9001")
```

`base_url` overrides the destination for every request the client makes. It is mutually exclusive with `sandbox` (combining them raises `ArgumentError`), and `sandbox?` stays `false`. Only the scheme, host, and port of `base_url` are used; a path is ignored.
```

(Note: in the file, use a fenced code block for each Ruby snippet exactly as shown.)

- [ ] **Step 2: Add the CHANGELOG entry**

In `CHANGELOG.md`, under `## [Unreleased]`, add an `### Added` section above the existing `### Fixed` (keep `### Added` before `### Fixed`):

```markdown
### Added

- Add `base_url` option to point a client at a custom backend (local sandbox, mock, or proxy) instead of Amazon's endpoints
```

- [ ] **Step 3: Verify formatting**

Run: `bundle exec rake test` is not needed for docs, but confirm nothing else references these files. Visually confirm the README renders (no broken fences).

- [ ] **Step 4: Commit**

```bash
git add README.md CHANGELOG.md
git commit -m "Document base_url option"
```

---

## Task 5: Full suite verification

**Files:** none (verification only)

- [ ] **Step 1: Run the whole suite + lint + types**

Run: `bundle exec rake`
Expected: All tests pass, RuboCop clean.

Run: `bundle exec steep check`
Expected: No errors.

- [ ] **Step 2: If anything fails, fix and re-run before finishing.**

---

## Self-Review

**Spec coverage:**
- Surface (`base_url:` kwarg) → Task 1. ✓
- Validation (full http(s) URL, ArgumentError) → Task 1 (`parse_base_url`, tests for no-scheme and garbage). ✓
- Routing (`endpoint_uri` precedence, `.dup`) → Task 1. ✓
- Host header with non-default port → Task 2. ✓
- Guard bypass (`return if base_url`) → Task 3. ✓
- `.sandbox` raises when `base_url` set → Task 3. ✓
- `sandbox?` returns `false` → Task 3 (`test_sandbox_predicate_false_with_base_url`). ✓
- No-path-prefix limitation → documented in README (Task 4) and spec; not enforced. ✓
- Types (`sig/peddler/api.rbs`, steep) → Tasks 1, 2. ✓
- README + CHANGELOG → Task 4. ✓
- `Endpoint` untouched → no task modifies `endpoint.rb`. ✓

**Placeholder scan:** No TBD/TODO; every code step shows full method bodies and full test code. ✓

**Type consistency:** `base_url` (reader, `URI::HTTP?`), `parse_base_url(value)`, `host_header`, `endpoint_uri -> URI::HTTP` are named identically across Ruby code, RBS, and tests. Guard methods keep their existing names and signatures. ✓
