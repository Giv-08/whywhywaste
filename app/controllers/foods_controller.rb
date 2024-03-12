class FoodsController < ApplicationController
  def show
    @restaurant = Restaurant.find(params[:restaurant_id])
    @food = Food.find(params[:id])
  end

  def index
    @foods = Food.all
  end

  def new
    @restaurant = Restaurant.find(params[:restaurant_id])
    @food = Food.new
  end

  def create
    @food = food.new(food_params)
    @food.status = "pending"
    @restaurant = Restaurant.find(params[:restaurant_id])
    # @food.restaurant = @restaurant
    # @food.user = current_user
    if @food.save
      redirect_to dashboard_path, notice: "food created successfully"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @food = food.find(params[:id])
    @food.destroy
    redirect_to foods_path, status: :see_other
  end

  def edit
    @restaurant = restaurant.find(params[:restaurant_id])
    @food = food.find(params[:id])
  end
  # patch /foods/:id
  def update
    @food = food.find(params[:id])
    @food.update(food_params)
    redirect_to dashboard_path
  end

  private

  def food_params
    params.require(:food).permit(:status, :restaurant_id, :user_id)
  end
end
