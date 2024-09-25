game_time = {}

game_time.hours = 0
game_time.minutes = 0
game_time.seconds = 0
game_time.absolute = 0

game_time.convertToString = function(value)
    local result = 0
    if value < 10 then
        result = "0" .. tostring(value)
    else
        result  = tostring(value)
    end
    return result
end

game_time.getTime = function()
    local time_ = {}
    local seconds = game_time.convertToString(game_time.seconds)
    local minutes = game_time.convertToString(game_time.minutes)
    local hours = game_time.convertToString(game_time.hours)
    time_ = hours .. ":" .. minutes .. ":" .. seconds
    return time_
end

game_time.getAbsoluteTime = function()
    return game_time.absolute
end

game_time.update = function()
    game_time.absolute = game_time.absolute + 1
    game_time.seconds = game_time.seconds + 1
    if game_time.seconds >= 60 then
        game_time.seconds = 0
        game_time.minutes = game_time.minutes + 1
    end
    if game_time.minutes >= 60 then
        game_time.minutes = 0
        game_time.hours = game_time.hours + 1
    end
end