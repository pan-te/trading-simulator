require "global_"

game_window = {}

game_window.load = function()
    local window = {}
    window.news_feed = {}
    window.news_feed.news = {}
    window.news_feed.delayed = {}
    window.news_feed.timer = global_.news_update_time
    window.image = love.graphics.newImage("texture/game_window.png")
    window.splash = love.graphics.newImage("texture/splash.png")
    window.scale_x = global_.width / global_.default_width
    window.scale_y = global_.height / global_.default_height
    window.buttons = {}
    
    window.addButton = function(task, texture_path, x0, y0)
        local button = {}
        button.name = texture_path
        button.image = love.graphics.newImage("texture/" .. texture_path .. ".png")
        button.image_clicked = love.graphics.newImage("texture/" .. texture_path .. "_clicked.png")
        button.x = x0 * window.scale_x
        button.y = y0 * window.scale_y
        button.w = button.image:getPixelWidth() * window.scale_x
        button.h = button.image:getPixelHeight() * window.scale_y
        button.task = task
        button.is_clicked = false

        button.getStatus = function()
            return button.is_clicked
        end

        button.unclick = function()
            button.is_clicked = false
        end

        local button_index = table.getn(window.buttons) + 1
        window.buttons[button_index] = button
        return button_index
    end
    
    window.drawButtons = function()
        love.graphics.setColor(255, 255, 255)
        for i=1,table.getn(window.buttons) do
            local image = {}
            if window.buttons[i].is_clicked then
                image = window.buttons[i].image_clicked
            else
                image = window.buttons[i].image
            end
            love.graphics.draw(image, window.buttons[i].x, window.buttons[i].y, 0, window.scale_x, window.scale_y)
        end
    end
    
    window.checkButtons = function(x, y, arg1, arg2, arg3, arg4, arg5)
        for i=1,table.getn(window.buttons) do
            if x > window.buttons[i].x and x < window.buttons[i].x + window.buttons[i].w then
                if y > window.buttons[i].y and y < window.buttons[i].y + window.buttons[i].h and window.buttons[i].is_clicked == false then
                    window.buttons[i].is_clicked = true
                    window.buttons[i].task(arg1, arg2, arg3, arg4, arg5)
                end
            end
        end
    end
	

    window.news_feed.update = function(news)
        if window.news_feed.news[1] == nil then window.news_feed.news[1] = news
        else window.news_feed.news[table.getn(window.news_feed.news) + 1] = news
        end
        if table.getn(window.news_feed.news) > 6 then table.remove(window.news_feed.news, 1) end
    end

    window.news_feed.updateDelayed = function()
        if window.news_feed.timer < 0 and table.getn(window.news_feed.news) > 0 then
            for i=1,table.getn(window.news_feed.news) do
                window.news_feed.delayed[i] = window.news_feed.news[i]
            end
            window.news_feed.timer = global_.news_update_time
        end
        window.news_feed.timer = window.news_feed.timer - 1
    end


    window.news_feed.draw = function(font)
        love.graphics.setColor(192, 192, 192)
        love.graphics.setFont(font)
        if window.news_feed.delayed[1] ~= nil then
            for i=1,table.getn(window.news_feed.delayed) do
                local news = window.news_feed.delayed[i]
                love.graphics.print(news,
                                    20 * window.scale_x,
                                    (630 + 16 * (table.getn(window.news_feed.delayed) + 1 - i)) * window.scale_y,
                                    0,
                                    window.scale_x,
                                    window.scale_y)
            end
        end
    end

    window.drawBid = function(market)
        love.graphics.setColor(255, 0, 0)
        love.graphics.print({"BID\n", string.format("%.4f", market.getBid())},
                            window.scale_x * 830,
                            window.scale_y * 150,
                            0,
                            window.scale_x * 1.2,
                            window.scale_y * 1.2)
    end

    window.drawAsk = function(market)
        love.graphics.setColor(0, 255, 0)
        love.graphics.print({"ASK\n", string.format("%.4f", market.getAsk())},
                            window.scale_x * 930,
                            window.scale_y * 150,
                            0,
                            window.scale_x * 1.2,
                            window.scale_y * 1.2)
    end

    window.drawAccountValue = function(wallet)
        love.graphics.setColor(255, 255, 128)
        love.graphics.print({"Account Value\n", string.format("%.2f USD", wallet.getAccountValue())},
        window.scale_x * 830,
        window.scale_y * 250,
        0,
        window.scale_x * 1.5,
        window.scale_y * 2)
        if wallet.getTransactionStatus()[1] then
            local difference = wallet.getTransactionValue() - wallet.getTransactionStartValue()
            local percent = difference / wallet.getTransactionStartValue() * 100
            if difference <= 0 then
                love.graphics.setColor(255, 0, 0)
            else
                love.graphics.setColor(0, 255, 0)
            end
            love.graphics.print({string.format("%.2f USD, %.2f", difference, percent), "%"},
            window.scale_x * 830,
            window.scale_y * 320,
            0,
            window.scale_x * 1,
            window.scale_y * 1)
        end
    end

    window.drawTransactionValue = function(font, wallet)
        if not wallet.getTransactionStatus()[1] then
            love.graphics.setColor(255, 255, 255)
        else
            love.graphics.setColor(0, 0, 255)
        end
        love.graphics.setFont(font)
        love.graphics.print("Transaction value",
                            window.scale_x * 850,
                            window.scale_y * 380,
                            0,
                            window.scale_x * 1,
                            window.scale_y * 1)
        love.graphics.print(string.format("%.0f", wallet.getTransactionValue()),
                            window.scale_x * 880,
                            window.scale_y * 400,
                            0,
                            window.scale_x * 1.5,
                            window.scale_y * 1.5)
        love.graphics.setColor(255, 255, 255)
    end

    window.drawGameVersion = function(font)
        love.graphics.setFont(font)
        love.graphics.print({"Version: ", global_.game_version},
                            (global_.width - 200),
                            (global_.height - 16),
                            0,
                            window.scale_x,
                            window.scale_y)
    end
    
    window.draw = function(font, time, market, wallet)
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(window.image, 0, 0, 0, window.scale_x, window.scale_y)
        love.graphics.setFont(font)
        love.graphics.print(time, window.scale_x * 850, window.scale_y * 120, 0, window.scale_x * 2, window.scale_y * 2)
        window.drawAsk(market)
        window.drawBid(market)
        window.news_feed.draw(font)
        window.drawAccountValue(wallet)
        window.drawTransactionValue(font, wallet)
        window.drawGameVersion(font)
        window.drawButtons()
    end

    window.drawSplash = function()
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(window.splash, 0, 0, 0, window.scale_x, window.scale_y)
    end

    return window
end
