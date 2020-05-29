require 'rails_helper'

RSpec.describe AccountReset::CreateRequest do
  subject(:create_request) { described_class.new(user) }

  describe '#call' do
    context 'when the user does not have a phone' do
      let(:user) { build(:user) }

      it 'does not include a message_id in the response' do
        response = create_request.call

        expect(response.to_h[:message_id]).to be_blank
      end
    end

    context 'when the user has a phone' do
      let(:user) { build(:user, :with_phone) }

      it 'includes a message_id in the response' do
        response = create_request.call

        expect(response.to_h[:message_id]).to be_present
      end
    end
  end
end
