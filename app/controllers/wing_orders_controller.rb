class WingOrdersController < ApplicationController
  def index
    @wing_orders = WingOrder.all
  end

  def new
    @form_locals = form_locals(WingOrder.new)
  end

  def create
    wing_order = WingOrder.new(wing_order_params)
    wing_order.flavors = Flavor.where(id: params[:wing_order][:flavor_ids])
    if wing_order.save
      flash[:notice] = "Wing order created!"
      redirect_to wing_orders_path
    else
      flash[:alert] = "Wing order not created"
      @form_locals = form_locals(wing_order)
      render :new
    end
  end

  private

  def form_locals(order)
    {
      wing_order: order,
      state_collection: WingOrder::STATES
      quantity_collection: WingOrder::QUANTITIES
      flavor_collection: Flavor.all
    }
  end

  def wing_order_params
    params.require(:wing_order).permit(
      :customer_name,
      :city,
      :state,
      :quantity,
      :ranch_dressing
    )
  end
end
