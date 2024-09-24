require "math"

game_news = {}

game_news.timer = 0

game_news.rebound_impact = 0

game_news.message = { "Barren Wuffet initiated a speculative attack on Zemandian currency!",
                      "King of Zemandia was assassinated!",
                      "President of USA decided to invade Zemandia!",
                      "Lezenia's GDP grow was higher than expected.",
                      "Zemandia's wheat production is 20% lower than last year.",
                      "World Bank gave loan to Lezenia.",
                      "World Bank gave loans to Zemandia and Lezenia.",
                      "World Bank gave loan to Zemandia.",
                      "Lezenia's tobacco production is 30% lower than expected.",
                      "Zemandia's authority announced strict monetary policy.",
                      "China has territorial claims against Lezenia!",
                      "President of Lezenia has died in a plane crash!",
                      "Sergey Goross initiated a speculative attack on Lezenian currency!" }

game_news.message_shift = math.floor(table.getn(game_news.message) / 2) + 1

game_news.trend_multiplier = -global_.market_start_variation / (game_news.message_shift - 1) / math.random(1,3)

game_news.rerandomize = function()
    game_news.trend_multiplier = -global_.market_start_variation / (game_news.message_shift - 1) / math.random(1,3)
end

game_news.newsHandling = function(market, dt, time)
    local news = ""
    if game_news.timer <= 0 then
        market.changeTrend(game_news.rebound_impact)
        local news_chance = math.random(1, global_.market_intensity)
        local news_impact = math.random(-game_news.message_shift + 1, game_news.message_shift - 1)
        if news_chance > global_.market_intensity - 1 then
            if news_impact ~= 0 then
                market.changeTrend(-game_news.trend_multiplier * news_impact)
            end
            game_news.timer = math.random(global_.market_min_event_time, global_.market_max_event_time)
            news = time .. " " .. game_news.message[news_impact + game_news.message_shift]
            game_news.rebound_impact = - market.getTrend() * math.random(0, global_.rebound * 100) / 100
        end
        game_news.rerandomize()
    end
    if game_news.timer > 0 then game_news.timer = game_news.timer - 1 end
    return news
end
