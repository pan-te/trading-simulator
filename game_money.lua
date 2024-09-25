require "math"
game_money = {}

game_money.createWallet = function(cash, market, leverage)
    local wallet = {}
    wallet.ammount = cash
    wallet.transaction_value = cash
    wallet.transaction_start_value = cash
    wallet.transaction_start_price = market.getBid()
    wallet.intrade = false
    wallet.buy = false
    if leverage == nil then wallet.leverage = 1 else wallet.leverage = leverage end

    wallet.transactionMultiplier = function(buy)
        local result = 0
        if not buy then
            result = 1 + ((wallet.transaction_start_price - market.getAsk()) / market.getAsk() * wallet.leverage)
        else
            result = 1 + ((market.getBid() - wallet.transaction_start_price) / wallet.transaction_start_price * wallet.leverage)
        end
        return result
    end

    wallet.update = function()
        if wallet.intrade then
            wallet.transaction_value = wallet.transaction_start_value * wallet.transactionMultiplier(wallet.buy)
        elseif wallet.transaction_value > wallet.ammount then
            wallet.transaction_value = wallet.ammount
        elseif wallet.transaction_value < 0 then
            wallet.transaction_value = 0
        end
    end

    wallet.getAmmount = function()
        return wallet.ammount
    end

    wallet.getTransactionValue = function()
        return wallet.transaction_value
    end

    wallet.getAccountValue = function()
        if wallet.intrade then
            return wallet.ammount + wallet.transaction_value
        else
            return wallet.ammount
        end
    end

    wallet.getTransactionStatus = function()
        return {wallet.intrade, wallet.buy}
    end

    wallet.getTransactionStartValue = function()
        return wallet.transaction_start_value
    end

    wallet.transactionInit = function(buy)
        wallet.transaction_start_value = wallet.transaction_value
        if not buy then
            wallet.transaction_start_price = market.getBid()
        else
            wallet.transaction_start_price = market.getAsk()
        end
        wallet.ammount = wallet.ammount - wallet.transaction_start_value
        wallet.intrade = true
    end

    wallet.sell = function()
        if not wallet.intrade then
            wallet.transactionInit(false)
            wallet.buy = false
        else
            wallet.intrade = false
            wallet.ammount = wallet.ammount + wallet.transaction_value
        end
        wallet.update()
    end

    wallet.buy = function()
        if not wallet.intrade then
            wallet.transactionInit(true)
            wallet.buy = true
        else
            wallet.intrade = false
            wallet.ammount = wallet.ammount + wallet.transaction_value
        end
        wallet.update()
    end

    wallet.incTransactionValue = function()
        if not wallet.intrade then
            local value = math.floor(wallet.ammount / 100)
            wallet.transaction_value = wallet.transaction_value + value
            if wallet.transaction_value > wallet.ammount then wallet.transaction_value = wallet.ammount end
        end
    end

    wallet.decTransactionValue = function()
        if not wallet.intrade then
            local value = math.floor(wallet.ammount / 100)
            wallet.transaction_value = wallet.transaction_value - value
            if wallet.transaction_value < 0 then wallet.transaction_value = 0 end
        end
    end

    return wallet
end

