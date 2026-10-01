# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class AplusContent20201101
      # Wrapper for a single question-answer pair.
      QuestionAnswerPairs = Structure.new do
        # @return [QuestionAnswerPair]
        attribute(:question_answer_pair, QuestionAnswerPair, null: false, from: "questionAnswerPair")
      end
    end
  end
end
