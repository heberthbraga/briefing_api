require "rails_helper"

describe V1::Registrations::Create, type: :service do
  describe '#call' do
    let(:valid_payload) do
      {
        email: 'test@example.com',
        first_name: 'John',
        last_name: 'Doe',
        password: 'password123',
        password_confirmation: 'password123',
        account_type: 'CUSTOMER'
      }
    end

    let(:invalid_payload) do
      {
        email: 'invalid-email',
        first_name: 'John',
        password: 'password123',
        password_confirmation: 'password123',
        account_type: 'CUSTOMER'
      }
    end

    context 'when the payload is valid' do
      before do
        create(:role, :customer)
      end

      it 'creates a new user and assigns the correct role' do
        result = described_class.call(valid_payload).result

        expect(result[:errors]).to be nil
        expect(result[:email]).to eq('test@example.com')
        expect(result[:first_name]).to eq('John')
        expect(result[:roles].map { |role| role[:name] }).to include("ROLE_CUSTOMER")
      end
    end

    context 'when the payload is invalid' do
      it 'does not create the user and returns validation errors' do
        result = described_class.call(invalid_payload).result

        # Check the user was not saved
        expect(result[:has_errors]).to be true
        expect(result[:record].errors.full_messages).to include("Email is invalid")
      end
    end
  end
end
