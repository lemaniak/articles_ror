class Api::StoresController < ApplicationController

  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    response = { success: false, error_code: 1001, error_msg: "parameter "+parameter_missing_exception.param.to_s+" is required" }
    respond_to do |format|
      format.json { render json: response, status: :bad_request }
    end
  end

  rescue_from(ActionController::UnpermittedParameters) do |non_permitted_parameter_exception|
    response = { success: false, error_code: 1002, error_msg: non_permitted_parameter_exception.to_s}
    respond_to do |format|
      format.json { render json: response, status: :bad_request }
    end
  end

  rescue_from(ActiveRecord::RecordNotFound) do
    response = { success: false, error_code: 1003, error_msg: 'store not found'}
    respond_to do |format|
      format.json { render json: response, status: :not_found }
    end
  end



  def index
    @stores = Store.all
    render json:{ success: true, stores:@stores}, status: :created
  end

  def create
    @store = Store.new(store_params)
    if @store.valid?
      if @store.save
        render json: { success: true, store:@store}, status: :created
        else
          render json: { success: false, error_code: 1000, error_msg: "error saving store" },status: :internal_server_error
        end
    else
      render json: { success: false, error_code: 1004, error_msg: @store.errors },status: :bad_request
    end
  end

  def show
    @store = Store.find(params[:id])
    if @store
      render json: { success: true, store:@store}, status: :ok
    end
  end

  def update
    @store = Store.find(params[:id])
    @storenew = Store.new(store_params)
    if @storenew.valid?
      if @store.update(store_params)
        render json: { success: true, store:@store}, status: :ok
      else
        render json: { success: false, error_code: 1005, error_msg: "error updating store" },status: :internal_server_error
      end
    end


  end

  def destroy
    @store = Store.find(params[:id])
    @store.destroy

    render json: { success: true}, status: :ok
  end


  private
  def store_params
    params.require(:store).permit(:name,:address)
  end

end
