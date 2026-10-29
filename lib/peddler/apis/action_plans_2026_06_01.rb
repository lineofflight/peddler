# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # The Selling Partner API for Action Plans
    #
    # The Action Plans API allows you to create, configure, and execute action plans from pre-defined templates or
    # custom-built workflows.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/action-plans-api-model/actionPlans_2026-06-01.json
    class ActionPlans20260601 < API
      # Returns an action plan by ID. Use `includedData=steps` to include the plan's steps with their resolved input and
      # output values.
      #
      # @note This operation can make a static sandbox call.
      # @param action_plan_id [String] The unique identifier of the action plan (UUID).
      # @param locale [String] The locale for localized content, as an ISO 639 language code and ISO 3166 country code
      #   separated by a hyphen. Defaults to `en-US`.
      # @param included_data [Array<String>] Additional data to include in the response. Include `steps` to include the
      #   plan's steps with their resolved input and output values.
      # @return [Peddler::Response] The API response
      def get_action_plan(action_plan_id, locale: nil, included_data: nil)
        path = "/actionPlans/2026-06-01/plans/#{percent_encode(action_plan_id)}"
        params = {
          "locale" => locale,
          "includedData" => stringify_array(included_data),
        }.compact
        parser = -> { GetActionPlanResponse }
        get(path, params:, parser:)
      end

      # Creates an action plan from a template. Use `mode=PREVIEW` to return the plan without creating or executing it.
      # Omit `mode` to create the plan and submit it for execution.
      #
      # @note This operation can make a static sandbox call.
      # @param body [Hash] The request for action plan creation.
      # @param mode [String] The mode of operation. Set `PREVIEW` to return the plan without creating or executing it.
      #   Omit `mode` to create the plan and submit it for execution.
      # @param locale [String] The locale for localized content, as an ISO 639 language code and ISO 3166 country code
      #   separated by a hyphen. Defaults to `en-US`.
      # @return [Peddler::Response] The API response
      def create_action_plan(body, mode: nil, locale: nil)
        path = "/actionPlans/2026-06-01/plans"
        params = {
          "mode" => mode,
          "locale" => locale,
        }.compact
        parser = -> { GetActionPlanResponse }
        post(path, body:, params:, parser:)
      end

      # Returns a paginated list of the seller's action plans, sorted newest first by `createdDate`. Multiple filters
      # are combined with a logical AND. Multiple values in a single filter are combined with a logical OR.
      #
      # @note This operation can make a static sandbox call.
      # @param statuses [Array<String>] Filters by plan status. Known values: `DRAFT`, `PENDING_SELLING_PARTNER`,
      #   `PROCESSING`, `DONE`, `CANCELLED`, `PARTIAL`.
      # @param plan_template_ids [Array<String>] Filters by plan template IDs. Multiple values allowed.
      # @param action_item_ids [Array<String>] Filters by associated action item IDs. Multiple values allowed.
      # @param created_after [String] Plans created at or after this timestamp. Timestamp is in ISO 8601 format.
      # @param created_before [String] Plans created at or before this timestamp. Timestamp is in ISO 8601 format.
      # @param page_size [Integer] Maximum number of results per page.
      # @param page_token [String] A token to retrieve a specific page of results. Pass the `nextToken` value from a
      #   previous response. **Note:** The `previousToken` value is not yet supported.
      # @param locale [String] The locale for localized content, as an ISO 639 language code and ISO 3166 country code
      #   separated by a hyphen. Defaults to `en-US`.
      # @param included_data [Array<String>] Additional data to return in the response. Specify `steps` to return each
      #   plan's steps with their resolved input and output values. Known values: `steps`, `refinements`.
      # @return [Peddler::Response] The API response
      def list_action_plans(statuses: nil, plan_template_ids: nil, action_item_ids: nil, created_after: nil,
        created_before: nil, page_size: 10, page_token: nil, locale: nil, included_data: nil)
        path = "/actionPlans/2026-06-01/plans"
        params = {
          "statuses" => stringify_array(statuses),
          "planTemplateIds" => stringify_array(plan_template_ids),
          "actionItemIds" => stringify_array(action_item_ids),
          "createdAfter" => created_after,
          "createdBefore" => created_before,
          "pageSize" => page_size,
          "pageToken" => page_token,
          "locale" => locale,
          "includedData" => stringify_array(included_data),
        }.compact
        parser = -> { ListActionPlansResponse }
        get(path, params:, parser:)
      end
    end
  end
end
