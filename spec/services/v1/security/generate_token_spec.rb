require "rails_helper"

describe V1::Security::GenerateToken, type: :service do
  subject(:context) { described_class.call(authentication_method) }

  context 'when authenticating with valid basic credentials' do
    let(:token) { Faker::Crypto.sha512 }
    let(:user) { create(:user) }
    let(:basic_response) { { user: user, type: 'basic' } }
    let(:issuer_access_response) {
      {
        access_token: token,
        refresh_token: token
      }
    }
    let(:authentication_method) { V1::Security::AuthenticateWithBasic.call(user.email, user.password) }

    it 'returns a pair of current and refresh tokens' do
      expect(V1::Security::AuthenticateWithBasic).to receive(:call).and_return(double(success?: true, result: basic_response))
      expect(V1::Jwt::Encode).to receive(:call).and_return(double(result: token)).twice

      expect(context.result).not_to be_nil
      expect(context.result).to eq issuer_access_response
    end
  end

  context 'when authentication fails with invalid credentials' do
    before do
      create(:user)
    end
    let(:authentication_method) { V1::Security::AuthenticateWithBasic.call('john@example.com', 'test') }

    it 'returns nil' do
      expect(V1::Security::AuthenticateWithBasic).to receive(:call).and_return(double(success?: false))
      expect(context.result).to be_nil
    end
  end
end
