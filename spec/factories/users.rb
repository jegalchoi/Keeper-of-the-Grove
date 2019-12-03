# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password = 'password'

    factory :jay_test do
      username { "jay_test" }
      password { 'password' }
    end

    factory :cam_test do
      username { "cam_test" }
      password { 'password' }
    end
  end
end
