zone = {}

zone.DrawMarker = true
zone.elevators = {
	-- this is just example
	[1] = {
		name = 'Ambulance', -- name that will be displayed in textUI
		coords = { -- in whitch order you put in table coords, same order will be in menu, example:
			vec3(296.04, - 1447.08, 29.96), -- 1st floor
			vec3(334.68, - 1432.24, 46.52), -- 2nd floor
			vec3(367.8, - 1393.6, 76.16) -- 3rd floor etcc
		},
	},

	[2] = {
		name = 'Maze Bank',
		coords = {
			vec3(-69.96, - 799.96, 44.24), -- 1st floor
			vec3(-75.72, - 815.12, 326.16) -- 2nd floor
		},
	},
}

local function enterElevator(zone)
	local options = {}
	for i = 1, #zone do
		for k, v in pairs(zone[i]) do
			options[k] = {value = k, label = ('Floor %s'):format(k)}
		end
	end

	local input = lib.inputDialog('Elevator Menu', {
		{ type = 'select', label = 'Select Floor', options = options}
	})

	if not input then return end

	for i = 1, #zone do
		if input[1] then
			SetEntityCoords(cache.ped, zone[i][tonumber(input[1])], false, false, false, true)
		end
	end
end

local elevators, currentZone = {}, {}

do
	for k, v in pairs(zone.elevators) do
		for i = 1, #v.coords, 1 do
			elevators[i] = lib.points.new({
				coords = v.coords[i],
				distance = 2,
				location = k,

				onEnter = function(self)
					if zone.elevators[self.location] then
						currentZone[#currentZone + 1] = zone.elevators[self.location].coords
					end
				end,

				onExit = function()
					lib.hideTextUI()
					table.wipe(currentZone)
				end,

				nearby = function(self)
					if zone.elevators[self.location] and self.currentDistance < 2 and not IsEntityDead(cache.ped) then

						if zone.DrawMarker then
							DrawMarker(2, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.25, 0.25, 0.25, 0, 150, 255, 155, false, true, 2, nil, nil, false)
						end
					end

					lib.showTextUI(('[E] - Enter %s'):format(v.name))
					if IsControlJustReleased(0, 38) then
						lib.hideTextUI()
						enterElevator(currentZone)
					end
				end
			})
		end
	end
end
