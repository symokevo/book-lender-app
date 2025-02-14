class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrower_name, presence: true
  validates :borrowed_at, presence: true
end
