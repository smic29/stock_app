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
      symbols = convert_to_arr(symbol)

      # Experienced some symbols returning empty values. I'm not sure what's causing that.
      et_time_now = Time.now.in_time_zone('Eastern Time (US & Canada)')
      start_time = et_time_now - 7.days
      end_ts = et_time_now.to_i
      start_ts = start_time.to_i

      symbols.each do |sym|
        next if sym.nil?

        uri = URI("#{API_URL}/v7/finance/chart/#{sym}?period1=#{start_ts}&period2=#{end_ts}&interval=1d&events=history&includeAdjustedClose=true")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.read_timeout = 10

        request = Net::HTTP::Get.new(uri)
        request['User-Agent'] = "SpicyStockApp/1.0"

        response = http.request(request)
        # puts uri # This is for when I want to check the data.

        if response.is_a?(Net::HTTPSuccess)
          hash_result.store(sym, process_output(JSON.parse(response.body)))
        else
          puts "Failed to fetch data for symbol #{sym}. HTTP Status: #{response.code}"
          hash_result.store(sym, nil)
        end
      end

      hash_result
    end


    private

    def process_output(json)
      result = {}
      base = json["chart"]["result"]
      return nil if base == nil

      prices = base[0]["indicators"]["adjclose"][0]["adjclose"]
      misc_data = base[0]['meta']

      return nil if prices == nil

      result["prices"] = prices.map { |price| price.round(2) } # sample.round(2)
      result["symbol"] = misc_data['symbol']
      result["yearHigh"] = misc_data['fiftyTwoWeekHigh']
      result["yearLow"] = misc_data['fiftyTwoWeekLow']
      result["previousClose"] = misc_data['chartPreviousClose']
      result["quote"] = base[0]["indicators"]["quote"][0]
      result["quote"]["timestamps"] = base[0]["timestamp"]

      result
    end

    def convert_to_arr(symbol)
      symbol.instance_of?(Array) ? symbol : [symbol]
    end
  end
end
