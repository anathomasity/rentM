class ChargesController < ApplicationController
def new
	@cart = Cart.all
end

def create
  # Amount in cents
  sum =0
  cart = Cart.all
  cart.each do |c|
  	sum += c.item.price * c.days
  	item_sum = c.item.price * c.days
  	Rental.create(price: item_sum, )
  end
  sum *= 100
  sum = sum.to_i
  @amount = sum
  @amount2 = sum/100


  customer = Stripe::Customer.create(
    :email => params[:stripeEmail],
    :source  => params[:stripeToken]
  )

  charge = Stripe::Charge.create(
    :customer    => customer.id,
    :amount      => @amount,
    :description => 'Rails Stripe customer',
    :currency    => 'usd'
  )

rescue Stripe::CardError => e
  flash[:error] = e.message
  redirect_to new_charge_path
end
end