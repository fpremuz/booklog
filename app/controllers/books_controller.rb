class BooksController < ApplicationController
  before_action :require_login
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :authorize_book!, only: %i[edit update destroy]

  def index
    if Current.session&.user
      @books = Current.session.user.books

      if params[:query].present?
        q = "%#{params[:query]}%"
        @books = @books.where("title ILIKE ? OR description ILIKE ?", q, q)
      end

      if params[:status].present?
        @books = @books.where(status: params[:status])
      end

      if params[:rating].present?
        @books = @books.where(rating: params[:rating])
      end

      if params[:rating_filter].present?
        @books = @books.where("rating >= ?", params[:rating_filter].to_i)
      end
    else
      @books = Book.none
    end
  end

  def show
  end

  def new
    @book = Book.new
  end

  def create
    @book = Current.session.user.books.build(book_params)
    if @book.save
      flash[:notice] = "Book created successfully"
      redirect_to @book
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @book.update(book_params)
      if @book.pages_read == @book.total_pages && @book.status != "read"
        @book.update(status: "read", finish_date: Date.today)
      end
      redirect_to @book
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book deleted successfully"
  end

  def update_progress
    @book = Book.find(params[:id])
    pages = params[:book][:pages_read].to_i
  
    @book.pages_read = pages
    @book.status = "read" if @book.total_pages.present? && pages >= @book.total_pages
  
    if @book.save
      redirect_to @book, notice: "Progress updated!"
    else
      redirect_to @book, alert: "Could not update progress."
    end
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :description, :status, :cover_image, :rating, :pages_read, :total_pages, :start_date, :finish_date, :reading_notes)
    end

    def require_login
      unless Current.session&.user
        redirect_to login_path, alert: "You must be logged in to access this section."
      end
    end

    def authorize_book!
      redirect_to books_path, alert: "Not authorized." unless @book.user == Current.session.user
    end    
end