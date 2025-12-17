# typed: true
# frozen_string_literal: true

class AIPromptPair < ApplicationRecord
  extend T::Sig

  sig { params(model: String).void }
  def perform(model)
    chat = RubyLLM.chat
    response = chat.ask prompt
    update!(response: response, model: model, version: (version || 0) + 1)
  end
end
