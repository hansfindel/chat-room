json.array!(@rooms) do |room|
  json.extract! room, :name, :topic, :user_id
  json.url room_url(room, format: :json)
end
