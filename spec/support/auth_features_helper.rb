module AuthFeaturesHelper
  def create_user(username, email, password)
    visit new_user_url
    fill_in "Username:", with: username
    fill_in "Email:", with: email
    fill_in "Password:", with: password
    click_button  "Sign Up"
  end

  def login_user(username, password)
    visit new_session_url
    fill_in "Username:", with: username
    fill_in "Password:", with: password
    click_button "Log In"
  end
end