require 'json'
require 'net/http'

module YahooFinance
  class Query
    API_URL = "https://query1.finance.yahoo.com"

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

      puts uri

      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = "SpicyStockApp/1.0"

      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        hash_result.store(symbol, process_output(JSON.parse(response.body)))
      else
        # Handle non-successful response
        puts "Failed to fetch data for symbol #{symbol}. HTTP Status: #{response.code}"
      end

      hash_result
    end


    private

    def process_output(json)
      return json["chart"]["result"][0]["indicators"]["adjclose"][0]["adjclose"].sample.round(2)
    end
  end
end
