json.array!(@users) do |user|
  json.extract! user, :first_name, :last_name, :username, :email, :password_hash, :password_salt
  json.url user_url(user, format: :json)
end
