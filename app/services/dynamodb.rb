
class DynamoDB

  def initialize()
    @access_key = ENV['WINDY_ACCESS_KEY']
    @secret_key = ENV['WINDY_SECRET_KEY']
  end

  def call

    # create dynamodb client
    dynamodb_client = Aws::DynamoDB::Client.new(
      region: 'ap-southeast-2', # Syd-ers!
      access_key_id: @access_key,
      secret_access_key: @secret_key
    )

    # set params for table scan
    params = {
      table_name: 'enviro_0001',
      select: 'ALL_ATTRIBUTES',
      limit: 1000
    }

    # perform table scan
    resp = dynamodb_client.scan(params)

    sorted_items = resp.items.sort_by do |a|
      a["Timestamp"]
    end

    # convert timestamps to epoch time
    sorted_items.map! do |item|
      item["Timestamp"] = Time.parse(item["Timestamp"]).to_i
      item
    end

    sorted_items.map do |item|
      [
        item["Timestamp"],
        item["WindSpeed"].to_i
      ]
    end
  end
end