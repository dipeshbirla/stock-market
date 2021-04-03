# frozen_string_literal: true

# UserStocksController
class UserStocksController < ApplicationController
  before_action :set_user_stock, only: %i[show edit update]
  # GET /user_stocks
  # GET /user_stocks.json
  def index
    @user_stocks = UserStock.all
  end

  # GET /user_stocks/1
  # GET /user_stocks/1.json
  def show
  end

  # GET /user_stocks/new
  def new
    @user_stock = UserStock.new
  end

  # GET /user_stocks/1/edit
  def edit
  end

  # POST /user_stocks
  # POST /user_stocks.json
  def create
    # params[:stock_ticker] = params[:stock_ticker].upcase
    if params[:stock_id].present?
    @user_stock = UserStock.new(stock_id: params[:stock_id], user: current_user)
    else
      stock = Stock.find_by_ticker(params[:stock_ticker])
      if stock
        @user_stock = UserStock.new(user: current_user, stock_id: stock.id)
      else
        stock = Stock.new_from_lookup(params[:stock_ticker])
        if stock.save
          @user_stock = UserStock.new(user: current_user, stock_id: stock.id)
        else
          @user_stock = nil
          flash[:error] = 'Stock is not available'
        end
      end
    end

    respond_to do |format|
      if @user_stock.save
        # ExampleMailer.sample_email.deliver
        format.html do
          msg = "Stock #{@user_stock.stock.ticker} stock was successfully added"
          redirect_to my_portfolio_path, notice: msg
        end
        format.json { render :show, status: :created, location: @user_stock }
      else
        format.html { render :new }
        format.json { render json: @user_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /user_stocks/1
  # PATCH/PUT /user_stocks/1.json
  def update
    respond_to do |format|
      if @user_stock.update(user_stock_params)
        format.html do
          redirect_to @user_stock,
                      notice: 'User stock was successfully updated.'
        end
        format.json { render :show, status: :ok, location: @user_stock }
      else
        format.html { render :edit }
        format.json { render json: @user_stock.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_stocks/1
  # DELETE /user_stocks/1.json
  def destroy
    @user_stock = Stock.find(params[:id]).user_stocks
                       .where(stock_id: params[:id], user_id: current_user.id)
                       .first
    @user_stock.destroy
    respond_to do |format|
      format.html do
        redirect_to my_portfolio_path,
                    notice: 'Stock was Successfully removed from my_portfolio'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user_stock
    @user_stock = UserStock.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list
  # through.
  def user_stock_params
    params.require(:user_stock).permit(:user_id, :stock_id)
  end
end
