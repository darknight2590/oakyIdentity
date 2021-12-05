local ESX = nil

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

RegisterServerEvent('quantum_identity:server:getIdentity')
AddEventHandler('quantum_identity:server:getIdentity', function(target, type)
    local src = source
    target = tonumber(target)
    local xPlayer = ESX.GetPlayerFromId(src)
    local xTarget = ESX.GetPlayerFromId(target)
    
    if type == 'ident' then
        MySQL.Async.fetchAll('SELECT firstname, lastname, cid, dateofbirth, sex FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.getIdentifier()
        }, function(result)
            local userData = {
                firstname = result[1].firstname,
                lastname = result[1].lastname,
                cid = result[1].cid,
                birthday = result[1].dateofbirth,
                sex = result[1].sex,
            }
            TriggerClientEvent('quantum_identity:client:sendIdentity', xTarget.source, userData)
        end)
    elseif type == 'weapon' then
        MySQL.Async.fetchAll('SELECT type, time FROM user_licenses WHERE owner = @owner AND type = "weapon"', {
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
                    time = result[1].time
                }
                TriggerClientEvent('quantum_identity:client:sendWeapon', xTarget.source, data)
            else
                TriggerClientEvent('quantum_notify:client:sendNotification', xTarget.source, 'Identity', 'Du bist nicht im Besitz einer Waffenlizenz.', 'script')
            end
        end)
    
    elseif type == 'license' then
        MySQL.Async.fetchAll('SELECT type, time FROM user_licenses WHERE owner = @owner ORDER BY time DESC', {
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
                            time = result[i].time
                        })
                    end
                end
                TriggerClientEvent('quantum_identity:client:sendLicense', xTarget.source, data, licenses)
            else
                TriggerClientEvent('quantum_notify:client:sendNotification', xTarget.source, 'Identity', 'Du bist nicht im Besitz eines Führerscheins.', 'script')
            end
        end)
    else
        TriggerClientEvent('quantum_notify:client:sendNotification', xTarget.source, 'Identity', 'Du hast einen unbekannten Lizenztyp angegeben, dieser existiert nicht', 'script')
    end
end)
