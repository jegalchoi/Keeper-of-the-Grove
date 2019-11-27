require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) do
    User.create!(
      username: "camchoi",
      email: "test@email.com",
      password: "password"
    )
  end

  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should validate_length_of(:username).is_at_most(50) }
  
  it { should validate_presence_of(:email) }
  it { should validate_length_of(:email).is_at_most(255) }
  invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com]
  invalid_addresses.each do |address|
    it { should_not allow_value(address).for(:email) }
  end

  it { should validate_length_of(:password).is_at_least(6).allow_nil }

  it "creates a password digest when a password is given" do
    expect(user.password_digest).to_not be_nil
  end

  it do
    should validate_presence_of(:password_digest).
    with_message('Password cannot be blank.')
  end

  it "creates a session token before validation" do
    user.valid?
    expect(user.session_token).to_not be_nil
  end

  describe "password encryption" do
    it "does not save passwords to the database" do
      create(:user, username: 'camchoi', password: 'password')
      user = User.find_by(username: 'camchoi')
      expect(user.password).not_to be ('password')
    end

    it "encrypts the password using BCrypt" do
      expect(BCrypt::Password).to receive(:create)
      User.new(username: 'jaychoi', password: 'password')
    end
  end

  describe "class methods" do
    subject(:user) do
      User.create!(
        username: "camchoi",
        email: "test@email.com",
        password: "password"
      )
    end

    describe "::find_by_credentials" do
      it "should find user by credentials" do
        username = user.username
        user.password = 'password'
        password = user.password
        find_user = User.find_by_credentials(username, password)
        expect(find_user).to eq(user)
      end

      it "should fail to find user by invalid credentials" do
        username = user.username
        password = 'pass'
        find_user = User.find_by_credentials(username, password)
        expect(find_user).to_not eq(user)
      end
    end

    describe "#is_password?" do
      it "should confirm password is correct" do
        user.password = 'password'
        password = user.password
        check_password = user.is_password?(password)
        expect(check_password).to eq(true)
      end

      it "should confirm password is incorrect" do
        password = 'pass'
        check_password = user.is_password?(password)
        expect(check_password).to eq(false)
      end
    end

    describe "#password=" do
      it "should set password_digest" do
        user.password_digest = nil
        user.password = 'new_password'
        password = user.password
        expect(user.password_digest).to_not be_nil
      end
    end

    describe "#reset_session_token" do
      it "should set a new session token" do
        old_session_token = user.session_token
        user.reset_session_token!        
        expect(user.session_token).to_not eq(old_session_token)
      end
    end

    describe "#ensure_session_token" do
      it "should set session token if there isn't one" do
        user.session_token = nil
        user.reset_session_token!
        expect(user.session_token).to_not be_nil
      end
    end
  end
end
