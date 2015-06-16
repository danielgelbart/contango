class PurchasesController < ApplicationController
  before_action :set_purchase, only: [:show, :edit, :update, :destroy]

  def index
    @purchases = Purchase.all
  end

  def show
    @search = @purchase.search
  end

  def new
#    @purchase = Purchase.new
  end

  def edit
  end

  def create
    @purchase = Purchase.new(purchase_params)

    # Amount in cents
    @payment_plan = PaymentPlan.find(purchase_params[:payment_plan_id])
    @search = Search.find(purchase_params[:search_id])
    @purchase.search = @search
    @purchase.payment_plan = @payment_plan

    begin
      customer = Stripe::Customer.create(:email => stripe_params[:stripeEmail],
                                         :card  => stripe_params[:stripeToken])

      charge = Stripe::Charge.create(:customer    => customer.id,
                                     :amount      => @payment_plan.price,
                                     :description => 'Rails Stripe customer',
                                     :currency    => 'usd')
    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to purchases_path
    end

    if @purchase.save
      redirect_to @purchase, notice: 'Purchase was successfully created.'
    else
      render :new
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def purchase_params
      params.require(:purchase).permit(:payment_plan_id, :search_id)
    end

    def stripe_params
      params.permit(:stripeToken, :stripeTokenType, :stripeEmail)
    end

end
