local ESX = exports['es_extended']:getSharedObject()

local function enterElevator(zone)
    local options = {}
    for i = 1, #zone do
        for k,v in pairs(zone[i]) do
            options[k] = {value = k, label = ('Floor %s'):format(k)}
        end
    end

    local input = lib.inputDialog('Elevator Menu', {
        { type = 'select', label = 'Select Floor', options = options}
    })

    if not input then return end


    for i = 1, #zone do
        if input[1] then
            if Config.EnableFadeOut then
                DoScreenFadeOut(800)
                while not IsScreenFadedOut() do Wait(0) end
                DoScreenFadeIn(800)
                SetEntityCoords(PlayerPedId(), zone[i][tonumber(input[1])], false, false, false, true)
            else
                SetEntityCoords(PlayerPedId(), zone[i][tonumber(input[1])], false, false, false, true)
            end
        end
    end
end


local elevators, currentZone = {}, {}

do
    for k,v in pairs(Config.Elevators) do
        for i = 1, #v.coords, 1 do
            elevators[i] = lib.points.new({
                coords = v.coords[i],
                distance = 2,
                eleId = k,
                onEnter = function(self)
                    if Config.Elevators[self.eleId] then
                        currentZone[#currentZone + 1] = Config.Elevators[self.eleId].coords
                    end
                end,
                onExit = function()
                    lib.hideTextUI()
                    table.wipe(currentZone)
                end,
                nearby = function(self)
                    if Config.Elevators[self.eleId] and self.currentDistance < 2 and not IsEntityDead(cache.ped) then
                        if type(Config.Elevators[self.eleId].jobs) == 'table' then 
                            for nothing,jobName in pairs(Config.Elevators[self.eleId].jobs) do
                                if core.PlayerData.job.name == jobName then

                                    if Config.DrawMarker then
                                        DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, nil, nil, false)
                                    end

                                    lib.showTextUI(('[E] - Enter %s'):format(v.name))
                                    if IsControlJustReleased(0,38) then
                                        lib.hideTextUI()
                                        enterElevator(currentZone)
                                    end
                                end
                            end
                        elseif type(Config.Elevators[self.eleId].jobs) == 'boolean' then

                            if Config.DrawMarker then
                                DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 200, 20, 20, 50, false, true, 2, nil, nil, false)
                            end

                            lib.showTextUI(('[E] - Enter %s'):format(v.name))
                            if IsControlJustReleased(0,38) then
                                lib.hideTextUI()
                                enterElevator(currentZone)
                            end
                        end
                    end
                end
            })
        end
    end
end
