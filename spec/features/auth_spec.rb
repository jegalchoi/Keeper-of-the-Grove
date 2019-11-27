require 'rails_helper'
require 'spec_helper'

feature "the signup process" do
  scenario "has a new user signup page" do
    visit new_user_url
    expect(current_path).to eq("/users/new")
    expect(page).to have_content "Sign Up"
  end

  scenario "shows user profile after signing up with valid params" do
    create_user("test", "test@email.com", "password")
    expect(current_path).to eq("/users/#{User.last.id}")
    expect(page).to have_content("You have successfully signed up!")
  end

  scenario "shows new user signup page after signing up with invalid password" do
    create_user("test", "test@email.com", "pass")
    expect(current_path).to eq("/users")
    expect(page).to have_content("Password is too short")
  end

  scenario "shows new user signup page after signing up with invalid email" do
    create_user("test", "test", "password")
    expect(current_path).to eq("/users")
    expect(page).to have_content("Email is invalid")
  end
end

feature "logging in" do
  scenario "has a log in page" do
    visit new_session_url
    expect(current_path).to eq("/session/new")
    expect(page).to have_content("Log In")
  end

  scenario "shows username on page after login" do
    create_user("test", "test@email.com", "password")
    login_user("test", "password")
    expect(current_path).to eq("/users/#{User.last.id}")
    expect(page).to have_content("test")
  end
end

feature "logging out" do
  scenario "begins with logged out state" do
    visit root_url
    expect(page).to have_content("Log In")
  end

  scenario "doesn't show username on page after logout" do
    create_user("test", "test@email.com", "password")
    login_user("test", "password")
    click_button "Log Out"
    expect(page).to_not have_content("test")
  end
end