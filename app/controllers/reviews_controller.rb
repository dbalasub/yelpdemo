
class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review, only: [:edit, :update, :destroy]
  before_action :set_restaurant
  before_action :check_user, only: [:edit, :update, :destroy]

  respond_to :html 
  
  def new
    @review = Review.new
    
  end

  def edit
  end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.restaurant_id = @restaurant.id
    respond_to do |format|
      if @review.save
        format.html { redirect_to restaurant_path(@restaurant), notice: 'Review was saved successfully' }
        format.json { render :show, status: :created, location: @review }
      else
        format.html {render :new}
        format.json {render json: @review.errors, status: :unprocessable_entity}
      end
    end
   
  end

  def update
    @review.update(review_params)
    respond_to do |format|
      format.html { redirect_to restaurant_path(@restaurant), notice: 'Review was successfully updated.' }
      format.json { head :no_content }
    end
  end

  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to restaurant_path(@restaurant), notice: 'Review was successfully destroyed.' }
      format.json { head :no_content }
    end
end

  def check_user
      unless (@review.user == current_user) || (current_user.admin?)
        redirect_to root_url, alert: "Sorry, this review belongs to someone else"
      end
  end

  private
    def set_review
      @review = Review.find(params[:id])
    end

    def set_restaurant
      @restaurant = Restaurant.find(params[:restaurant_id])
    end

    def review_params
      params.require(:review).permit(:rating, :comment)
    end
end
