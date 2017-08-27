RSpec.shared_context :logged_in do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:owner) { organization.owner }

  before do
    @request.host = "#{organization.domain}.com"
    sign_in(user)
  end
end
