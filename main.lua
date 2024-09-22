require "global_"
require "game_market"
require "game_chart"
require "game_window"
require "game_news"
require "game_time"
require "game_summary"
require "math"

summary = {}
timer = 0
inmenu = true
ingame = false
game_time.hours = 7
game_time.minutes = 59

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
--    font_10 = love.graphics.newFont("font/unifont_sample.ttf", 10)
    window = game_window.load()
    market = game_market.marketCreate(global_.market_start_value, 
                                      global_.market_start_variation,
                                      global_.market_start_trend,
                                      global_.market_max_size - 1)
    chart = game_chart.chartCreate()
end

love.update = function(dt)
    if ingame then 
        timer = timer + dt
        if timer > global_.time_scale then
            market.update()
            local event = game_news.newsHandling(market, dt, game_time.timeGet())
            if string.len(event) > 2 then window.news_feed.update(event) end
            timer = 0
            game_time.update()
            if game_time.hours >= 8 then
                summary = game_summary.generate()
                ingame = false     
            end
        end
    end
end

love.draw = function(dt)
    if not inmenu then
        window.draw(font_16, game_time.timeGet(), market)
        chart.draw(market, font_16)
        if not ingame then summary.draw() end
    else
        window.splashDraw()
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
            summary = game_summary.generate()
        end
    elseif key == "r" then
        love.load()
    end
end
