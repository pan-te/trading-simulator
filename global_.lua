require "math"

global_ = {}

--scalling
global_.width = 1180
global_.height = 600
global_.default_width = 1024
global_.default_height = 768
global_.scale_x = global_.width / global_.default_width
global_.scale_y = global_.height / global_.default_height

--game speed
global_.time_scale = 1 / 12 -- higher means slower

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
global_.bid_to_ask = 1 + global_.market_start_variation / 10

--news related variables
global_.market_intensity = 3000 --impacts frequency of news. higher means intensity is lower
global_.market_min_event_time = 60
global_.market_max_event_time = 10 * 60
global_.rebound = 0.05 -- should be lower than 1
