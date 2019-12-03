require 'rails_helper'

feature "CRUD of plants" do
  given!(:jay_test) { FactoryBot.create(:jay_test) }

  background(:each) do
    login_user('jay_test', 'password') 
  end

  feature "creating plants" do
    scenario "should have a page for creating a new plant" do
      visit new_plant_url
      expect(page).to have_content("New Plant")
    end

    scenario "owner should be able to access page for creating a new plant" do
      visit user_url(User.last.id)
      expect(page).to have_content("New Plant")
    end

    scenario "should show the new plant after creation" do
      create_plant("test0")
      expect(page).to have_content("test0")
      expect(page).to have_content("Plant saved!")
    end

    scenario "invalid credentials should not be able to access page for creating plants" do
      visit user_url(User.last.id)
      click_button "Log Out"
      visit user_url(User.last.id)
      expect(page).to_not have_content("New Plant")
    end
  end

  feature "reading plants" do
    scenario "should only list public plants" do
      build_three_plants(User.last.id)
      verify_three_plants
    end
  end

  feature "updating plants" do
    given(:plant) { FactoryBot.create(:plant, user_id: User.last.id) }

    scenario "should have a page for updating an existing plant" do
      visit edit_plant_url(plant)
      expect(page).to have_content "Edit Plant"
      expect(find_field('Name').value).to eq(plant.name)
    end

    scenario "should show the updated plant after changes are saved" do
      visit edit_plant_url(plant)
      fill_in "Name", with: "edited_test"
      click_button "Update Plant"
      expect(page).to have_content("Plant updated!")
      expect(page).to have_content("edited_test")
    end

    scenario "invalid credentials should not be able to access page for updating an existing plant" do
      visit user_url(User.last.id)
      click_button "Log Out"
      visit edit_plant_url(plant)
      expect(page).to_not have_content("Edit Plant")
    end
  end

  feature "deleting plants" do
    scenario "should allow the deletion of plants" do
      build_three_plants(User.last.id)
      visit plant_url(Plant.last.id)
      click_button "Delete Plant"
      expect(page).to_not have_content "test3"
      expect(page).to have_content "Plant deleted!"
      visit plant_url(Plant.last.id)
      click_button "Delete Plant"
      expect(page).to_not have_content "test2"
      expect(page).to have_content "Plant deleted!"
      visit plant_url(Plant.last.id)
      click_button "Delete Plant"
      expect(page).to_not have_content "test1"
      expect(page).to have_content "Plant deleted!"
    end

    scenario "invalid credentials should not be able to delete an existing plant" do
      create_plant('delete_plant')
      visit user_url(User.last.id)
      click_button "Log Out"
      visit plant_url(Plant.last.id)
      expect(page).to_not have_button("Delete Plant")
    end
  end



end