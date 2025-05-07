class AnalyticsController < ApplicationController
  def index
    @books_read_this_year = Book.where(status: "read")
                                .where("finish_date >= ?", Date.current.beginning_of_year)
                                .count

    @currently_reading = Book.where(status: "reading").count

    @average_rating = Book.where.not(rating: nil).average(:rating)&.round(2) || "N/A" 

    @total_pages_read = Book.sum(:pages_read)

    @books_per_month = Book.where(status: "read")
                       .where("finish_date >= ?", Date.current.beginning_of_year)
                       .group_by { |b| b.finish_date.strftime("%B") }
                       .transform_values(&:count)
                       .sort_by { |month, _| Date::MONTHNAMES.index(month) }
                       .to_h
  end
end