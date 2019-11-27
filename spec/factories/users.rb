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
    password_digest { BCrypt::Password.create(password) }
    session_token { User.generate_session_token }

    factory :jaychoi do
      username { 'jaychoi' }
    end
  end
  
end
