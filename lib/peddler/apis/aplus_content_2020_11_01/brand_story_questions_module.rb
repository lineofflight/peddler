# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # A Brand Story card with question-and-answer pairs about your Brand.
      BrandStoryQuestionsModule = Structure.new do
        # @return [Array<QuestionAnswerPairs>] Exactly 3 question-answer pairs.
        attribute(:question_answer_pairs, [QuestionAnswerPairs], null: false, from: "questionAnswerPairs")
      end
    end
  end
end
