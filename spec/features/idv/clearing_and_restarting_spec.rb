require 'rails_helper'

RSpec.describe 'clearing IdV and restarting', allowed_extra_analytics: [:*] do
  include IdvStepHelper

  let(:user) { user_with_2fa }

  context 'during verification code entry', js: true do
    before do
      start_idv_from_sp
      complete_idv_steps_with_gpo_before_confirmation_step(user)
    end

    context 'before signing out' do
      before do
        visit idv_verify_by_mail_enter_code_path
      end

      it_behaves_like 'clearing and restarting idv'
    end

    context 'after signing out' do
      before do
        visit account_path
        first(:button, t('links.sign_out')).click
        start_idv_from_sp
        sign_in_live_with_2fa(user)
      end

      it_behaves_like 'clearing and restarting idv'
    end
  end
end
