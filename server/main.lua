local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('oakyIdentity:server:getIdentity')
AddEventHandler('oakyIdentity:server:getIdentity', function(target, type)
    local src = source
    target = tonumber(target)
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(target)
    
    if type == 'ident' then
        MySQL.Async.fetchAll('SELECT firstname, lastname, dateofbirth, sex FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier()
        }, function(result)
            local userData = {
                firstname = result[1].firstname,
                lastname = result[1].lastname,
                cid = 'XXXXXXXX',
                birthday = result[1].dateofbirth,
                sex = result[1].sex,
            }
            TriggerClientEvent('oakyIdentity:client:sendIdentity', xTarget.source, userData)
        end)
    elseif type == 'weapon' then
        MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @owner AND type = "weapon"', {
            ['@owner'] = xPlayer.getIdentifier()
        }, function(result)
            if result[1] ~= nil then
                local user = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.getIdentifier()
                })
                local data = {
                    firstname = user[1].firstname,
                    lastname = user[1].lastname,
                    sex = user[1].sex,
                    time = '01.01.'..os.date('%Y')
                }
                TriggerClientEvent('oakyIdentity:client:sendWeapon', xTarget.source, data)
            else
                xPlayer.showNotification('You do not have a weapon license.')
            end
        end)
    
    elseif type == 'license' then
        MySQL.Async.fetchAll('SELECT type FROM user_licenses WHERE owner = @owner ORDER BY time DESC', {
            ['@owner'] = xPlayer.getIdentifier()
        }, function(result)
            if result[1] ~= nil then
                local user = MySQL.Sync.fetchAll('SELECT firstname, lastname, sex FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.getIdentifier()
                })
                local data = {
                    firstname = user[1].firstname,
                    lastname = user[1].lastname,
                    sex = user[1].sex,
                }
                local licenses = {}
                for i = 1, #result do
                    if result[i].type ~= 'weapon' then
                        table.insert(licenses, {
                            type = result[i].type,
                            time = '01.01.'..os.date('%Y')
                        })
                    end
                end
                TriggerClientEvent('oakyIdentity:client:sendLicense', xTarget.source, data, licenses)
            else
                xPlayer.showNotification('You do not have a driver license.')
            end
        end)
    end
end)
