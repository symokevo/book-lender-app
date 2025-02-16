require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  include Authentication

  setup do
    @book = books(:one)
    @user = users(:test_user)
    sign_in_for_test(@user)
  end

  private

  def sign_in_for_test(user)
    session = user.sessions.create!
    cookies.signed[:session_id] = session.id
  end

  def sign_out_for_test
    cookies.delete(:session_id)
    Current.user = nil
  end

  test "should get index" do
    get books_url
    assert_response :success
    assert_select "h1", "Books"
  end

  test "should show book" do
    get book_url(@book)
    assert_response :success
    assert_select "h1", @book.title
  end

  test "should get new" do
    get new_book_url
    assert_response :success
    assert_select "form"
  end

  test "should create book" do
    assert_difference("Book.count") do
      post books_url, params: { book: { title: "New Book", author: "New Author", isbn: "1234567890", status: "available" } }
    end
    assert_redirected_to book_url(Book.last)
    assert_equal "The books was successfully added :)", flash[:notice]
  end

  test "should not create invalid book" do
    assert_no_difference("Book.count") do
      post books_url, params: { book: { title: "", author: "", isbn: "", status: "" } }
    end
    assert_response :unprocessable_entity
  end

  test "should get edit" do
    get edit_book_url(@book)
    assert_response :success
    assert_select "form"
  end

  test "should update book" do
    patch book_url(@book), params: { book: { title: "Updated Title" } }
    assert_redirected_to book_url(@book)
    assert_equal "The book was successfully updated :)", flash[:notice]
    @book.reload
    assert_equal "Updated Title", @book.title
  end

  test "should not update invalid book" do
    patch book_url(@book), params: { book: { title: "" } }
    assert_response :unprocessable_entity
    @book.reload
    assert_not_equal "", @book.title
  end

  test "should destroy book" do
    assert_difference("Book.count", -1) do
      delete book_url(@book)
    end
    assert_redirected_to books_url
    assert_equal "The book was successfully deleted :(", flash[:notice]
  end

  test "should borrow book" do
    @book.update(status: "available")
    post borrow_book_url(@book), params: { borrower_name: "Test Borrower" }
    assert_redirected_to book_url(@book)
    assert_equal "The book was successfully borrowed :)", flash[:notice]
    @book.reload
    assert_equal "borrowed", @book.status
    assert_equal 1, @book.borrowings.count
  end

  test "should not borrow unavailable book" do
    @book.update(status: "borrowed")
    post borrow_book_url(@book), params: { borrower_name: "Test Borrower" }
    assert_redirected_to book_url(@book)
    assert_equal "Someone seems to have the book :(", flash[:alert]
    @book.reload
    assert_equal "borrowed", @book.status
    assert_equal 0, @book.borrowings.count
  end

  test "should return book" do
    @book.update(status: "borrowed")
    @book.borrowings.create(user_id: @user.id, borrower_name: "Test Borrower", borrowed_at: Time.current, due_date: Time.current + 2.weeks)
    post return_book_url(@book)
    assert_redirected_to book_url(@book)
    assert_equal "Book was successfully returned :)", flash[:notice]
    @book.reload
    assert_equal "available", @book.status
    assert_not_nil @book.borrowings.last.returned_on
  end

  test "should not return already available book" do
    @book.update(status: "available")
    post return_book_url(@book)
    assert_redirected_to book_url(@book)
    assert_equal "The book is not returned :(", flash[:alert]
    @book.reload
    assert_equal "available", @book.status
  end

  test "should redirect to sign-in page when not signed in" do
    sign_out_for_test
    get books_url
    assert_redirected_to new_session_path
    assert_equal "Please sign in to continue", flash[:notice]
  end
end
