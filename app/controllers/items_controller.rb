class ItemsController < ApplicationController

rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    if params[:user_id]
      user = find_user
      items = user.items
      render json: items, include: :user, status: :ok
    else 
      items = Item.all
      render json: items, include: :user
    end
  end

  def show
    if params[:user_id]
      user = find_user
      item = user.items.find(params[:id])
      render json: item, include: :user, status: :ok
    end
  end

  def create
    if params[:user_id]
      user = find_user
      item = user.items.create!(item_params)
      render json: item, include: :user, status: :created
    end
  end


  private

  def render_not_found_response
    render json: {message: "User not found"}, status: :not_found
  end

  def find_user
    User.find(params[:user_id])
  end

  def item_params
    params.permit(:name, :description, :price)
  end

end
