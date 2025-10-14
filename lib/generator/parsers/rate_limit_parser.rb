# frozen_string_literal: true

module Generator
  class RateLimitParser
    attr_reader :operation

    def initialize(operation)
      @operation = operation
    end

    # CAUTION: This method parses rate limits from human-readable documentation. This is inherently fragile. Amazon
    # could change their documentation format at any time without considering it a breaking change. However, this is the
    # only source for rate limit data in their OpenAPI specifications.
    #
    # Extracts the rate value (requests per second) from the usage plan table
    # Example table:
    # | Rate (requests per second) | Burst |
    # | ---- | ---- |
    # | 0.0167 | 20 |
    #
    # Returns: 0.0167 (rate value in requests per second)
    def parse
      pattern = %r{
        Burst\s*\|                      # Find "Burst |" at end of table header
        (?:\\n|\n)                      # Either literal \n string or actual newline
        \|(?:\s*-+\s*\|){2,3}           # Separator line (2-3 columns of dashes)
        (?:\\n|\n)                      # Either literal \n string or actual newline
        (?:\|[^|]*){0,1}                # Optional first column (e.g., "Default" in 3-column format)
        \|\s*(\S+)\s*\|                 # Capture rate value (always before burst value)
        [^|]*\|                         # Skip to burst column
      }mx

      match = operation["description"].match(pattern)
      if match
        rate_value = match[1]
        # Handle "n" as a special case - indicates variable/dynamic rate limits
        # We return :unknown to signal that rate limiting exists but no default is provided
        # See: https://developer-docs.amazon.com/sp-api/docs/fulfillment-inbound-api-rate-limits
        return :unknown if rate_value.downcase == "n"

        rate_value.to_f
      elsif operation["description"].match?(/Usage\s+[Pp]lans?:/)
        # Fail when we can't extract rate limit but Usage Plan exists. This likely means Amazon changed their
        # documentation format.
        raise "Failed to extract rate limit for #{operation["operationId"]}. Usage Plan found in description but " \
          "regex failed to match. This usually means Amazon changed their documentation format."
      end
    end
  end
end
