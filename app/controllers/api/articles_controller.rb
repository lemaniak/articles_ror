class Api::ArticlesController < ApplicationController
  ActionController::Parameters.action_on_unpermitted_parameters = :raise

  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    response = { success: false, error_code: 2001, error_msg: "parameter "+parameter_missing_exception.param.to_s+" is required" }
    respond_to do |format|
      format.json { render json: response, status: :bad_request }
    end
  end

  rescue_from(ActionController::UnpermittedParameters) do |non_permitted_parameter_exception|
    response = { success: false, error_code: 2002, error_msg: non_permitted_parameter_exception.to_s}
    respond_to do |format|
      format.json { render json: response, status: :bad_request }
    end
  end

  rescue_from(ActiveRecord::RecordNotFound) do |test|
    response = { success: false, error_code: 2003, error_msg: test.to_s}
    respond_to do |format|
      format.json { render json: response, status: :not_found }
    end
  end



  def index
    @articles = Article.all
    render json:{ success: true, articles:@articles}, status: :created
  end

  def create
    @article = Article.new(article_params)
    if @article.valid?
      @store = Store.find(params[:store_id])
      @article=@store.articles.create(article_params)
      if @article
        render json: { success: true, article:@article}, status: :created
      else
        render json: { success: false, error_code: 2004, error_msg: "error saving article" },status: :internal_server_error
      end
    else
      render json: { success: false, error_code: 2005, error_msg: @article.errors },status: :bad_request
    end
  end

  def show
    @article = Article.find(params[:id])
    if @article
      render json: { success: true, article:@article}, status: :ok
    end
  end

  def update
    @article = Article.find(params[:id])
    @articleTemp = Article.new(article_params)
    if @articleTemp.valid?
      @store = Store.find(params[:store_id])
      @article.store_id=@store.id
      if @article.update(article_params)
        render json: { success: true, article:@article}, status: :ok
      else
        render json: { success: false, error_code: 2006, error_msg: "error updating article" },status: :internal_server_error
      end
    else
      render json: { success: false, error_code: 2007, error_msg: @article.errors },status: :bad_request
    end


  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    render json: { success: true}, status: :ok
  end


  private
  def article_params
    params.require(:article).permit(:name,:description,:price,:total_in_shelf,:total_in_vault,:store_id)
  end

end
