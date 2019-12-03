module PlantFeaturesHelper
  def create_plant(plant_name)
    visit new_plant_url
    fill_in "Name:", with: plant_name 
    click_button "New Plant"
  end

  def build_three_plants(user_id)
    FactoryBot.create(:plant, name: "test1", user_id: user_id, private: false)
    FactoryBot.create(:plant, name: "test2", user_id: user_id, private: false)
    FactoryBot.create(:plant, name: "test3", user_id: user_id)
  end

  def verify_three_plants
    visit plants_url
    expect(page).to have_content("test1")
    expect(page).to have_content("test2")
    expect(page).to_not have_content("test3")
  end
end