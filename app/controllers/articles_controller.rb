class ArticlesController < ApplicationController

  def new
    @stores = Store.all
    @article = Article.new
  end

  def create
    # render plain: params[:article].inspect+params[:store_id]
    @stores = Store.all
    @store = Store.find(params[:store_id])
    @article = Article.new(article_params)
    @article.store_id=@store.id
    if @article.valid?
      @article.save(article_params)
      redirect_to @article
    else
        render 'new'
    end

  end

  def index
    @articles= Article.all
  end

  def show
    @article = Article.find(params[:id])
  end


  def edit
    @stores = Store.all
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @stores = Store.all
    @store = Store.find(params[:store_id])
    @article.store_id=@store.id

    if @article.update(article_params)
      redirect_to @article
    else
      render 'edit'
    end
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to articles_path
  end


  private
  def article_params
    params.require(:article).permit(:name,:description,:price,:total_in_shelf,:total_in_vault)
  end
end
