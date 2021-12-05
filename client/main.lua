local PlayerData = {}
ESX = nil
local isIdentOpen = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
    end
end)

RegisterNetEvent('oakyIdentity:client:sendIdentity')
AddEventHandler('oakyIdentity:client:sendIdentity', function(userData)
    isIdentOpen = true
    SendNUIMessage({
        action = 'sendIdentity',
        userData = userData,
    })
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if IsControlJustPressed(0, 177) and isIdentOpen then
            SendNUIMessage({
                action = 'close'
            })
            isIdentOpen = false
        end
    end
end)

RegisterNetEvent('oakyIdentity:client:sendWeapon')
AddEventHandler('oakyIdentity:client:sendWeapon', function(data)
    isIdentOpen = true
    SendNUIMessage({
        action = 'sendWeapon',
        data = data
    })
end)

RegisterNetEvent('oakyIdentity:client:sendLicense')
AddEventHandler('oakyIdentity:client:sendLicense', function(data, licenses)
    isIdentOpen = true
    SendNUIMessage({
        action = 'sendLicense',
        data = data,
        licenses = licenses
    })
end)