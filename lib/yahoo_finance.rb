require 'json'
require 'net/http'

module YahooFinance
  class Query
    API_URL = "https://query1.finance.yahoo.com"

    # I have no idea what this does, but I think it has something to do with using Redis so
    # I'm keeping it here.
    def initialize(cache_url = nil)
      @cache_url = cache_url
    end

    def quote(symbol)
      hash_result = {}

      #Experienced some symbols returning empty values. I'm not sure what's causing that.
      et_time_now = Time.now.in_time_zone('Eastern Time (US & Canada)')
      start_time = et_time_now - 7.days
      end_ts = et_time_now.to_i
      start_ts = start_time.to_i

      uri = URI("#{API_URL}/v7/finance/chart/#{symbol}?period1=#{start_ts}&period2=#{end_ts}&interval=1d&events=history&includeAdjustedClose=true")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 10

      # puts uri -> was testing failed queries, kept it here as placeholder for when I want
      # to write code on making symbols into an array. Maybe. who knows.

      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = "SpicyStockApp/1.0"

      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        hash_result.store(symbol, process_output(JSON.parse(response.body)))
      else
        puts "Failed to fetch data for symbol #{symbol}. HTTP Status: #{response.code}"
        hash_result.store(symbol, "No data found")
      end

      hash_result
    end


    private

    def process_output(json)
      base = json["chart"]["result"]
      return "No data available" if base == nil

      price = base[0]["indicators"]["adjclose"][0]["adjclose"]

      return "Price history unavailable" if price == nil

      price.sample.round(2)
    end
  end
end
