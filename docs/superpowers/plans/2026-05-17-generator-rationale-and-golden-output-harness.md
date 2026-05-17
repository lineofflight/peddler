# Generator Rationale + Pinned Golden-Output Harness Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Document why Peddler's OpenAPI generator is custom, and establish a *spec-pinned* golden-output check that proves any generator refactor produces byte-identical output — without false failures from Amazon's specs moving underneath it.

**Architecture:** Record the upstream `selling-partner-api-models` commit SHA in a committed pin file. `Specs` checks out that pinned SHA for normal generation (`rake generate`) and for the regression check (`rake generate:verify`). A new explicit `rake generate:update` is the *only* path that advances the pin (pull latest → regenerate → rewrite pin atomically); the nightly `update-models.yml` workflow calls it. `verify-generated` CI job regenerates at the pin and fails on any git drift in committed generated paths.

**Tech Stack:** Ruby, Rake, Minitest, `git`, GitHub Actions, `gh` CLI.

**Design decisions already settled (do not relitigate during execution):**

- **`generate` reproduces; it does not track HEAD.** Floating spec state is the root cause the pin fixes. If `generate` tracked HEAD and only `verify` pinned, committed output could silently diverge from the pin and unrelated PRs would fail `verify`. So pinned-sync is the *default* for `generate` and `verify`.
- **Advancing the pin is a separate task (`generate:update`), not an env flag.** It bundles pull + regenerate + rewrite-pin so the pin and committed output cannot desync. Reversible if disliked.
- **`update-models.yml` owns spec→code propagation.** It opens a PR when Amazon changes. `verify-generated` owns *generator-regression* detection at a fixed spec revision. The pin is what keeps these two from fighting.
- **Full regeneration, in place, asserted git-clean.** `Config::BASE_PATH` is a hard-coded constant; injecting it to enable subset/temp-dir generation is exactly the abstraction we are not adding yet. Slow (minutes, network) → dedicated CI job, never part of `rake test`. This mirrors the proven nightly `update-models` approach.
- **Out of scope:** the safe-prefix refactor and spike-gated IR work. Their verification *is* this harness. Captured as the Task 6 tracking issue.

---

### Task 1: Generator rationale section in README

**Files:**
- Modify: `lib/generator/README.md` (insert after line 1, the `# Generator System` heading)

- [ ] **Step 1: Add the rationale section**

Insert immediately after the first line (`# Generator System`), before the existing `Entry point:` line, separated by a blank line:

```markdown

## Why this generator exists

Peddler generates its SP-API client from Amazon's specs with a hand-written
generator rather than [openapi-generator][oag] or swagger-codegen. This is a
deliberate, re-evaluated decision — not legacy inertia.

**Why not an off-the-shelf generator:**

- openapi-generator's Ruby generator does not support `oneOf`/`anyOf`/`allOf`
  composition or AWS SigV4. SP-API specs lean on `allOf` (see
  `builders/type.rb` `merge_from_all_of`) and `anyOf` (see
  `parsers/json_schema_extractor.rb`). Closer to a hard blocker than a
  quality preference.
- Its Ruby output is an untyped generic client: no RBS, no `Structure`-typed
  response models, no idiomatic naming. That typed surface is Peddler's value.
- Amazon's own official SDK is openapi-generator-based but ships no Ruby
  target.
- Adopting it would still require a forked template set plus an SP-API
  spec-preprocessing layer — not less maintenance than this generator.

**What this generator does that a generic one will not:** unifies Amazon's
many money shapes into one `Peddler::Money`; breaks only cycle-causing type
edges with lazy string class names; applies JSON Patch to fix known Amazon
schema bugs; parses rate limits out of documentation prose; emits RBS by
introspecting generated classes via the `structure` gem; handles JSON
notification/report/feed schemas and Data Kiosk GraphQL.

**Maintenance contract:** generated code is committed and corresponds to the
exact upstream spec revision recorded in `selling-partner-api-models.sha`.
`bundle exec rake generate` reproduces against that pinned revision.
`bundle exec rake generate:verify` regenerates at the pin and fails if output
drifts from what is committed — so any generator refactor must keep output
byte-identical (or land the intended change in the same commit). Advancing to
newer Amazon specs is a deliberate act: `bundle exec rake generate:update`
pulls latest, regenerates, and rewrites the pin in one step (this is what the
nightly `update-models` workflow runs). Treat `generate:verify` as the source
of truth, not unit tests of internals.

[oag]: https://openapi-generator.tech/docs/generators/ruby/

```

- [ ] **Step 2: Verify**

Run: `head -5 lib/generator/README.md`
Expected: line 1 `# Generator System`, blank line, then `## Why this generator exists`.

Run: `grep -c "generate:update" lib/generator/README.md`
Expected: `1` (or greater).

- [ ] **Step 3: Commit**

```bash
git add lib/generator/README.md
git commit -m "Document why the generator is custom"
```

---

### Task 2: Pin file plumbing and `Specs` rewrite

**Files:**
- Modify: `lib/generator/specs.rb` (full rewrite of the class body)
- Modify: `lib/generator.rb` (the `setup` method; add `generated_paths`)
- Create: `selling-partner-api-models.sha` (placeholder, overwritten by Task 3)
- Test: `test/generator/specs_test.rb` (Create)
- Test: `test/generator/verify_task_test.rb` (Create)

- [ ] **Step 1: Confirm the pin file will not be gitignored**

Run: `git check-ignore -v selling-partner-api-models.sha; echo "exit=$?"`
Expected: prints nothing and `exit=1` (not ignored).
If it prints a matching `.gitignore` rule (`exit=0`): open `.gitignore`, find the `selling-partner-api-models` line, and add this line immediately after it:

```gitignore
!selling-partner-api-models.sha
```

Re-run the `git check-ignore -v` command and confirm `exit=1` before continuing.

- [ ] **Step 2: Create a placeholder pin file**

Create `selling-partner-api-models.sha` with exactly this content (a real SHA is written by Task 3; this placeholder only lets tests and tasks load):

```
0000000000000000000000000000000000000000
```

- [ ] **Step 3: Write failing tests for `Specs`**

Create `test/generator/specs_test.rb`:

```ruby
# frozen_string_literal: true

require "helper"
require "generator/specs"

module Generator
  class SpecsTest < Minitest::Test
    def test_sync_requires_a_ref_keyword
      assert_raises(ArgumentError) { Specs.sync }
    end

    def test_pinned_sha_reads_and_strips_the_pin_file
      assert_match(/\A[0-9a-f]{40}\z/, Specs.pinned_sha)
    end

    def test_pin_file_path_is_repo_root
      assert_equal(
        File.join(Generator::Config::BASE_PATH, "selling-partner-api-models.sha"),
        Specs::PIN_FILE,
      )
    end
  end
end
```

- [ ] **Step 4: Run the tests to verify they fail**

Run: `bundle exec ruby -Itest test/generator/specs_test.rb`
Expected: FAIL — `NameError: uninitialized constant Generator::Specs::PIN_FILE` and `NoMethodError` for `pinned_sha`.

- [ ] **Step 5: Rewrite `lib/generator/specs.rb`**

Replace the entire file with:

```ruby
# frozen_string_literal: true

require "fileutils"
require "open3"
require_relative "support/logger"
require_relative "support/config"

module Generator
  # Manages the local checkout of Amazon's selling-partner-api-models repo.
  #
  # Generation is reproducible: `sync(ref:)` checks out an exact revision (the
  # pinned SHA for `generate`/`verify`). `advance!` is the only path that moves
  # the pin forward, used by `rake generate:update` / the nightly workflow.
  class Specs
    REPO_URL = "https://github.com/amzn/selling-partner-api-models.git"
    PIN_FILE = File.join(Config::BASE_PATH, "selling-partner-api-models.sha")

    class << self
      # Ensure the local clone exists and is checked out at +ref+.
      def sync(ref:)
        ensure_clone!
        fetch!
        checkout!(ref)
        Generator.logger.info("Synced API models to #{ref}")
      end

      # Pull the latest upstream default branch, point the pin at it, and
      # return the resolved SHA. Caller is responsible for regenerating.
      def advance!
        ensure_clone!
        fetch!
        checkout!("origin/HEAD")
        sha = resolve_head
        File.write(PIN_FILE, "#{sha}\n")
        Generator.logger.info("Advanced API models pin to #{sha}")
        sha
      end

      def pinned_sha
        File.read(PIN_FILE).strip
      end

      def directory
        File.join(Config::BASE_PATH, "selling-partner-api-models")
      end

      private

      def ensure_clone!
        FileUtils.rm_rf(directory) if Dir.exist?(directory) && Dir.empty?(directory)
        return if Dir.exist?(directory)

        Generator.logger.info("Cloning Amazon Selling Partner API models")
        run!("git", "clone", "--quiet", REPO_URL, directory)
      end

      def fetch!
        run!("git", "-C", directory, "fetch", "--quiet", "origin")
      end

      def checkout!(ref)
        run!("git", "-C", directory, "-c", "advice.detachedHead=false", "checkout", "--quiet", ref)
      end

      def resolve_head
        stdout, stderr, status = Open3.capture3("git", "-C", directory, "rev-parse", "HEAD")
        raise "Failed to resolve API models HEAD: #{stderr}" unless status.success?

        stdout.strip
      end

      def run!(*argv)
        _stdout, stderr, status = Open3.capture3(*argv)
        raise "Command failed (#{argv.join(" ")}): #{stderr}" unless status.success?
      end
    end
  end
end
```

- [ ] **Step 6: Point `Generator.setup` at the pinned SHA and add `generated_paths`**

In `lib/generator.rb`, change the `setup` method body from `Specs.sync` to:

```ruby
    def setup
      IntrospectionLoader.setup
      Specs.sync(ref: Specs.pinned_sha)
    end
```

In the same `class << self` block, add immediately after `setup`:

```ruby
    def generated_paths
      %w[
        lib/peddler.rb
        lib/peddler/apis
        lib/peddler/notifications
        lib/peddler/reports
        lib/peddler/feeds
        lib/peddler/data_kiosk
        sig/peddler/apis
        sig/peddler/notifications
        sig/peddler/reports
        sig/peddler/feeds
        sig/peddler/data_kiosk
      ]
    end
```

- [ ] **Step 7: Run the `Specs` tests to verify they pass**

Run: `bundle exec ruby -Itest test/generator/specs_test.rb`
Expected: PASS, 3 runs, 0 failures, 0 errors.

- [ ] **Step 8: Write and pass the generated-paths test**

Create `test/generator/verify_task_test.rb`:

```ruby
# frozen_string_literal: true

require "helper"
require "generator"

module Generator
  class VerifyTaskTest < Minitest::Test
    EXPECTED_PATHS = %w[
      lib/peddler.rb
      lib/peddler/apis
      lib/peddler/notifications
      lib/peddler/reports
      lib/peddler/feeds
      lib/peddler/data_kiosk
      sig/peddler/apis
      sig/peddler/notifications
      sig/peddler/reports
      sig/peddler/feeds
      sig/peddler/data_kiosk
    ].freeze

    def test_generated_paths_match_expected
      assert_equal(EXPECTED_PATHS.sort, Generator.generated_paths.sort)
    end

    def test_generated_paths_are_tracked_by_git
      Generator.generated_paths.each do |path|
        tracked = system("git", "ls-files", "--error-unmatch", path, out: File::NULL, err: File::NULL)
        assert(tracked, "#{path} should contain committed generated code but git does not track it")
      end
    end
  end
end
```

Run: `bundle exec ruby -Itest test/generator/verify_task_test.rb`
Expected: `test_generated_paths_match_expected` PASSES. `test_generated_paths_are_tracked_by_git` may fail only for `lib/peddler/data_kiosk` / `sig/peddler/data_kiosk` if those are not committed generated code — if so, remove those entries from BOTH `EXPECTED_PATHS` and `Generator.generated_paths`, re-run, and confirm both tests pass. Do not add untracked paths to the guard.

- [ ] **Step 9: Commit**

```bash
git add lib/generator/specs.rb lib/generator.rb selling-partner-api-models.sha test/generator/specs_test.rb test/generator/verify_task_test.rb
git commit -m "Pin spec revision; reproduce generation from the pin"
```

---

### Task 3: `generate:update` and `generate:verify` rake tasks; bootstrap the pin

**Files:**
- Modify: `Rakefile` (add two tasks inside the existing `namespace :generate do ... end`)
- Modify: `selling-partner-api-models.sha` (overwritten with the real bootstrap SHA)
- Modify: generated output under `Generator.generated_paths` (regenerated against the bootstrap pin)

- [ ] **Step 1: Add the `generate:update` task**

In `Rakefile`, inside `namespace :generate do`, add before the namespace's closing `end`:

```ruby

  desc "Pull latest Amazon specs, regenerate, and advance the pin"
  task :update do
    require_relative "lib/generator"
    Generator::Specs.advance!
    Generator.generate
  end
```

`Generator.generate` calls `setup`, which now syncs to the just-written pin (idempotent re-checkout of the same SHA).

- [ ] **Step 2: Add the `generate:verify` task**

In `Rakefile`, inside `namespace :generate do`, add before the namespace's closing `end`:

```ruby

  desc "Regenerate at the pinned spec revision; fail if committed output drifts"
  task verify: :generate do
    require "open3"

    paths = Generator.generated_paths
    status_out, _err, status = Open3.capture3("git", "status", "--porcelain", "--", *paths)
    raise "git status failed" unless status.success?

    if status_out.strip.empty?
      puts "Generated output matches committed code at pinned spec #{Generator::Specs.pinned_sha}."
    else
      diff_out, = Open3.capture2("git", "diff", "--", *paths)
      warn "Generated output drifted from committed code:"
      warn status_out
      warn diff_out
      abort "Generator verification failed: regeneration at the pinned spec changed " \
        "committed output. Commit the intended change or investigate the regression."
    end
  end
```

`task verify: :generate` chains the existing top-level `:generate` task, which runs `Generator.generate` → `setup` → `Specs.sync(ref: pinned_sha)`. No extra setup step needed.

- [ ] **Step 3: Bootstrap the pin (one-time)**

This makes committed output provably correspond to the pin. It pulls Amazon latest, writes the real SHA, and regenerates.

Run: `bundle exec rake generate:update`
Expected (several minutes, network): completes 0; `selling-partner-api-models.sha` now contains a 40-hex SHA; generated files under `Generator.generated_paths` may have changed (whatever Amazon shipped since the last committed regeneration).

Run: `cat selling-partner-api-models.sha`
Expected: a single 40-character hex line, not all zeros.

- [ ] **Step 4: Verify the harness now passes on the bootstrapped tree**

Run: `bundle exec rake generate:verify`
Expected: ends with `Generated output matches committed code at pinned spec <sha>.` and exit 0. (It re-runs generation; output already matches what Step 3 just produced, so the tree is clean.)

- [ ] **Step 5: Prove the harness detects drift**

```bash
bundle exec rake generate
sed -i.bak '2i # drift canary' lib/peddler.rb && rm -f lib/peddler.rb.bak
bundle exec ruby -e 'require "open3"; require "./lib/generator"; o,_,_=Open3.capture3("git","status","--porcelain","--",*Generator.generated_paths); abort("NO DRIFT DETECTED") if o.strip.empty?; puts "drift detected:"; puts o'
git checkout -- lib/peddler.rb
```

Expected: prints `drift detected:` followed by ` M lib/peddler.rb`, then restores the file. (This isolates the detection logic without a second multi-minute regen.)

- [ ] **Step 6: Run the full default suite**

Run: `bundle exec rake test`
Expected: all pass, including `specs_test.rb` and `verify_task_test.rb`. `rake test` does not run `generate:verify`, so it stays fast.

- [ ] **Step 7: Commit the bootstrap**

```bash
git add Rakefile selling-partner-api-models.sha
git add -- $(bundle exec ruby -rgenerator -e 'print Generator.generated_paths.join(" ")')
git commit -m "Add generate:update and generate:verify; bootstrap spec pin"
```

---

### Task 4: Point the nightly workflow at `generate:update`

**Files:**
- Modify: `.github/workflows/update-models.yml` (the "Generate code from API models" step)

- [ ] **Step 1: Swap the generate command**

In `.github/workflows/update-models.yml`, change the step:

```yaml
      - name: Generate code from API models
        run: bundle exec rake generate
```

to:

```yaml
      - name: Generate code from API models
        run: bundle exec rake generate:update
```

No other change is needed: the workflow's later `git add -A` already stages every change, which now includes `selling-partner-api-models.sha`, so the pin advances inside the same PR as the regenerated output.

- [ ] **Step 2: Verify the workflow is valid YAML**

Run: `ruby -ryaml -e "c=YAML.load_file('.github/workflows/update-models.yml'); puts c['jobs']['update-api']['steps'].map{|s| s['run']}.compact"`
Expected: the printed list includes `bundle exec rake generate:update` and not `bundle exec rake generate`.

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/update-models.yml
git commit -m "Nightly job advances the spec pin via generate:update"
```

---

### Task 5: Wire `generate:verify` into CI

**Files:**
- Modify: `.github/workflows/ci.yml` (add a job after `test`, before `release`)

- [ ] **Step 1: Add the `verify-generated` job**

In `.github/workflows/ci.yml`, between the `test` job's last line (`      - run: bundle exec rake test`) and the `release:` job, insert:

```yaml
  verify-generated:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: "4.0"
          bundler-cache: true
      - run: bundle exec rake generate:verify

```

- [ ] **Step 2: Verify**

Run: `ruby -ryaml -e "c=YAML.load_file('.github/workflows/ci.yml'); abort('missing') unless c['jobs'].key?('verify-generated'); puts c['jobs'].keys.join(', ')"`
Expected: `rubocop, steep, verify-links, test, verify-generated, release`

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/ci.yml
git commit -m "Run generate:verify in CI"
```

---

### Task 6: Tracking issue for the cleanup backlog

**Files:** none (creates a GitHub issue via `gh`)

Creating an issue is externally visible. **Do not run `gh issue create` without explicit user confirmation at execution time.** Present the command and body, get a yes, then run it.

- [ ] **Step 1: Confirm with the user, then create the issue**

```bash
gh issue create --title "Generator cleanup: tighten internal boundaries (output-preserving)" --body "$(cat <<'EOF'
Background: a three-way deep dive (Claude, Codex, Gemini) converged on keeping
the custom generator and NOT switching to openapi-generator. Rationale is in
`lib/generator/README.md`. `rake generate:verify` (CI job `verify-generated`)
regenerates at the pinned spec revision and guards every refactor below:
generated output must stay byte-identical.

## Safe prefix (no new abstraction; do these first)
- [ ] Finish the half-applied `SchemaGenerator` mixin: collapse the
      near-identical `generate` methods in `notification.rb`, `report.rb`,
      `feed.rb`, `data_kiosk.rb`.
- [ ] Extract the duplicated cycle-edge detection in `builders/type.rb`
      (`ruby_type_for` vs `uses_string_class_names?`) into one method.
- [ ] Collapse the triplicate `needs_money?` (Type, SchemaHelpers,
      SchemaGenerator) into one definition.
- [ ] Delete dead indirection (`API#convenience_method_name` aliasing `name`;
      `API#openapi_spec` aliasing `model`).

## Spike-gated (prove on a throwaway branch against `rake generate:verify`
## BEFORE writing an implementation plan; revert if it does not shrink code)
- [ ] Introduce a `Schema`/`Property` value object wrapping the parsed hash
      (`ref?`, `ref_name`, `array?`, `object?`, `money_like?`, `item_schema`).
      Migrate `TypeResolver` -> `Type` -> `JsonSchemaExtractor` incrementally.
- [ ] Split `JsonSchemaExtractor` (extraction vs. ref-rewriting) once the
      value object exists. Goal: templates consume normalized values and stop
      invoking resolution logic.

## Explicitly rejected
- General-purpose OpenAPI generator (deletes the SP-API value).
- Migrating to openapi-generator/swagger-codegen (no oneOf/anyOf/allOf or
  SigV4 in its Ruby generator; untyped, no RBS).
- Standalone peddler-generator gem (two-repo release tax; no real consumer).

Acceptance for every checked item: `bundle exec rake generate:verify` passes
with no diff.
EOF
)"
```

- [ ] **Step 2: Record the issue URL in this plan and commit**

```bash
git add docs/superpowers/plans/2026-05-17-generator-rationale-and-golden-output-harness.md
git commit -m "Link generator cleanup tracking issue"
```

---

## Self-Review

**1. Spec coverage:**
- README rationale → Task 1. ✓
- Record the SHA → Task 2 (pin file + `Specs.pinned_sha`). ✓
- Teach sync to honor the pin → Task 2 (`Specs.sync(ref:)`, `setup` uses `pinned_sha`). ✓
- One-time bootstrap so committed output matches the pin → Task 3 Step 3. ✓
- `update-models` advances the pin in the same PR → Task 4. ✓
- Golden check + CI enforcement → Task 3 (`generate:verify`) + Task 5 (`verify-generated`). ✓
- Cleanup backlog preserved → Task 6. ✓
- Settled design decisions (pinned default, explicit advance task, two workflows don't fight) reflected in tasks. ✓

**2. Placeholder scan:** README, `specs.rb`, `Rakefile` tasks, tests, both workflow edits, and the issue body are provided in full. The two conditionals (`!selling-partner-api-models.sha` gitignore fix; `data_kiosk` path removal) are deterministic checks with exact commands and exact remedies, not TBDs. The placeholder pin SHA is intentional and explicitly overwritten by Task 3 Step 3.

**3. Type consistency:** `Specs.sync(ref:)`, `Specs.advance!`, `Specs.pinned_sha`, `Specs::PIN_FILE`, `Specs::REPO_URL`, `Generator.generated_paths` are defined once in Task 2 and referenced identically by Tasks 3–5 and the tests. `Generator.setup` is updated in the same task that changes `Specs.sync`'s signature, so no caller is left calling the old zero-arg form. CI job name `verify-generated` is consistent across Task 5 steps. Task ordering is correct: pin plumbing (2) precedes the tasks that bootstrap and consume it (3), which precedes wiring the nightly (4) and CI (5).

**Note on TDD shape:** `Specs` and `generated_paths` are genuinely test-driven (Task 2). The multi-minute regeneration behavior (`generate:update`/`generate:verify`) is verified by running it with exact expected output and an explicit drift-detection proof, by design kept out of `rake test`. Tasks 1, 4, 5, 6 are doc/CI/issue work with concrete non-test verification.
