require "global_"
require "math"

game_recorder = {}

game_recorder.createRecorder = function()
    local recorder = {}
    recorder.parameters = {}
    recorder.size = 0
    recorder.update_timer = 0
    
    recorder.update = function(params)
        recorder.update_timer = recorder.update_timer - 1
        if recorder.update_timer < 0 then
            recorder.parameters[recorder.size + 1] = params
            recorder.size = recorder.size + 1
            recorder.update_timer = global_.game_recorder_update_interval
        end
    end

    recorder.max = function(index)
        local max = recorder.parameters[1][index]
        for i=2,recorder.size do
            if max < recorder.parameters[i][index] then
                max = recorder.parameters[i][index]
            end
        end
        return max
    end

    recorder.min = function(index)
        local min = recorder.parameters[1][index]
        for i=2,recorder.size do
            if min > recorder.parameters[i][index] then
                min = recorder.parameters[i][index]
            end
        end
        return min
    end


    recorder.draw = function(font)
        if recorder.size > 2 then
            local w_canvas = global_.default_width / 2
            local h_canvas = global_.default_height / 2
            local canvas = love.graphics.newCanvas(w_canvas, h_canvas)
            local w, h = love.graphics.getDimensions()
            local scale_x = w / global_.default_width
            local scale_y = h / global_.default_height
            local canvas_origin_x = global_.default_width / 4
            local canvas_origin_y = global_.default_height / 4
            local chart_time_interval = w_canvas / recorder.size
            love.graphics.setColor(1, 1, 1)
            love.graphics.setCanvas(canvas)
            love.graphics.clear(0, 0, 0.1)
            local max1 = recorder.max(1)
            local max2 = recorder.max(2)
            local min1 = recorder.min(1)
            local min2 = recorder.min(2)
            local scale1 = h_canvas / (max1 - min1)
            local scale2 = h_canvas / (max2 - min2)
            for i=1,recorder.size-1 do
                love.graphics.setColor(0, 1, 0)
                love.graphics.line((i-1) * chart_time_interval,
                                (max1 - recorder.parameters[i][1]) * scale1,
                                i * chart_time_interval,
                                (max1 - recorder.parameters[i+1][1]) * scale1)
                love.graphics.setColor(0, 0, 1)
                love.graphics.line((i-1) * chart_time_interval,
                                (max2 - recorder.parameters[i][2]) * scale2,
                                i * chart_time_interval,
                                (max2 - recorder.parameters[i+1][2]) * scale2)
            end
            love.graphics.setFont(font)
            love.graphics.setColor(0, 0.5, 0)
            love.graphics.print("Index value", 0, h_canvas - 16, 0)
            love.graphics.setColor(0.2, 0.2, 0.8)
            love.graphics.print("Account value", w_canvas - 104, h_canvas - 16, 0)
            love.graphics.setCanvas()
            love.graphics.setColor(1, 1, 1)
            love.graphics.draw(canvas,
                            canvas_origin_x,
                            canvas_origin_y,
                            0,
                            scale_x,
                            scale_y)
        end
    end

    return recorder
end
