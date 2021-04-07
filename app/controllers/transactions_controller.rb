class TransactionsController < ApplicationController
	def new
		@transaction = Transaction.new
	end

	def create
  # Find a transaction
  @transaction = Transaction.find_by(payer: transaction_params[:payer]) rescue nil
  
  # Create transaction if not present, else add points in existing transaction
  if @transaction.nil?
    @transaction = Transaction.new(transaction_params)
  else
    @transaction.points = @transaction.points + transaction_params[:points].to_i
  end

  @transaction.user = current_user
  if @transaction.save
    redirect_to root_path
  else
    render :new
  end
	end

	def index

		@transactions = current_user.transactions.order(:created_at)
		# if params[:points].present?
		# 	@transactions.order(:created_at)

		# 	@transactions.each do |t|
		# 		t.points -= params[:points].to_i
		# 		t.save
		# 	end
		# end
	end
	def deduct_points
		remaining_points = points_params[:points].to_i
		@transactions = current_user.transactions.order(:created_at)
		@transactions.each do |t|
			next if t.points.to_i.negative? || t.points.to_i.zero?
			#remainder = t.points

			if t.points.to_i >= remaining_points
			  #remainder = 0
			  t.points -= remaining_points
			  t.save
			  break
			else
			  remaining_points -= t.points.to_i
			  t.points = 0
			  t.save
			end
		end
		redirect_to transactions_path
	end
	private
	def transaction_params
		params.require(:transaction).permit(:payer, :points)
	end
	def points_params
		params.require(:point_deduction).permit(:points)
	end
end
