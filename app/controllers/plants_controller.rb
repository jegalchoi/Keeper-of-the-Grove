class PlantsController < ApplicationController
  before_action :require_current_user!, except: [:index]
  before_action :require_owner!, only: [:edit, :update, :destroy]

  def index
    @plants = Plant.with_attached_images
  end

  def show
    find_plant_by_params_id
    
    if @plant
      render :show
    else
      render :index
    end
  end
  
  def new
    @plant = Plant.new
  end

  def create
    @plant = current_user.plants.new(plant_params)

    if @plant.save
      flash[:notices] = ["Plant saved!"]
      redirect_to plant_url(@plant)
    else
      flash.now[:errors] = @plant.errors.full_messages
      render :new
    end
  end

  def edit
    find_plant_by_params_id
  end

  def update
    find_plant_by_params_id

    if @plant.update_attributes(plant_params)
      flash[:notices] = ['Plant updated!']
      if request.referer == edit_plant_url(@plant)
        redirect_to @plant
      else
        redirect_to request.referer
      end
    else
      flash[:errors] = @plant.errors.full_messages
      render :edit
    end
  end

  def destroy
    find_plant_by_params_id

    if @plant.destroy
      flash[:notices] = ['Plant deleted!']
      redirect_to user_url(current_user_id)
    else
      flash[:errors] = @plant.errors.full_messages
      render plant_url(@plant)
    end
  end


  private

  def plant_params
    params.require(:plant).permit(:name, :notes, :water, :private, :user_id, images: [])
  end

  def find_plant_by_params_id
    @plant = Plant.find_by(id: params[:id])
  end

  def require_owner!
    redirect_to new_session_url unless current_user_id == find_plant_by_params_id.user_id
  end

end