RegisterNetEvent(GetCurrentResourceName() .. ':client:openNUI')
AddEventHandler(GetCurrentResourceName() .. ':client:openNUI', function(data)
    if not data or #data < 1 then return end

    SendNUIMessage({
        action = "showLawbooks",
        data = data,
        heading = Config.Header,
        bookNameTemplate = Config.LawBookName,
        tableHeads = Config.TableHeads
    })
    SetNuiFocus(true, true)
end)


RegisterNUICallback('closeNUI', function(data, cb)
    SetNuiFocus(false, false)
    cb({ success = true })
end)

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 100)
end

function createBlip(data, coords)
    local myBlip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(myBlip, data.sprite)
    SetBlipDisplay(myBlip, 4)
    SetBlipScale(myBlip, data.scale)
    SetBlipColour(myBlip, data.color)
    SetBlipAsShortRange(myBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(data.name)
    EndTextCommandSetBlipName(myBlip)
    SetBlipAsMissionCreatorBlip(myBlip, true)
end

Citizen.CreateThread(function()
    local peds = {}

    for _, data in ipairs(Config.Locations) do
        local model = GetHashKey(data.pedModel)
        RequestModel(model)
        while not HasModelLoaded(model) do
            Citizen.Wait(0)
        end

        local ped = CreatePed(4, model, data.coords.x, data.coords.y, data.coords.z - 1.0, data.coords.h, false, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        TaskSetBlockingOfNonTemporaryEvents(ped, true)
        SetPedFleeAttributes(ped, 0, 0)

        if data.blip.enabled then
            createBlip(data.blip, data.coords)
        end

        table.insert(peds, ped)
    end

    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, ped in ipairs(peds) do
            local pedCoords = GetEntityCoords(ped)
            local distance = #(playerCoords - pedCoords)

            if distance <= 3.0 then
                DrawText3D(pedCoords.x, pedCoords.y, pedCoords.z + 1.0, "E - Gesetzbuch öffnen")

                if IsControlJustPressed(0, 38) then
                    TriggerServerEvent(GetCurrentResourceName() .. ':server:getLawbooks')
                    Citizen.Wait(1000)
                end
            end
        end
    end
end)
