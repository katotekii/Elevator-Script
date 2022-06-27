Config = {}

Config.DrawMarker = true -- if you dont want marker put here false
Config.EnableFadeOut = false

Config.Elevators = {

    -- this is just example 

    [1] = {
        name = 'Ambulance', -- name that will be displayed in textUI
        coords = { -- in whitch order you put in table coords, same order will be in menu, example:
            vec3(296.04, -1447.08, 29.96),  -- 1st floor
            vec3(334.68, -1432.24, 46.52),  -- 2nd floor
            vec3(367.8, -1393.6, 76.16)     -- 3rd floor etcc
        },
        jobs = {'ambulance', 'police'} -- if you dont want check for jobs then put false
    },

    [2] = {
        name = 'Maze Bank',
        coords = {
            vec3(-69.96, -799.96, 44.24),   -- 1st floor  
            vec3(-75.72, -815.12, 326.16)   -- 2nd floor   
        },
        jobs = false
    },
    --[[
        example
        [next number (3)] = {
            name = name,
            coords = {coords},
            jobs = false or table
        }
    ]]
}