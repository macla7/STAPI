require 'rails_helper'

RSpec.describe User, type: :model do
  context "methods" do
    describe '#authenticated_email' do
      let(:user) { User.new(email_confirmed: false, confirm_token: 'some_token') }

      it 'sets email_confirmed to true, confirm_token to nil, and saves the record' do
        expect(user).to receive(:save!).with(validate: false)

        user.authenticated_email

        expect(user.email_confirmed).to be(true)
        expect(user.confirm_token).to be_nil
      end
    end

    describe '#not_in_groups' do
      it 'expect not_in_groups to return group not in' do
      user = FactoryBot.create(:user)
      group1 = FactoryBot.create(:group)
      group2 = FactoryBot.create(:group)
      membership = FactoryBot.create(:membership, user_id: user.id, group_id: group1.id)

      expect(user.not_in_groups).to eq([group2])
      end
    end

    describe '#create_confirmation_token_if_blank' do
      let(:user) { User.new }

      it 'generates a confirmation token if the token is blank' do
        allow(SecureRandom).to receive_message_chain(:urlsafe_base64, :to_s).and_return('random_token')

        user.create_confirmation_token_if_blank

        expect(user.confirm_token).to eq('random_token')
      end

      it 'does not generate a confirmation token if the token is already present' do
        user.confirm_token = 'existing_token'

        user.create_confirmation_token_if_blank

        expect(user.confirm_token).to eq('existing_token')
      end
    end

    describe '#add_default_avatar' do
      it 'attaches the default avatar if avatar is not already attached' do
        model = User.new
        avatar = double('avatar')
        file = double('file')

        allow(model).to receive(:avatar).and_return(avatar)
        allow(File).to receive(:open).and_return(file)

        expect(avatar).to receive(:attached?).and_return(false)
        expect(avatar).to receive(:attach).with(
          io: file,
          filename: 'default_avatar_3.png',
          content_type: 'image/png'
        )

        model.add_default_avatar
      end

      it 'does not attach the default avatar if avatar is already attached' do
        model = User.new
        avatar = double('avatar')

        allow(model).to receive(:avatar).and_return(avatar)

        expect(avatar).to receive(:attached?).and_return(true)
        expect(avatar).not_to receive(:attach)

        model.add_default_avatar
      end
    end

    describe '#avatar_url' do
      it 'returns the URL of the attached avatar' do
        model = User.new
        avatar = double('avatar')
        routes_helpers = double('routes_helpers')

        allow(model).to receive(:avatar).and_return(avatar)
        allow(Rails.application.routes.url_helpers).to receive(:url_for).with(avatar).and_return('http://example.com/avatar_url')

        expect(avatar).to receive(:attached?).and_return(true)

        url = model.avatar_url

        expect(url).to eq('http://example.com/avatar_url')
      end

      it 'adds default avatar and returns its URL if avatar is not attached' do
        model = User.new
        avatar = double('avatar')
        routes_helpers = double('routes_helpers')

        allow(model).to receive(:avatar).and_return(avatar)
        allow(Rails.application.routes.url_helpers).to receive(:url_for).with(avatar).and_return('http://example.com/avatar_url')

        expect(avatar).to receive(:attached?).and_return(false)
        expect(model).to receive(:add_default_avatar)
        expect(Rails.application.routes.url_helpers).to receive(:url_for).with(avatar).and_return('http://example.com/default_avatar_url')

        url = model.avatar_url

        expect(url).to eq('http://example.com/default_avatar_url')
      end
    end

    describe '.authenticate' do
      let(:email) { 'test@example.com' }
      let(:password) { 'password123' }
      let(:user) { User.new }

      it 'returns the user if authentication is successful' do
        expect(User).to receive(:find_for_authentication).with(email: email).and_return(user)
        expect(user).to receive(:valid_password?).with(password).and_return(true)

        result = User.authenticate(email, password)

        expect(result).to eq(user)
      end

      it 'returns nil if authentication fails' do
        expect(User).to receive(:find_for_authentication).with(email: email).and_return(user)
        expect(user).to receive(:valid_password?).with(password).and_return(false)

        result = User.authenticate(email, password)

        expect(result).to be_nil
      end

      it 'returns nil if user is not found' do
        expect(User).to receive(:find_for_authentication).with(email: email).and_return(nil)

        result = User.authenticate(email, password)

        expect(result).to be_nil
      end
    end
  end

  context 'validations' do
    before(:each) do
      @user = FactoryBot.create(:user)
    end

    it 'is valid with valid attributes' do
      expect(@user).to be_valid
    end

    it 'is not valid without a name' do
      @user.name = ''
      expect(@user).not_to be_valid
      expect(@user.errors[:name]).to be_present
    end

    it 'is not valid without an email' do
      @user.email = ''
      expect(@user).not_to be_valid
      expect(@user.errors[:email]).to be_present
    end

    it 'is not valid with a duplicate email' do
      duplicate_user = @user.dup
      @user.save
      expect(duplicate_user).not_to be_valid
      expect(duplicate_user.errors[:email]).to be_present
    end

    it 'is valid with a valid email format' do
      valid_addresses = %w[user@example.com john.doe@example.co.uk]
      valid_addresses.each do |address|
        @user.email = address
        expect(@user).to be_valid
      end
    end

    it 'is not valid with an invalid email format' do
      invalid_addresses = %w[user@example,com john.doe@example. john@doe_com]
      invalid_addresses.each do |address|
        @user.email = address
        expect(@user).not_to be_valid
        expect(@user.errors[:email]).to be_present
      end
    end

    # Add more validation tests as needed
  end

  context 'attributes' do
    before(:each) do
      @user = FactoryBot.create(:user)
    end

    it 'has a name attribute' do
      expect(@user).to respond_to(:name)
    end

    it 'has an email attribute' do
      expect(@user).to respond_to(:email)
    end

    it 'has an email_confirmed attribute' do
      expect(@user).to respond_to(:email_confirmed)
    end

    # Add more attribute tests as needed
  end

  context 'associations' do
    it 'has many posts' do
      user = User.reflect_on_association(:posts)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many memberships' do
      user = User.reflect_on_association(:memberships)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many groups' do
      user = User.reflect_on_association(:groups)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many requests' do
      user = User.reflect_on_association(:requests)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many invites' do
      user = User.reflect_on_association(:invites)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many sent_invites' do
      user = User.reflect_on_association(:sent_invites)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many likes' do
      user = User.reflect_on_association(:likes)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many bids' do
      user = User.reflect_on_association(:bids)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many comments' do
      user = User.reflect_on_association(:comments)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many notifications' do
      user = User.reflect_on_association(:notifications)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many notification_origins' do
      user = User.reflect_on_association(:notification_origins)
      expect(user.macro).to eq(:has_many)
    end

    it 'has many push_tokens' do
      user = User.reflect_on_association(:push_tokens)
      expect(user.macro).to eq(:has_many)
    end
    # Add more association tests as needed
  end
end
