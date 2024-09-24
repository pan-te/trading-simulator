game_recorder = {}

game_recorder.createRecorder()
    local recorder = {}
    recorder.transaction_start = {}
    recorder.transaction_end = {}
    recorder.event = {}
    recorder.market_value = {}
    recorder.account_value = {}

    recorder.recordTransactionStart = function(time, transaction)
        if recorder.transaction_start[1] == nil then recorder.transaction_start[1] = {time, transaction}
        else recorder.transaction_start[table.getn(recorder.transaction_start) + 1] = {time, transaction}
        end
    end

    recorder.recordTransactionEnd = function(time, transaction)
        if recorder.transaction_end[1] == nil then recorder.transaction_end[1] = {time, transaction}
        else recorder.transaction_end[table.getn(recorder.transaction_end) + 1] = {time, transaction}
        end
    end

    recorder.recordEvent = function(event)
        if recorder.event[1] == nil then recorder.event[1] = event
        else recorder.event[table.getn(recorder.event) + 1] = event
        end
    end

    recorder.recordMarketValue = function(time, value)
        if recorder.market_value[1] == nil then recorder.market_value[1] = {time, value}
        else recorder.market_value[table.getn(recorder.market_value) + 1] = {time, value}
        end
    end
end
