require "math"
require "global_"

game_market = {}

game_market.max_size = global_.market_max_size

game_market.createMarket = function(start_value, maxdy, trend, time)
    local market = {}
    market.values = {} 
    market.values[1] = start_value
    market.trend = trend
    market.update = function()
        local dy = math.random((-maxdy + market.trend) * global_.market_value_to_variation,
                              (maxdy + market.trend) * global_.market_value_to_variation) / global_.market_value_to_variation
        local num = table.getn(market.values) + 1
        market.values[num] = market.values[num - 1] + dy
        if num > game_market.max_size then
            for i=1,global_.interval do
                table.remove(market.values, i)
            end
        end
    end

    market.getMax = function()
        return math.max(unpack(market.values))
    end

    market.getMin = function()
        return math.min(unpack(market.values))
    end

    market.getBid = function()
        return market.values[table.getn(market.values)]
    end

    market.getAsk = function()
        return market.getBid() * global_.bid_to_ask
    end

    market.getLength = function()
        return table.getn(market.values)
    end

    market.changeTrend = function(value)
        market.trend = value
    end

    market.getTrend = function()
        return market.trend
    end

    for i=1,time do market.update() end

    return market
end
