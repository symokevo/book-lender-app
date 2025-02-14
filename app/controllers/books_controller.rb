class BooksController < ApplicationController
  before_action :require_authentication, only: [ :new, :edit, :create, :update, :destroy, :borrow, :return ]
  before_action :set_book, only: [ :show, :edit, :update, :destroy, :borrow, :return ]

  def index
    @books = Book.all
  end

  def show
    @book.reload
    @borrowings = @book.borrowings.order(borrowed_at: :desc)
  end

  def new
    @book = Book.new
    @books = Book.all
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(books_params)
    if @book.save
      redirect_to @book, notice: "The books was successfully added :)"
    else
      render :new
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(books_params)
      redirect_to @book, notice: "The book was successfully updated :)"
    else
      render :edit
    end
  end

  def destroy
    if @book.destroy
      redirect_to books_url, notice: "The book was successfully deleted :("
    else
      redirect_to books_url, alert: "The book was not deleted :("
    end
  end

  def borrow
    if @book.status == "available" && @book.update(status: "borrowed")
      @book.borrowings.create(
        borrower_name: params[:borrower_name],
        borrowed_at: Time.current,
        due_date: Time.current + 2.weeks
      )
        redirect_to book_path, notice: "The book was successfully borrowed :)"
    else
        redirect_to book_path, alert: "Someone seems to have the book :("
    end
  end

  def borrow
    # Ensures the book is available
    if @book.status == "available"
      # Use a transaction to ensure atomicity
      ActiveRecord::Base.transaction do
        # Update the book's status
        @book.update!(status: "borrowed")

        # Create a borrowing record
        @book.borrowings.create!(
          user_id: Current.user.id,
          borrower_name: params[:borrower_name],
          borrowed_at: Time.current,
          due_date: Time.current + 2.weeks
        )
      end

      # Redirect with a success message
      redirect_to book_path, notice: "The book was successfully borrowed :)"
    else
      # Redirect with an error message
      redirect_to book_path, alert: "Someone seems to have the book :("
    end
  rescue ActiveRecord::RecordInvalid => e
    # Handle validation or database errors
    redirect_to book_path, alert: "Something went wrong: #{e.message}"
  end

  def return
    # Use a transaction to ensure atomicity
    ActiveRecord::Base.transaction do
      # Update the book's status
      @book.update!(status: "available")

      # Find the latest borrowing record
      borrowing = @book.borrowings.where(returned_on: nil).last

      # Raise an error if no borrowing record is found
      raise ActiveRecord::RecordNotFound, "No active borrowing record found" unless borrowing

      # Update the borrowing record
      borrowing.update!(returned_on: Time.current)
    end

    # Redirect with a success message
    redirect_to @book, notice: "Book was successfully returned :)"
  rescue ActiveRecord::RecordNotFound => e
    # Handle case where no borrowing record is found
    redirect_to @book, alert: "No active borrowing record found :("
  rescue ActiveRecord::RecordInvalid => e
    # Handle validation or database errors
    redirect_to @book, alert: "Something went wrong: #{e.message}"
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def books_params
    params.require(:book).permit(:title, :author, :isbn, :status)
  end
end
