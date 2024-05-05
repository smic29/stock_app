class TransactionsController < ApplicationController

  def index
    @transactions = current_user.transactions.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def create
    respond_to do |format|
      if Transaction.transact(current_user, params[:commit], transaction_params)
        flash[:notice] = "#{params[:commit]} transaction completed"
        format.turbo_stream { render turbo_stream: [
          turbo_stream.update("transaction-form", partial: "pages/transact_form", locals: { key: transaction_params[:symbol], price: transaction_params[:price].to_f }),
          turbo_stream.append("alert-container", partial: "shared/alerts"),
          turbo_stream.update("user_frame", template: "pages/dashboard")
        ]}
      end
    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:symbol, :price, :quantity)
  end

end
