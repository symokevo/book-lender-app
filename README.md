# Book Lending Library

A simple Ruby on Rails application to manage books and track their lending history.

## You need:
- ruby 3.3.7
- rails 8.0.1

## Setup 
1. Clone the ropository: 
   ```bash
   git clone https://github.com/symokevo/book-lender-app.git
   cd book-lender-app
2. Install dependencies
   ```bash
   bundle install 
   yarn install (optional)
3. Setup the database
   ```bash
   rails db:setup
4. Create at least a book or 2 (This step is optional because you can just sign up and use the inbuilt form to create a abook)
   ```bash
   rails c
   Book.create(title: "A Test eBook", author: "Simon Rabuogi", isbn: "123456789", status: "available")
5. Start the server
   ```bash
   rails s
6. visit http://localhost:3000

## Note
This is a work in progress. A lot of changes and enhancements are still necessary. Feel free to share your recommendations.

### Feedback
I would like to hear your feedback
