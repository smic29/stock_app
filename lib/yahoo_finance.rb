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
          quote_data = process_output(JSON.parse(response.body))
          quote_type_data = quote_type(sym)
          hash_result.store(sym, quote_data.merge({ "name" => quote_type_data })) if quote_data && quote_type_data
        else
          puts "Failed to fetch data for symbol #{sym}. HTTP Status: #{response.code}"
          hash_result.store(sym, nil)
        end
      end

      hash_result
    end


    private

    def process_output(json)
      chart_result = json.dig('chart', 'result')
      return nil if chart_result.nil?

      indicators = chart_result.first['indicators']
      meta_data = chart_result.first['meta']

      adjclose = indicators.dig('adjclose', 0, 'adjclose')
      return nil if adjclose.nil?

      quote = indicators.dig('quote', 0)

      {
        "prices" => adjclose.map { |price| price.round(2) },
        "symbol" => meta_data['symbol'],
        "yearHigh" => meta_data['fiftyTwoWeekHigh'],
        "yearLow" => meta_data['fiftyTwoWeekLow'],
        "previousClose" => meta_data['chartPreviousClose'],
        "quote" => quote.merge("timestamps" => chart_result.first['timestamp'])
      }
    end

    def convert_to_arr(symbol)
      symbol.instance_of?(Array) ? symbol : [symbol]
    end

    def quote_type(symbol)
      uri = URI("#{API_URL}/v1/finance/quoteType/?symbol=#{symbol}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 10
      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = "SpicyStockApp/1.0"
      response = http.request(request)

      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)["quoteType"]["result"][0]["longName"]
      else
        puts "Failed to fetch quote type data for symbol #{symbol}. HTTP Status: #{response.code}"
        nil
      end
    end
  end
end
