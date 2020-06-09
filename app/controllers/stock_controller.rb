class StockController < ApplicationController
    require 'bigdecimal/util'
    def manage
        hash = {}
        request.query_parameters.each do |key, value|
            if key=="function" || key=="name" || key=="amount" || key=="price"
            hash[key] = value.to_s
            else
            render plain: "ERROR\n" and return
            end
        end
  
        if hash["amount"].present? && hash["amount"] !~ /\A\d+\z/ or hash["price"].present? && hash["price"] !~ /\A\d+(\.\d+)?\z/
            render plain: "ERROR\n" and return
        end
  
        if hash["name"].present?
            @stock = Stock.find_by(name: hash["name"])
            if !@stock
                @stock = Stock.new(name: hash["name"], amount: 0, sale: 0)
                @stock.save
            end
        end
  
        if hash["function"]=="addstock" && hash["name"].present?
            if hash["amount"].present?
                @stock.amount += hash["amount"].to_i
            else
                @stock.amount += 1
            end
            if @stock.save
                head :ok
            else
                render plain: "ERRORn\n"
            end
  
        elsif hash["function"]=="checkstock"
            if hash["name"].present?
                render plain: "#{@stock.name}: #{@stock.amount}\n"
            else
                @stocks=Stock.all.order("lower(name)")
                out = ""
                @stocks.each do |stock|
                if stock.amount != 0
                    out << "#{stock.name}: #{stock.amount}\n"
                end
            end
            render plain: out
        end
  
        elsif hash["function"]=="sell" && hash["name"].present?
            if hash["amount"].present? && hash["price"].present?
                @stock.amount -= hash["amount"].to_i
                @stock.sale += (hash["amount"].to_d * hash["price"].to_d).to_f
            elsif hash["amount"].present?
                @stock.amount -= hash["amount"].to_i
            elsif hash["price"].present?
                @stock.amount -= 1
                @stock.sale += hash["price"].to_f
            else
                @stock.amount -= 1
            end
            if @stock.save
                head :ok
            else
            render plain: "ERROR\n"
            end
  
        elsif hash["function"]=="checksales"
            @sales = Stock.all.sum(:sale)
            if @sales.to_s =~ /\A\d+\.0\z/
                render plain: "sales: #{@sales.to_i}\n"
            else
                render plain: "sales: #{@sales.to_s.to_d.ceil(2)}\n"
            end
  
        elsif hash["function"]=="deleteall"
            @stocks = Stock.all
            @stocks.destroy_all
            head :ok
        else
            render plain: "ERROR\n"
        end
    end
end