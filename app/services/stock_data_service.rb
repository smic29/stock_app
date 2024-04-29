class StockDataService
  def initialize
    @redis = Redis.new(url: ENV['REDIS_URL'])
  end

  def save_stock_data_to_redis(user)
    key = "symbol_data:user_#{user.id}"

    if should_update_stock_data?(key)
      stock_data = lookup_symbol(user.stocks.not_zero.distinct.pluck(:symbol))
      @redis.set(key, stock_data)
      @redis.set("#{key}_updated_at", Time.current)
    end
  end

  def retrieve_stock_data_from_redis(user)
    key = "symbol_data:user_#{user.id}"
    stock_data_json = @redis.get(key)
    stock_data = JSON.parse(stock_data_json.gsub('=>', ':')) if stock_data_json
    stock_data
  end

  def clear_stock_data_from_redis(user)
    key = "symbol_data:user_#{user.id}"
    @redis.del(key)
    @redis.del("#{key}_updated_at")
  end

  def add_data_to_redis(user, data)
    key = "symbol_data:user_#{user.id}"

    @redis.set(key, data)
    @redis.set("#{key}_updated_at", Time.current)
  end


  private

  def should_update_stock_data?(key)
    @redis.get(key).nil? || @redis.get("#{key}_updated_at").nil? || Time.parse(@redis.get("#{key}_updated_at")) < 24.hours.ago
  end

  def lookup_symbol(symbol)
    query = YahooFinance::Query.new
    data = query.quote(symbol)

    data
  end
end
