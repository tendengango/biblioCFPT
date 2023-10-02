json.extract! cover, :id, :name, :portrait, :created_at, :updated_at
json.url cover_url(cover, format: :json)
json.portrait url_for(cover.portrait)
