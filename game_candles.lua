require "math"
require "global_"

game_candles = {}

game_candles.newCandle = function(market, start_index, end_index)
    local candle = {}
    local candle_values = {}
    for i=start_index,end_index do
        candle_values[i - start_index + 1] = market.values[i]
    end
    if table.getn(candle_values) > 2 then 
        candle.first = candle_values[1]
        candle.last = candle_values[table.getn(candle_values)]
        if candle.last == nil then candle.last = candle.first end
        if candle.first == candle.last and candle.first ~= nil then candle.last = candle.first end
        candle.max = math.max(unpack(candle_values))
        candle.min = math.min(unpack(candle_values))
        return candle
    end
end

game_candles.generateCandles = function(market)
    local candles_set = {}
    candles_set.candle = {}
    if market.length() > 0 then
        candles_set.num = math.floor(market.length() / global_.interval) + 1
        for i=1,candles_set.num do
            if i * global_.interval > market.length() then
                candles_set.candle[i] = game_candles.newCandle(market, (i - 1) * global_.interval + 1, market.length())
            else
                candles_set.candle[i] = game_candles.newCandle(market, (i - 1) * global_.interval + 1, i * global_.interval)
            end
        end
    end
    return candles_set
end
