class BorrowingsController < ApplicationController
  def index
    @borrowings = Borrowing.all
    @borrower_name = params[:borrower_name]
    @borrowings = Borrowing.where(borrower_name: @borrower_name)
      .order(borrowed_at: :desc)
  end
end
