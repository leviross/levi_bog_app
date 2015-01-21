class CreaturesController < ApplicationController
  before_action :locate_creature, only: [:edit, :update, :show, :destroy]

  def index
    @creatures = Creature.all
  end


  def show
    @creature = Creature.find_by_id(params[:id])
    @name = Creature.find(params[:id]).name
    not_found unless @creature
    # below, 'flickr' is a local variable that is undefined, dont know how...
    list = flickr.photos.search :text => @name, :sort => "relevence", :per_page => 20
    @results = list.map do |photo|
      FlickRaw.url_s(photo)
    end
  end

  def new
    @creature = Creature.new
    @tags = Tag.all
  end

  def edit
    @creature = Creature.find(params[:id])
    @tags = Tag.all
  end

  def create
    # check the JSON data thats getting passed through
    # render json: params

    # new method
    # @creature = Creature.new
    # @creature.name = params[:creature][:name]
    # @creature.desc = params[:creature][:desc]
    # @creature.save
    # redirect_to creatures_path

    # documented create method
    @creature = Creature.create(creature_params)
    @tags = Tag.all
    if @creature.errors.any?
      render 'new'
    else
      tags = params[:creature][:tag_ids]
      tags.each do |tag_id|
        @creature.tags << Tag.find(tag_id) unless tag_id.blank?
      end
      flash[:success] = "Your creature has been added"
      redirect_to creatures_path
    end

  end

  def update
    @creature = Creature.find(params[:id])

    if @creature.update(creature_params)
      @creature.tags.clear
      tags = params[:creature][:tag_ids]
      tags.each do |tag_id|
      @creature.tags << Tag.find(tag_id) unless tag_id.blank?
      end
      redirect_to @creature
    else
      render 'edit'
    end
  end


  def destroy
    @creature = Creature.find(params[:id]) or not_found
    @creature.destroy
    redirect_to creatures_path
  end

  def tag
    tag = Tag.find_by_name(params[:tag])
    @creatures = tag ? tag.creatures : []
  end

  private
    def creature_params
      params.require(:creature).permit(:name, :desc)
    end
    def locate_creature
      redirect_to '/404.html' unless  @creature = Creature.find_by_id(params[:id])
    end


end