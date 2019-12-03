# == Schema Information
#
# Table name: plants
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  notes      :text
#  water      :datetime
#  private    :boolean          default("true"), not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :plant do
    name { Faker::Team.name }
    user_id { 6 }
  end
end