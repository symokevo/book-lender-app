class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_at, presence: true
  validates :due_date, presence: true
  validate :book_availability

  private

  def book_availability
    if book.borrowings.where(returned_on: nil).exists?
      errors.add(:book, "is already borrowed")
    end
  end
end
