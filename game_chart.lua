require "math"
require "global_"
require "game_candles"

game_chart = {}

game_chart.createChart = function()
    local chart = {}
    chart.background = love.graphics.newImage("texture/chart.png")
    chart.scale_x = love.graphics.getWidth() / global_.default_width
    chart.scale_y = love.graphics.getHeight() / global_.default_height
    chart.offset_x = 16
    chart.offset_y = chart.background:getPixelHeight() + 16
    chart.newHeight = love.graphics.getWidth(chart.background) * chart.scale_y
    chart.transform = love.math.newTransform()
    chart.transform:scale(1 * chart.scale_x, -1 * chart.scale_y)
    chart.transform:translate(chart.offset_x, -chart.offset_y )

    chart.drawCandles = function(market)
        local scale = chart.background:getPixelHeight() / (market.getMax() - market.getMin())
        local candles = game_candles.generateCandles(market)
        for i=2,candles.num do
            if candles.candle[i] ~= nil then
                local box = {i * 6 - 2, (candles.candle[i].last - market.getMin()) * scale,
                            4, (candles.candle[i].first - candles.candle[i].last) * scale}
                local line = {i * 6, (candles.candle[i].max - market.getMin()) * scale,
                            i * 6, (candles.candle[i].min - market.getMin()) * scale}
                if candles.candle[i].last > candles.candle[i].first then
                    love.graphics.setColor(0, 1, 0)
                else
                    love.graphics.setColor(1, 0, 0)
                end
                love.graphics.line(line[1], line[2], line[3], line[4])
                love.graphics.rectangle("fill", box[1], box[2], box[3], box[4])
                love.graphics.line(i * 6 - 1, box[2], i * 6 + 1, box[2])
            end
        end
    end

    chart.drawCurrentValue = function(market, font)
        love.graphics.setColor(1, 0, 0)
        local current_value = (market.getBid() - market.getMin()) * chart.background:getPixelHeight() / (market.getMax() - market.getMin())
        love.graphics.line(0, current_value, chart.background:getPixelWidth() - 80, current_value)
        love.graphics.setFont(font)
        love.graphics.print(string.format("%.4f", market.getBid()), chart.background:getPixelWidth() - 64,  current_value + 8, 0, 1, -1)
    end

    chart.drawAskValue = function(market, font)
        if market.getAsk() < market.getMax() then
            love.graphics.setColor(0, 1, 0)
            local current_value = (market.getAsk() - market.getMin()) * chart.background:getPixelHeight() / (market.getMax() - market.getMin())
            love.graphics.line(0, current_value, chart.background:getPixelWidth() - 80, current_value)
            love.graphics.setFont(font)
            love.graphics.print(string.format("%.4f", market.getAsk()), chart.background:getPixelWidth() - 64,  current_value + 8, 0, 1, -1)
        end
    end
    
    chart.drawTopValue = function(market, font)
        love.graphics.setColor(0.7, 0.7, 0.7)
        local current_value = (market.getMax() - market.getMin()) * chart.background:getPixelHeight() / (market.getMax() - market.getMin())
        love.graphics.line(0, current_value, chart.background:getPixelWidth() - 80, current_value)
        love.graphics.setFont(font)
        love.graphics.print(string.format("%.4f", market.getMax()), chart.background:getPixelWidth() - 64,  current_value + 8, 0, 1, -1)
    end

    chart.drawBottomValue = function(market, font)
        love.graphics.setColor(0.7, 0.7, 0.7)
        local current_value = 0
        love.graphics.line(0, current_value, chart.background:getPixelWidth() - 80, current_value)
        love.graphics.setFont(font)
        love.graphics.print(string.format("%.4f", market.getMin()), chart.background:getPixelWidth() - 64,  current_value + 8, 0, 1, -1)
    end

    chart.draw = function(market, font)
        love.graphics.replaceTransform(chart.transform)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(chart.background,  0, 0, 0)
        chart.drawCandles(market)
        chart.drawCurrentValue(market, font)
        chart.drawAskValue(market, font)
        chart.drawTopValue(market, font)
        chart.drawBottomValue(market, font)
        love.graphics.replaceTransform(love.math.newTransform())
    end
    
    return chart
end
