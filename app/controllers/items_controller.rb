class ItemsController < ApplicationController
  def index
  	@categories = MainCategory.all
  	@recommended = Item.all.limit(3)
  	@items = Item.all.order("id desc").limit(6)
  end
  def scheduler time
    job_id =
      Rufus::Scheduler.singleton.in '5s' do
        Rails.logger.info "time flies, it's now #{Time.now}"
      end

    render :text => "scheduled job #{job_id}"
  end


def create
  Cart.create(item:Item.find(params[:item_id]), days:params[:days], start:params[:start])
  redirect_to "/items"
end

def destroy
  cart = Cart.all
  cart.each do |c|
    c.destroy
  end
  redirect_to "/items"
end
end
