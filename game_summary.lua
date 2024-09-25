require "math"
require "global_"

game_summary = {}

game_summary.generate = function(wallet)
    local summary = {}
    summary.message = ""
    summary.payout = {string.format("You started with %.2f USD and ended with %.2f USD.\n",
    global_.start_money, wallet.getAccountValue()),
    "that makes ",
    string.format("%.2f", (wallet.getAccountValue() - global_.start_money) / global_.start_money) * 100,
    "% difference"}
    if wallet.getAccountValue() > 2 * global_.start_money then
        summary.message = "Congratulations Mr Livermore!\n You've doubled your money."
    elseif wallet.getAccountValue() > 1.5 * global_.start_money then
        summary.message = "Well done! It was a good day."
    elseif wallet.getAccountValue() > global_.start_money then
        summary.message = "Not bad. You ended this\n session with profit."
    elseif wallet.getAccountValue() > global_.start_money * 0.75 then
        summary.message = "It wasn't your best session.\n Try tomorrow."
    elseif wallet.getAccountValue() > global_.start_money / 3 then
        summary.message = "That was a tough day."
    elseif wallet.getAccountValue() <= 0 then
        summary.message = "You're broke.\n Better leave your home for a few days."
    else
        summary.message = "You should stop playing for a while."
    end
--    local summary = {}
--    summary.start_money = recorder.money[1]
--    summary.end_money = recorder.money[table.getn(recorder.money)]
    summary.draw = function(font)
        local width, height = love.graphics.getDimensions()
        local scale_x = width / global_.default_width
        local scale_y = height / global_.default_height
        local canvas = love.graphics.newCanvas(global_.default_width, global_.default_height)
        love.graphics.setCanvas(canvas)
        love.graphics.setColor(0, 0, 0, 0.75)
        love.graphics.rectangle("fill", 0, 0, global_.default_width, global_.default_height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", global_.default_width / 4,
                                global_.default_height / 8,
                                global_.default_width / 2,
                                global_.default_height / 2)
        love.graphics.setFont(font)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("THIS TRADING SESSION IS OVER.",
                            global_.default_width / 3.3,
                            global_.default_height / 8,
                            0,
                            1.8,
                            2)
        love.graphics.print(summary.message,
                            global_.default_width / 3,
                            global_.default_height / 6,
                            0,
                            1.5,
                            1.5)
        love.graphics.print(summary.payout,
                            global_.default_width / 3.5,
                            global_.default_height / 4,
                            0,
                            1,
                            1)
        love.graphics.setCanvas()
        love.graphics.setColor(1, 1, 1, 0.75)
        love.graphics.draw(canvas, 0, 0, 0, scale_x, scale_y)                 
    end
    return summary
end