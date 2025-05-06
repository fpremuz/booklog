class AnalyticsController < ApplicationController
  def index
    @books_read_this_year = Book.where(status: "read")
                                .where("finish_date >= ?", Date.current.beginning_of_year)
                                .count

    @currently_reading = Book.where(status: "reading").count

    @average_rating = Book.where.not(rating: nil).average(:rating)&.round(2) || "N/A"

    @total_pages_read = Book.sum(:pages_read)
  end
end