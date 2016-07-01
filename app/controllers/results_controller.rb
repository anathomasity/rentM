class ResultsController < ApplicationController
  def index
  
  end

  def show
  end

  def create
  	if params[:search]
  		terms = params[:search].split(" ")
  		query = terms.map {|term| "name LIKE '%#{term}%'"}.join(" OR ")
  		@search = Item.where(query)
  	else
  		@search = Item.where(category_id: params[:catName])

  	end

  end
  	# @search = User.joins(:items).select('items.id','state').where(state: current_user.state)


end
