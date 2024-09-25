require "math"
require "global_"

game_summary = {}

game_summary.generate = function(wallet)
    local summary = {}
    summary.message = ""
    if wallet.getAccountValue() > 2 * global_.start_money then
        summary.message = "Congratulations Mr Livermore!\n You've doubled your money."
    elseif wallet.getAccountValue() > 1.5 * global_.start_money then
        summary.message = "Well done! It was a good day."
    elseif wallet.getAccountValue() > global_.start_money then
        summary.message = "Not bad. You ended this\n session with profit."
    elseif wallet.getAccountValue() > global_.start_money * 0.75 then
        summary.message = "It wasn't your best session.\n Maybe next time."
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
        local transform = love.math.newTransform()
        local width, height = love.graphics.getDimensions()
        love.graphics.replaceTransform(transform)
        love.graphics.applyTransform(transform)
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, width, height)
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", width / 4, height / 4,
                                        width / 2, height / 2)
        love.graphics.setFont(font)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print("THIS TRADING SESSION IS OVER.",
                            width / 3.3, height / 4,
                            0,
                            1.8 * width / global_.default_width,
                            2 * height / global_.default_height)
        love.graphics.print(summary.message,
                            width / 3, height / 3,
                            0,
                            1.5 * width / global_.default_width,
                            1.5 * height / global_.default_height)                 
    end
    return summary
end