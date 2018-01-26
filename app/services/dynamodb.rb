
class DynamoDB

  def initialize()
    @access_key = ENV['WINDY_ACCESS_KEY']
    @secret_key = ENV['WINDY_SECRET_KEY']
    @payload = []
    @scan_count = 0
    @scan_count_maximum = 2
  end

  def call

    scan

    sorted_items = @payload.sort_by do |a|
      a["Timestamp"]
    end

    # convert timestamps to epoch time
    sorted_items.map! do |item|
      item["Timestamp"] = Time.parse(item["Timestamp"]).to_i * 1000 # convert to milliseconds
      item
    end

    sorted_items.map! do |item|
      [
        item["Timestamp"],
        item["WindSpeed"].to_f
      ]
    end
  end

  def scan(last_evaluated_key = '')

    # set params for table scan
    params = {
      table_name: 'enviro_0001',
      select: 'ALL_ATTRIBUTES'
      # limit: 1000,
    }

    puts "Scan count: #{@scan_count}"
    puts "Scanning"

    # perform table scan
    resp = client.scan(params)
    @scan_count += 1

    # add data to payload container
    @payload.push(resp.items).flatten!

    return @payload if @scan_count >= @scan_count_maximum

    if resp.last_evaluated_key
      params["last_evaluated_key"] = last_evaluated_key
      scan(resp.last_evaluated_key)
    end

    @payload
  end

  def client
    # create dynamodb client
    Aws::DynamoDB::Client.new(
      region: 'ap-southeast-2', # Syd-ers!
      access_key_id: @access_key,
      secret_access_key: @secret_key
    )
  end
end