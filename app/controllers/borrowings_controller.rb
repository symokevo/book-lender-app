class BorrowingsController < ApplicationController
  before_action :require_authentication
  def index
    if params[:borrower_name].present?
      @borrowings = Borrowing.where(
        borrower_name: params[:borrower_name]
      )
       .order(borrowed_at: :desc)
    else
      @borrowings = Borrowing.all.order(borrowed_at: :desc)
    end
  end
end
