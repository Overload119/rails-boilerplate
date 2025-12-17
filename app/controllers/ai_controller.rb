# typed: false
# frozen_string_literal: true

class AIController < ApplicationController
  def random_llm_request
    pair = AIPromptPair.create(prompt: 'Hello world!')

    AIPromptPair.perform('gpt-5.2-mini')

    render json: { success: true, pair: pair.as_json }
  end
end
