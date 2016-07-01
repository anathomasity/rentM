require 'mail'
require 'rufus-scheduler'

options = { :address              => "smtp.gmail.com",
	      :port                 => 587,
	      :domain               => 'gmail.com',
	      :user_name            => 'rentapp22@gmail.com',
	      :password             => '22rentapp',
	      :authentication       => 'plain',
	      :enable_starttls_auto => true  }


Mail.defaults do
	delivery_method :smtp, options
end


class ChargesController < ApplicationController

	def show

	end

	def new
		@cart = Cart.all
	end

	def destroy
		Cart.find(params[:id]).destroy
		redirect_to '/charges/new'
	end

	def create
	  # Amount in cents
	  	user_email = current_user.email
		sum =0
		cart = Cart.all
		cart.each do |c|
			sum += c.item.price * c.days
			item_sum = c.item.price * c.days
			Rental.create(user_id: current_user.id, duration: c.days, price: item_sum, item_id: c.item.id )
			SCHEDULER.in (c.days-1).to_s + 'd' do
				puts user_email
				Mail.deliver do
					from    'rentapp22@gmail.com'
					to      user_email
					subject 'Your rental will expire tomorrow'
					body    'Some simple body'
				end
			end
		end 

		SCHEDULER.in '5s' do
			puts user_email
			Mail.deliver do
				from    'rentapp22@gmail.com'
				to      user_email
				subject 'Your successfully rented from RentApp'
				body    'Some simple body'
			end
		end


		cart = Cart.all
  		cart.each do |c|
    		c.destroy
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
