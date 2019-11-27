require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  subject(:user) do
    User.create!(
      username: "camchoi",
      email: "test@email.com",
      password: "password"
    )
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to have_http_status(200)
      expect(response).to render_template(:new)
    end
  end

  describe "GET #show" do
    it "renders the show template if user found" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(200)
      expect(response).to render_template(:show)
    end

    it "renders the index template if user not found" do
      get :show, params: { id: -1 }
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe "POST #create" do
    context "with invalid params" do
      it "validates the presence of the user's username" do
        post :create, params: { 
          user: { 
            username: "", 
            email: "email@email.com", 
            password: "password", 
            session_token: User.generate_session_token 
          } 
        }
        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end

      it "validates the presence of the user's email" do
        post :create, params: { 
          user: { 
            username: "test1", 
            email: "", 
            password: "password", 
            session_token: User.generate_session_token 
          } 
        }
        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end

      it "validates the format of the user's email" do
        post :create, params: { 
          user: { 
            username: "test1", 
            email: "email@email,com", 
            password: "password", 
            session_token: User.generate_session_token 
          } 
        }
        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end

      it "validates the length of the user's password" do
        post :create, params: { 
          user: { 
            username: "test1", 
            email: "email@email.com", 
            password: "pass", 
            session_token: User.generate_session_token 
          } 
        }
        expect(response).to have_http_status(200)
        expect(response).to render_template(:new)
        expect(flash[:errors]).to be_present
      end
    end

    context "with valid params" do
      it "redirects user to user show on success" do
        post :create, params: { 
          user: { 
            username: "test1", 
            email: "email@email.com", 
            password: "password", 
            session_token: User.generate_session_token 
          } 
        }
        expect(response).to have_http_status(302)
        expect(response).to redirect_to(user_url(User.last))
      end
    end
  end
end