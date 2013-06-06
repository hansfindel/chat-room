json.array!(@forums) do |forum|
  json.extract! forum, :name
  json.url forum_url(forum, format: :json)
end
