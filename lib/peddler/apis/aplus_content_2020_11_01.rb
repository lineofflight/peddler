# frozen_string_literal: true

# This file is generated. Do not edit.

module Peddler
  module APIs
    # Selling Partner API for A+ Content Management
    #
    # With the A+ Content API, you can build applications that help selling partners add rich marketing content to their
    # Amazon product detail pages. A+ Content helps selling partners share their brand and product story, which helps
    # buyers make informed purchasing decisions. Selling partners assemble content by choosing from content modules and
    # adding images and text.
    #
    # @see https://github.com/amzn/selling-partner-api-models/blob/main/models/aplus-content-api-model/aplusContent_2020-11-01.json
    module AplusContent20201101
      # Typed models of successful responses, by native operation key
      PARSERS = {
        "aplus_content_2020_11_01.create_content_document" => -> { PostContentDocumentResponse },
        "aplus_content_2020_11_01.create_media" => -> { CreateMediaResponse },
        "aplus_content_2020_11_01.get_content_document" => -> { GetContentDocumentResponse },
        "aplus_content_2020_11_01.get_media" => -> { GetMediaResponse },
        "aplus_content_2020_11_01.list_content_document_asin_relations" => -> { ListContentDocumentASINRelationsResponse },
        "aplus_content_2020_11_01.post_content_document_approval_submission" => -> { PostContentDocumentApprovalSubmissionResponse },
        "aplus_content_2020_11_01.post_content_document_asin_relations" => -> { PostContentDocumentASINRelationsResponse },
        "aplus_content_2020_11_01.post_content_document_suspend_submission" => -> { PostContentDocumentSuspendSubmissionResponse },
        "aplus_content_2020_11_01.search_content_documents" => -> { SearchContentDocumentsResponse },
        "aplus_content_2020_11_01.search_content_publish_records" => -> { SearchContentPublishRecordsResponse },
        "aplus_content_2020_11_01.update_content_document" => -> { PostContentDocumentResponse },
        "aplus_content_2020_11_01.update_media" => -> { UpdateMediaResponse },
        "aplus_content_2020_11_01.validate_content_document_asin_relations" => -> { ValidateContentDocumentASINRelationsResponse },
      }.freeze
    end
  end
end
