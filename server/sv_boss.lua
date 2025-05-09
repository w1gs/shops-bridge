Config = {}
-- Create a view in the DB to map management_funds calls to the correct table
if GetResourceState('Renewed-Banking') == 'started' then
    Config.banking = 'Renewed-Banking'
    exports['oxmysql']:query_async(
        "CREATE OR REPLACE VIEW management_funds AS SELECT id as job_name, 'boss' as type, amount as amount FROM bank_accounts_new;")
elseif GetResourceState('crm-banking') == 'started' then
    Config.Banking = 'crm-banking'
    exports['oxmysql']:query_async(
        "CREATE OR REPLACE VIEW management_funds AS SELECT crm_owner as job_name, 'boss' as type, crm_balance as amount FROM crm_bank_accounts;")
end

-- Returns a table of society accounts and their balances
function GetAccounts()
    local accounts = {}
    local response
    if Config.banking == "Renewed-Banking" then
        response = exports["oxmysql"]:query_async("SELECT `id`, `amount` FROM `bank_accounts_new`")
    elseif Config.banking == "crm-banking" then
        response = exports["oxmysql"]:query_async(
            "SELECT `crm_owner`, `crm_balance` FROM `crm_bank_accounts` WHERE `crm_type` = 'crm-society'")
    end
    if response and response ~= nil then
        for i in pairs(response) do
            local society = tostring(response[i].id)
            local balance = tonumber(response[i].amount)
            if society and balance then
                accounts[society] = balance
            end
        end
    end
    return accounts
end

function AddMoney(society, amount)
    if Config.banking == 'Renewed-Banking' then
        exports['Renewed-Banking']:addAccountMoney(society, amount)
    elseif Config.banking == 'crm-banking' then
        exports["crm-banking"]:crm_add_money(society, amount)
    end
end

function RemoveMoney(society, amount)
    if Config.banking == 'Renewed-Banking' then
        exports['Renewed-Banking']:removeAccountMoney(society, amount)
    elseif Config.banking == 'crm-banking' then
        exports["crm-banking"]:crm_remove_money(society, amount)
    end
end

exports("getAccounts", GetAccounts)
exports("addMoney", AddMoney)
exports("removeMoney", RemoveMoney)
