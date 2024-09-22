require "math"
require "global_"
require "game_candles"

game_chart = {}

game_chart.chartCreate = function()
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
        local scale = chart.background:getPixelHeight() / (market.max() - market.min())
        local candles = game_candles.generateCandles(market)
        for i=2,candles.num do
            if candles.candle[i].last ~= nil then
                local box = {i * 6 - 2, (candles.candle[i].last - market.min()) * scale,
                            4, (candles.candle[i].first - candles.candle[i].last) * scale}
                local line = {i * 6, (candles.candle[i].max - market.min()) * scale,
                            i * 6, (candles.candle[i].min - market.min()) * scale}
                if candles.candle[i].last > candles.candle[i].first then
                    love.graphics.setColor(0, 255, 0)
                else
                    love.graphics.setColor(255, 0, 0)
                end
                love.graphics.line(line[1], line[2], line[3], line[4])
                love.graphics.rectangle("fill", box[1], box[2], box[3], box[4])
                love.graphics.line(i * 6 - 1, box[2], i * 6 + 1, box[2])
            end
        end
    end

    chart.drawCurrentValue = function(market, font)
        love.graphics.setColor(128, 0, 0)
        local current_value = (market.current() - market.min()) * chart.background:getPixelHeight() / (market.max() - market.min())
        love.graphics.line(0, current_value, chart.background:getPixelWidth() - 80, current_value)
        love.graphics.setFont(font)
        love.graphics.print(string.format("%.4f", market.current()), chart.background:getPixelWidth() - 64,  current_value + 8, 0, 1, -1)
    end

    chart.drawAskValue = function(market, font)
        if market.ask() < market.max() then
            love.graphics.setColor(0, 128, 0)
            local current_value = (market.ask() - market.min()) * chart.background:getPixelHeight() / (market.max() - market.min())
            love.graphics.line(0, current_value, chart.background:getPixelWidth() - 80, current_value)
            love.graphics.setFont(font)
            love.graphics.print(string.format("%.4f", market.ask()), chart.background:getPixelWidth() - 64,  current_value + 8, 0, 1, -1)
        end
    end
    
    chart.drawTopValue = function(market, font)
        love.graphics.setColor(160, 160, 160)
        local current_value = (market.max() - market.min()) * chart.background:getPixelHeight() / (market.max() - market.min())
        love.graphics.line(0, current_value, chart.background:getPixelWidth() - 80, current_value)
        love.graphics.setFont(font)
        love.graphics.print(string.format("%.4f", market.max()), chart.background:getPixelWidth() - 64,  current_value + 8, 0, 1, -1)
    end

    chart.drawBottomValue = function(market, font)
        love.graphics.setColor(160, 160, 160)
        local current_value = 0
        love.graphics.line(0, current_value, chart.background:getPixelWidth() - 80, current_value)
        love.graphics.setFont(font)
        love.graphics.print(string.format("%.4f", market.min()), chart.background:getPixelWidth() - 64,  current_value + 8, 0, 1, -1)
    end

    chart.draw = function(market, font)
        love.graphics.applyTransform(chart.transform)
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(chart.background,  0, 0, 0)
        chart.drawCandles(market)
        chart.drawCurrentValue(market, font)
        chart.drawAskValue(market, font)
        chart.drawTopValue(market, font)
        chart.drawBottomValue(market, font)
    end
    
    return chart
end