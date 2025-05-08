class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]

  def index
    @tags = Tag.all
  end

  def new
    @tag = current_user.tags.new
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.user = current_user

    if @tag.save
      redirect_to books_path, notice: "Tag created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to @tag, notice: "Tag updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @tag = current_user.tags.find(params[:id])
    
    if @tag.destroy
      redirect_to tags_path, notice: "Tag was successfully deleted."
    else
      redirect_to tags_path, alert: "Failed to delete the tag."
    end
  end


  def show
    @tag = current_user.tags.find(params[:id])
    @books = @tag.books
  end

  private

    def set_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.require(:tag).permit(:name)
    end

end
