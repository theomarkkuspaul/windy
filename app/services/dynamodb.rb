
module DynamoDB
 def self.call
    # Retrieve creds
    creds = CSV.read(APP_ROOT + 'aws-credentials.csv')[1]
    access_key = creds[0]
    secret_key = creds[1]

    # create dynamodb client
    dynamodb_client = Aws::DynamoDB::Client.new(
      region: 'ap-southeast-2', # Syd-ers!
      access_key_id: access_key,
      secret_access_key: secret_key
    )

    # set params for table scan
    params = {
      table_name: 'enviro_0001',
      select: 'ALL_ATTRIBUTES'
    }

    # perform table scan
    dynamodb_client.scan(params)
 end
end