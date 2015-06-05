class EntitiesController < ApplicationController
  include Concerns::EntityConcerns

  respond_to :html

  def index
    @entities = Entity.select(Arel.star).with_rank
                .order('latest_score DESC')
                .limit(params[:size])
                .offset(params[:offset]).decorate

    respond_with @entities
  end

  def show
    @entity = Entity.find_by(name: params[:name]).decorate
  end

  def new
    @score_saver = ScoreSaver.new(score_saver_params)
  end

  def create
    @score_saver = ScoreSaver.new(score_saver_params(params))

    if @score_saver.save
      respond_with @score_saver.entity.decorate
    else
      render :new
    end
  end

  def destroy
    @entity = Entity.find_by(name: params[:name])

    fail ActiveRecord::RecordNotFound if @entity.nil?

    if @entity.destroy
      flash[:notice] = "You have removed '#{@entity.name}'"
    else
      flash[:notice] = "Unable to delete '#{@entity.name}'"
    end

    redirect_to :index
  end

  def record_not_found
    flash[:error] = 'Entity not found'
    redirect_to :index
  end
end
