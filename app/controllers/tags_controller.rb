class TagsController < ApplicationController
  before_action :locate_tag, only: [:edit, :update, :show, :destroy]

  def index
    @tags = Tag.all
    @creatures = Creature.all
  end

  def new
    @tag = Tag.new
    @creatures = Creature.all
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
    @tag = Tag.create(tag_params)
    @creatures = Creature.all
    if @tag
      flash[:success] = "Your tag has been added"
      redirect_to tags_path
    else
      @tag.errors.any?
      render 'new'
    end

  end


  def destroy
    # make a var that holds the value of the creatures attached to a single tag
    t = Tag.find(params[:id])
    tag = Tag.find(params[:id]).creatures
    if tag.length > 0
      flash[:danger] = "You can not delete a tag that's being used by a creature, sorry."
      redirect_to tags_path
    else
      t.destroy
      redirect_to tags_path
    end
  end

  def tag
    tag = Tag.find_by_name(params[:tag])
    @creatures = tag ? tag.creatures : []
  end

  private
    def tag_params
      params.require(:tag).permit(:name)
    end
    def locate_tag
      redirect_to '/404.html' unless  @tag = Tag.find_by_id(params[:id])
    end


end