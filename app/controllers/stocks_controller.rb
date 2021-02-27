# frozen_string_literal: true

# StocksController
class StocksController < ApplicationController
  def search
    if params[:stock]
      @stock = Stock.find_by_ticker(params[:stock])
      begin
        @stock ||= Stock.new_from_lookup(params[:stock])
      rescue StandardError => e
        @error = true
        @stock = []
        flash.now[:notice] = 'There is no stock of this symbol'
      end
    end
    respond_to do |format|
      format.js { render :search }
    end
  end
end
