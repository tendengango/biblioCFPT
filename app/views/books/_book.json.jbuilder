json.extract! book, :id, :isbn, :title, :authors, :language, :published, :edition, :summary, :quantity, :created_at, :updated_at
json.url book_url(book, format: :json)
