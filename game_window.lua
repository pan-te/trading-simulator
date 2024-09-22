require "global_"

game_window = {}

game_window.load = function()
    local window = {}
    window.news_feed = {}
    window.news_feed.news = {}
    window.image = love.graphics.newImage("texture/game_window.png")
    window.splash = love.graphics.newImage("texture/splash.png")
    window.scale_x = global_.width / global_.default_width
    window.scale_y = global_.height / global_.default_height

    window.news_feed.update = function(news)
        if window.news_feed.news[1] == nil then window.news_feed.news[1] = news
        else window.news_feed.news[table.getn(window.news_feed.news) + 1] = news
        end
        if table.getn(window.news_feed.news) > 6 then table.remove(window.news_feed.news, 1) end
    end

    window.news_feed.draw = function(font)
        love.graphics.setColor(192, 192, 192)
        love.graphics.setFont(font)
        if window.news_feed.news[1] ~= nil then
            for i=1,table.getn(window.news_feed.news) do
                local news = window.news_feed.news[i]
                love.graphics.print(news,
                                    20 * window.scale_x,
                                    (630 + 16 * (table.getn(window.news_feed.news) + 1 - i)) * window.scale_y,
                                    0,
                                    window.scale_x,
                                    window.scale_y)
            end
        end
    end

    window.currentDraw = function(market)
        love.graphics.setColor(255, 0, 0)
        love.graphics.print({"BID\n", string.format("%.4f", market.current())}, 
                            window.scale_x * 830,
                            window.scale_y * 150,
                            0,
                            window.scale_x * 1.2,
                            window.scale_y * 1.2)
    end

    window.askDraw = function(market)
        love.graphics.setColor(0, 255, 0)
        love.graphics.print({"ASK\n", string.format("%.4f", market.ask())}, 
                            window.scale_x * 930,
                            window.scale_y * 150,
                            0,
                            window.scale_x * 1.2,
                            window.scale_y * 1.2)
    end
    
    window.draw = function(font, time, market)
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(window.image, 0, 0, 0, window.scale_x, window.scale_y)
        love.graphics.setFont(font)
        love.graphics.print(time, window.scale_x * 850, window.scale_y * 120, 0, window.scale_x * 2, window.scale_y * 2)
        window.askDraw(market)
        window.currentDraw(market)
        window.news_feed.draw(font)
    end

    window.splashDraw = function()
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(window.splash, 0, 0, 0, window.scale_x, window.scale_y)
    end

    return window
end