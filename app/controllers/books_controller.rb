class BooksController < ApplicationController
  before_action :require_login
  before_action :set_book, only: %i[ show edit update destroy ]
  before_action :authorize_book!, only: %i[edit update destroy]

  def index
    if Current.session&.user
      @books = Current.session.user.books
  
      @books = @books.search(params[:query]) if params[:query].present?
      @books = @books.with_status(params[:status]) if params[:status].present?
      @books = @books.with_rating(params[:rating]) if params[:rating].present?
      @books = @books.rating_above(params[:rating_filter]) if params[:rating_filter].present?
      @books = @books.with_tags(params[:tags_list]) if params[:tags_list].present?
      @books = @books.page(params[:page]).per(12)
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
  
    pages = @book.pages_read || 0
    total = @book.total_pages
  
    if total.present? && total > 0
      @book.status = if pages >= total
        "read"
      elsif pages > 0
        "reading"
      else
        "to_read"
      end
    else
      @book.status = pages > 0 ? "reading" : "to_read"
    end
  
    if @book.save
      update_tags(@book, params[:tag_names])
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
      pages = @book.pages_read || 0
      total = @book.total_pages
  
      new_status = if total.present? && total > 0
        if pages >= total
          "read"
        elsif pages > 0
          "reading"
        else
          "to_read"
        end
      else
        pages > 0 ? "reading" : "to_read"
      end
  
      @book.update_column(:status, new_status)
      update_tags(@book, params[:tag_names])
  
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
    total = @book.total_pages
  
    @book.pages_read = pages
  
    if total.present? && total > 0
      if pages >= total
        @book.status = "read"
      elsif pages > 0
        @book.status = "reading"
      else
        @book.status = "to_read"
      end
    else
      @book.status = pages > 0 ? "reading" : "to_read"
    end
  
    if @book.save
      redirect_to @book, notice: "Progress updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def export_pdf
    @books = Book.all

    pdf = Prawn::Document.new
    pdf.text "My Book List", size: 24, style: :bold, align: :center
    pdf.move_down 20

    @books.each do |book|
      pdf.text book.title, size: 16, style: :bold
      pdf.text "Author: #{book.author}" if book.author.present?
      pdf.text "Status: #{book.status.titleize}" if book.status.present?
      pdf.text "Description: #{book.description.truncate(100)}", size: 10 if book.description.present?
      pdf.move_down 10
    end

    send_data pdf.render,
              filename: "booklog.pdf",
              type: "application/pdf",
              disposition: "inline"
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :author, :description, :status, :cover_image, :rating, :pages_read, :total_pages, :start_date, :finish_date, :reading_notes)
    end

    def require_login
      unless Current.session&.user
        redirect_to login_path, alert: "You must be logged in to access this section."
      end
    end

    def authorize_book!
      redirect_to books_path, alert: "Not authorized." unless @book.user == Current.session.user
    end    

    def update_tags(book, tag_names)
      tags_list = tag_names.to_s.split(",").map(&:strip).reject(&:blank?).uniq
      tags = tags_list.map { |name| Tag.find_or_create_by(name: name.downcase) }
      book.tags = tags
    end
end