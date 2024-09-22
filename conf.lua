require "global_"

function love.conf(t)
    t.window.width = global_.width
    t.window.height = global_.height
end