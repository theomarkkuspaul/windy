creds = CSV.read(APP_ROOT + 'aws-credentials.csv')[1]
access_key = creds[0]
secret_key = creds[1]

dynamodb_client = Aws::DynamoDB::Client.new(
  region: 'ap-southeast-2', # Syd-ers!
  access_key_id: access_key,
  secret_access_key: secret_key
)



puts 1