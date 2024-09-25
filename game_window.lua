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
    window.buttons = {}
    
    window.addButton = function(task, texture_path, x0, y0)
        local button = {}
        button.name = texture_path
        button.image = love.graphics.newImage("texture/" .. texture_path .. ".png")
        button.image_clicked = love.graphics.newImage("texture/" .. texture_path .. "_clicked.png")
        button.x = x0
        button.y = y0
        button.w, button.h = button.image:getDimensions()
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
        love.graphics.setColor(1, 1, 1)
        for i=1,table.getn(window.buttons) do
            local image = {}
            if window.buttons[i].is_clicked then
                image = window.buttons[i].image_clicked
            else
                image = window.buttons[i].image
            end
            love.graphics.draw(image, window.buttons[i].x, window.buttons[i].y, 0, 1, 1)
        end
    end
    
    window.checkButtons = function(x0, y0, arg1, arg2, arg3, arg4, arg5)
        local w, h = love.graphics.getDimensions()
        local x = x0 / w * global_.default_width
        local y = y0 / h * global_.default_height
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
        love.graphics.setColor(0.8, 0.8, 0.8)
        love.graphics.setFont(font)
        if window.news_feed.delayed[1] ~= nil then
            for i=1,table.getn(window.news_feed.delayed) do
                local news = window.news_feed.delayed[i]
                love.graphics.print(news,
                                    20,
                                    (630 + 16 * (table.getn(window.news_feed.delayed) + 1 - i)),
                                    0,
                                    1,
                                    1)
            end
        end
    end

    window.drawBid = function(market)
        love.graphics.setColor(1, 0, 0)
        love.graphics.print({"BID\n", string.format("%.4f", market.getBid())},
                            830,
                            150,
                            0,
                            1.2,
                            1.2)
    end

    window.drawAsk = function(market)
        love.graphics.setColor(0, 1, 0)
        love.graphics.print({"ASK\n", string.format("%.4f", market.getAsk())},
                            930,
                            150,
                            0,
                            1.2,
                            1.2)
    end

    window.drawAccountValue = function(wallet)
        love.graphics.setColor(1, 1, 0.5)
        love.graphics.print({"Account Value\n", string.format("%.2f USD", wallet.getAccountValue())},
        830,
        250,
        0,
        1.5,
        2)
        if wallet.getTransactionStatus()[1] then
            local difference = wallet.getTransactionValue() - wallet.getTransactionStartValue()
            local percent = difference / wallet.getTransactionStartValue() * 100
            if wallet.getTransactionStartValue() <= 0 then
                percent = 0
            end
            if difference <= 0 then
                love.graphics.setColor(1, 0, 0)
            else
                love.graphics.setColor(0, 1, 0)
            end
            love.graphics.print({string.format("%.2f USD, %.2f", difference, percent), "%"},
            830,
            320,
            0,
            1,
            1)
        end
    end

    window.drawTransactionValue = function(font, wallet)
        if not wallet.getTransactionStatus()[1] then
            love.graphics.setColor(1, 1, 1)
        else
            love.graphics.setColor(0, 0, 1)
        end
        love.graphics.setFont(font)
        love.graphics.print("Transaction value",
                            850,
                            380,
                            0,
                            1,
                            1)
        love.graphics.print(string.format("%.0f", wallet.getTransactionValue()),
                            880,
                            400,
                            0,
                            1.5,
                            1.5)
        love.graphics.setColor(1, 1, 1)
    end

    window.drawGameVersion = function(font)
        love.graphics.setFont(font)
        love.graphics.print({"Version: ", global_.game_version},
                            (global_.default_width - 200),
                            (global_.default_height - 16),
                            0,
                            1,
                            1)
    end
    
    window.draw = function(font, time, market, wallet)
        local canvas = love.graphics.newCanvas(global_.default_width, global_.default_height)
        love.graphics.setCanvas(canvas)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(window.image, 0, 0, 0, 1, 1)
        love.graphics.setFont(font)
        love.graphics.print(time, 850, 120, 0, 2, 2)
        window.drawAsk(market)
        window.drawBid(market)
        window.news_feed.draw(font)
        window.drawAccountValue(wallet)
        window.drawTransactionValue(font, wallet)
        window.drawGameVersion(font)
        window.drawButtons()
        love.graphics.setCanvas()
        local w, h = love.graphics.getDimensions()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(canvas,
                            0,
                            0,
                            0,
                            w / global_.default_width,
                            h / global_.default_height)
    end

    window.drawSplash = function()
        local w, h = love.graphics.getDimensions()
        local canvas = love.graphics.newCanvas(global_.default_width, global_.default_height)
        love.graphics.setCanvas(canvas)
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(window.splash, 0, 0, 0, 1, 1)
        love.graphics.setCanvas()
        love.graphics.draw(canvas,
                            0,
                            0,
                            0,
                            w / global_.default_width,
                            h / global_.default_height)
    end

    return window
end
