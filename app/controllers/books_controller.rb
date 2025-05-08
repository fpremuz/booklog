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
    @books = Current.session.user.books.includes(cover_image_attachment: :blob).order(:status, :title)
  
    pdf = Prawn::Document.new(page_size: "A4", margin: 40)
  
    pdf.text "My Book List", size: 24, style: :bold, align: :center
    pdf.stroke_horizontal_rule
    pdf.move_down 20
  
    grouped_books = @books.group_by(&:status)
  
    grouped_books.each do |status, books|
      pdf.start_new_page unless pdf.page_number == 1
      pdf.text status.titleize, size: 18, style: :bold, color: "0077CC"
      pdf.move_down 10
  
      table_data = [["", "Title", "Author", "Description"]]
  
      books.each do |book|
        image_path = if book.cover_image.attached?
          Rails.root.join("tmp", "#{book.id}_cover.jpg").tap do |path|
            File.open(path, "wb") do |file|
              file.write(book.cover_image.download)
            end
          end
        end
  
        row = []
        if image_path
          row << { image: image_path.to_s, fit: [40, 60] }
        else
          row << ""
        end
  
        row << book.title
        row << (book.author.presence || "—")
        row << (book.description.present? ? book.description.truncate(100) : "—")
  
        table_data << row
      end
  
      pdf.table(table_data, width: pdf.bounds.width, cell_style: { inline_format: true }) do
        row(0).font_style = :bold
        row(0).background_color = 'EEEEEE'
        cells.padding = 8
        cells.borders = [:bottom]
        column(0).width = 50
        column(1..3).size = 10
      end
  
      pdf.move_down 20
    end
  
    pdf.number_pages "Page <page> of <total>", at: [pdf.bounds.right - 100, 0]
    pdf.draw_text "Generated on #{Time.zone.now.strftime('%B %d, %Y')}", at: [0, 0]
  
    send_data pdf.render,
              filename: "booklog.pdf",
              type: "application/pdf",
              disposition: "inline"
    ensure
      Dir[Rails.root.join("tmp", "*_cover.jpg")].each { |file| File.delete(file) }
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :author, :description, :status, :cover_image, :rating, :pages_read, :total_pages, :start_date, :finish_date, :reading_notes, :public)
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