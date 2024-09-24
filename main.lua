require "global_"
require "game_market"
require "game_chart"
require "game_window"
require "game_news"
require "game_time"
require "game_summary"
require "game_money"
require "math"

summary = {}
--timer = 0
--inmenu = true
--ingame = false
--game_time.hours = 7
--game_time.minutes = 59

love.load = function()
    math.randomseed(os.time(os.date("!*t")))
    timer = 0
    inmenu = true
    ingame = false
    game_time.hours = 0
    game_time.minutes = 0
    game_time.seconds = 0
    love.window.setTitle("pan-te's trading simulator")
    font_16 = love.graphics.newFont("font/unifont_sample.ttf", 16)
    window = game_window.load()
    market = game_market.createMarket(global_.market_start_value,
                                      global_.market_start_variation,
                                      global_.market_start_trend,
                                      global_.market_max_size - 1)
    chart = game_chart.createChart()
    wallet = game_money.createWallet(global_.start_money, market, global_.leverage)
    sell_button_index = window.addButton(wallet.sell, "sell_button", 830, 200)
    buy_button_index = window.addButton(wallet.buy, "buy_button", 930, 200)
    dec_button_index = window.addButton(wallet.decTransactionValue, "left", 840, 400)
    inc_button_index = window.addButton(wallet.incTransactionValue, "right", 968, 400)
end

love.update = function(dt)
    if ingame then 
        timer = timer + dt
        window.buttons[dec_button_index].unclick()
        window.buttons[inc_button_index].unclick()
        if timer > global_.time_scale then
            if window.buttons[sell_button_index].getStatus() and window.buttons[buy_button_index].getStatus() then
                window.buttons[sell_button_index].unclick()
                window.buttons[buy_button_index].unclick()
            end
            market.update()
            wallet.update()
            local event = game_news.newsHandling(market, dt, game_time.getTime())
            if string.len(event) > 2 then window.news_feed.update(event) end
            window.news_feed.updateDelayed()
            timer = 0
            game_time.update()
            if game_time.hours >= 8 or wallet.getAccountValue() <= 0 then
                summary = game_summary.generate(wallet)
                ingame = false     
            end
        end
    end
end

love.draw = function()
    if not inmenu then
        window.draw(font_16, game_time.getTime(), market, wallet)
        chart.draw(market, font_16)
        if not ingame then summary.draw(font_16) end
    else
        window.drawSplash()
    end
end

love.keypressed = function(key, scancode, isrepeat)
    if inmenu then
        if key == "space" then
            ingame = true
            inmenu = false
        end
    elseif ingame then
        if key == "escape" then
            ingame = false
            summary = game_summary.generate(wallet)
        end
    elseif key == "r" then
        love.load()
    end
end

love.mousepressed = function(x, y, button, istouch, presses)
    if ingame then window.checkButtons(x, y) end
end
