require 'rails_helper'

describe V1::Jwt::Encode, type: :service do
  subject(:context) { described_class.call(payload) }

  context 'when encoding a token for a given payload' do
    let(:payload) {
      {
        user: create(:user),
        type: 'basic'
      }
    }

    it 'returns a signed encoded token' do
      token = context.result

      expect(token).not_to be_nil
    end
  end
end
