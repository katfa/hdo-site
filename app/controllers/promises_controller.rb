class PromisesController < ApplicationController
  hdo_caches_page :index, :show

  DEFAULT_PER_PAGE = 100

  def index
    @categories  = Category.where(main: true).includes(:children)
    @category    = @categories.find(params[:category_id]) if params[:category_id].present?
    @subcategory = Category.find(params[:subcategory_id]) if params[:subcategory_id].present?
    @parties     = Party.order(:name)
    @party       = @parties.find(params[:party_slug]) if params[:party_slug].present?

    # watch out for rails bug: https://github.com/rails/rails/pull/6792
    @promises = Promise

    if @subcategory
      @promises = @promises.joins(:categories).where('categories.id' => @subcategory.id)
    elsif @category
      @promises = @category.all_promises
    end

    @promises = @promises.includes(:parties)

    if @party
      @promises = @promises.where('parties.id' => @party.id)
    else
      @promises = @promises.order('parties.id')
    end

    @promises = @promises.paginate(page: params[:page], per_page: DEFAULT_PER_PAGE)
  end

  def show
    @promise = Promise.find(params[:id])
  end

end
