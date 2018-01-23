
get '/' do
  erb :index
end

get '/data' do
  content_type :json

  DynamoDB.call.to_json
end