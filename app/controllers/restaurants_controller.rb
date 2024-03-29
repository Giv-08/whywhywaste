class RestaurantsController < ApplicationController
  def index
    @restaurants = Restaurant.all
    @published_foods = Food.published

    # Signed-in restaurant only
    if restaurant_signed_in?
      @my_restaurant = current_restaurant
      @published_foods = @my_restaurant.foods.where(published: true)
      # fetch all other restaurants (excluding signed-in restaurant)
      @other_restaurants = Restaurant.where.not(id: @my_restaurant&.id)
    else
      # fetches all restaurants
      @my_restaurant = nil
      @other_restaurants = Restaurant.all
    end
    # Grab all foods from signed-in restaurant
    @foods = Food.all
  end

  def show
    @restaurant = Restaurant.find(params[:id])
    @my_restaurant = current_restaurant if restaurant_signed_in?
    # @food = Food.find(params[:id])
    @published_foods = @restaurant.foods.where(published: true)
    @unpublished_foods = @restaurant.foods.where(published: false)

    # if restaurant_signed_in?
    #   @my_restaurant = current_restaurant

    # end
  end

  # def map
  #   @restaurants = Restaurant.all
  #   @markers = @restaurants.geocoded.map do |restaurant|
  #     {
  #       lat: restaurant.latitude,
  #       lng: restaurant.longitude
  #     }
  #   end
  # end

  # def create
  #   @restaurant = Restaurant.new(restaurant_params)
  #   @restaurant.user = current_user
  #   if @restaurant.save
  #     redirect_to restaurants_path_, notice: "Restaurant created successfully"
  #   else
  #     render :new, status: :unprocessable_entity
  #   end
  # end

  # def edit
  #   @restaurant = Restaurant.find(params[:id])
  # end

  # def new
  #   @restaurant = Restaurant.new
  #   @restaurant.save
  # end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to restaurants_path
  end

  # def destroy
  #   @restaurant = Restaurant.find(params[:id])
  #   @restaurant.destroy
  #   redirect_to restaurants_path, status: :see_other
  # end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :cuisine, :address, :phone_no, :email, :rating, :pickup_start, :pickup_end, :latitude, :longitude, :published )
  end
end
