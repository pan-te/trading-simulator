require "math"

global_ = {}

global_.game_version = "0.9a"
--scalling
global_.default_width = 1024
global_.default_height = 768

--game speed
global_.time_scale = 1/12 -- higher means slower

--candle variables
global_.interval = 60 -- samples inside one candle
global_.candle_num = 120 -- number of rendered candles

--starting market parameters
global_.market_start_value = 20.5
global_.market_start_variation = 0.001
global_.market_value_to_variation = global_.market_start_value / global_.market_start_variation
global_.market_start_trend = 0
global_.market_max_size = global_.interval * global_.candle_num
global_.market_sample_interval = math.floor(global_.interval / global_.time_scale)
global_.bid_to_ask = 1 + global_.market_start_variation / 4

--news related variables
global_.market_intensity = 5000 --impacts frequency of news. higher means intensity is lower
global_.market_min_event_time = 60
global_.market_max_event_time = 10 * 60
global_.rebound = 0.05 -- should be lower than 1
global_.news_update_time = 120

--start money
global_.start_money = 10000
global_.leverage = 50

--game recorder
global_.game_recorder_update_interval = 60