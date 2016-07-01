class ResultsController < ApplicationController

  def index
  
  end

  def show
  end

  def create
  	terms = params[:search].split(" ")
  	query = terms.map {|term| "name LIKE '%#{term}%'"}.join(" OR ")
  	@search = Item.where(query)

  end
  	# @search = User.joins(:items).select('items.id','state').where(state: current_user.state)


end
