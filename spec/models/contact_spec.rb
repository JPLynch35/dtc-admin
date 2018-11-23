require 'rails_helper'

RSpec.describe Contact, type: :model do
  context 'validations' do
    it { should validate_presence_of(:name) }
    it { should_not validate_presence_of(:email) }
    it { should_not validate_presence_of(:phone) }
    it { should_not validate_presence_of(:organization) }
  end
end
