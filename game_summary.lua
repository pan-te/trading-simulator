require "math"
require "global_"

game_summary = {}

game_summary.generate = function(recorder)
    local summary = {}
--    summary.start_money = recorder.money[1]
--    summary.end_money = recorder.money[table.getn(recorder.money)]
    
    summary.draw = function()
        local transform = love.math.newTransform()
        love.graphics.replaceTransform(transform)
        love.graphics.applyTransform(transform)
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle("fill", 0, 0, global_.width, global_.height)
    end
    return summary
end