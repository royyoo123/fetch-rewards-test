class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
  	if current_user.present?
  		@transactions = current_user.transactions
  	else
  		@transactions = Transaction.all
  	end
  end
end
