class Stock < ApplicationRecord

    has_many :user_stocks
    has_many :users, through: :user_stocks
    # before_action :create_stock_quote, only: [:new_from_lookup]

    def self.find_by_ticker(ticker_symbol)
        where(ticker: ticker_symbol).first
    end
         

    def self.new_from_lookup(ticker_symbol)
        StockQuote::Stock.new(api_key: 'sk_fde0b96783874fbba3cc7d8ed1b5d4cb')
        looked_up_stock = StockQuote::Stock.quote(ticker_symbol)
        return nil unless looked_up_stock.company_name

        new_stock = new(ticker: looked_up_stock.symbol, name: looked_up_stock.company_name)
        new_stock.last_price = new_stock.price
        new_stock
    end

    def price
        StockQuote::Stock.new(api_key: 'sk_fde0b96783874fbba3cc7d8ed1b5d4cb')
        closing_price = StockQuote::Stock.quote(ticker).close
        return "#{closing_price} (Closing)" if closing_price

        opening_price =  StockQuote::Stock.quote(ticker).open
        return "#{opening_price} (Opening)" if opening_price
        'Unavaiable'
    end

end
