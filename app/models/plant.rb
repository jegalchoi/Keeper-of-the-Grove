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

class Plant < ApplicationRecord
  include ActionView::Helpers::DateHelper

  validates :name, presence: true
  validates :user_id, presence: true

  belongs_to :keeper,
    class_name: :User,
    foreign_key: :user_id

  def last_watered
    if water
      time_ago_in_words(water)
    end
  end
end
