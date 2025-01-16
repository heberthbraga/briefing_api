require "rails_helper"

describe V1::Security::Authorize, type: :service do
  subject(:context) { described_class.call(headers) }

  context "when token is not present" do
    let(:headers) {
      {
        "Authorization" => "Bearer "
      }
    }

    it "fails" do
      expect(context).to be_failure

      user = context.result
      errors = context.errors
      messages = errors[:invalid_token]

      expect(user).to be_nil
      expect(errors).not_to be_empty
      expect(messages.first).to eq "The token is invalid"
    end
  end

  context "when token is present with wrong credentials" do
    let!(:token) { "token" }
    let!(:expected_mask) { "<mask>" }
    let(:headers) {
      {
        "Authorization" => "Bearer #{token}"
      }
    }
    let(:decoded_token) { { sub: expected_mask, type: "basic" } }

    it "fails" do
      allow(User).to receive(:find_by_masked_id).with(expected_mask).and_return(nil)
      expect(V1::Jwt::Decode).to receive(:call).and_return(double(result: decoded_token))

      expect(context).to be_failure

      user = context.result
      errors = context.errors
      messages = errors[:unauthorized]

      expect(user).to be_nil
      expect(errors).not_to be_empty
      expect(messages.first).to eq "Could not authorize the user"
    end
  end

  context "when token is present with correct credentials" do
    let!(:user) { create(:user) }
    let!(:token) { "token" }
    let(:headers) {
      {
        "Authorization" => "Bearer #{token}"
      }
    }
    let(:decoded_token) {
      { sub: user.masked_id, type: "basic" }
    }

    it "succeeds" do
      expect(V1::Jwt::Decode).to receive(:call).and_return(double(result: decoded_token))

      expect(context).to be_success

      current_user = context.result
      expect(current_user).not_to be_nil
      expect(current_user.email).to eq user.email
      expect(current_user.first_name).to eq user.first_name
    end
  end
end