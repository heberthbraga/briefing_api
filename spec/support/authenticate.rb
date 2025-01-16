shared_context 'admin_authentication' do
  before do
    @user, @access_token = authenticate(user_type: :admin)
  end
end

shared_context 'customer_authentication' do
  before do
    @user, @access_token = authenticate(user_type: :customer)
  end
end

shared_context 'owner_authentication' do
  before do
    @user, @access_token = authenticate(user_type: :owner)
  end
end


def authenticate(user_type:)
  password = "test1234"
  user = create(:user, :"#{user_type}", password: password)

  role_type = (user_type == :owner) ? :product_owner : user_type

  role = create(:role, role_type)
  user.roles << role

  post '/api/v1/sessions/basic', params: { email: user.email, password: password }

  response = json_response

  access_token = response[:access_token]

  expect(access_token).not_to be_nil
  expect(response[:refresh_token]).not_to be_nil

  [ user, access_token ]
end
