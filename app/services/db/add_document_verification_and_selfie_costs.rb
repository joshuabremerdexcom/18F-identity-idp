# frozen_string_literal: true

module Db
  class AddDocumentVerificationAndSelfieCosts
    def initialize(user_id:, service_provider:, liveness_checking_enabled:)
      @service_provider = service_provider
      @liveness_checking_enabled = liveness_checking_enabled
      @user_id = user_id
    end

    def call(client_response)
      add_cost(:acuant_front_image)
      add_cost(:acuant_back_image)
      add_cost(:acuant_result) if client_response.to_h[:billed]
    end

    private

    attr_reader :service_provider, :user_id, :liveness_checking_enabled

    def add_cost(token)
      Db::SpCost::AddSpCost.call(service_provider, token)
    end
  end
end
