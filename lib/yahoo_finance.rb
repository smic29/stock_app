require 'json'
require 'net/http'

module YahooFinance
  class Query
    API_URL = "https://query1.finance.yahoo.com"

    # Being based off of the basic_yahoo_finance gem, I failed to find the usage for this.
    def initialize(cache_url = nil)
      @cache_url = cache_url
    end

    def quote(symbol)
      hash_result = {}
      symbols = convert_to_arr(symbol)

      # Experienced some symbols returning empty values. I'm not sure what's causing that, so I added the calculation of time.
      start_ts, end_ts = generate_time

      symbols.each do |sym|
        next if sym.nil?

        uri = build_uri('/v7/finance/chart/', sym, period1: start_ts, period2: end_ts, interval: '1d', events: 'history', includeAdjustedClose: true)
        response = http_request(uri)

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

    def build_uri(endpoint, symbol_or_params = nil, params = {})
      if symbol_or_params.is_a?(Hash)
        params = symbol_or_params
        symbol = nil
      else
        symbol = symbol_or_params
      end

      endpoint += "#{symbol}" if symbol

      uri = URI.join(API_URL, endpoint)
      uri.query = URI.encode_www_form(params) unless params.empty?

      uri
    end

    def generate_time
      et_time_now = Time.now.in_time_zone('Eastern Time (US & Canada)')
      start_time = et_time_now - 7.days
      end_ts = et_time_now.to_i
      start_ts = start_time.to_i

      [start_ts, end_ts]
    end

    def http_request(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 10

      request = Net::HTTP::Get.new(uri)
      request['User-Agent'] = "SpicyStockApp/1.0"

      http.request(request)
    end

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
      uri = build_uri('/v1/finance/quoteType/', symbol: symbol)
      response = http_request(uri)

      if response.is_a?(Net::HTTPSuccess)
        JSON.parse(response.body)["quoteType"]["result"][0]["longName"]
      else
        puts "Failed to fetch quote type data for symbol #{symbol}. HTTP Status: #{response.code}"
        nil
      end
    end
  end
end
