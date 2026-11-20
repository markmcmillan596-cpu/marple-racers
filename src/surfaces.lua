local defaults = require("data.physics.surfaces")

local Surfaces = {}

function Surfaces.at(track, x, y)
    local profiles = track.surfaceProfiles or defaults
    local regions = track.surfaceRegions
    if regions then
        -- The last listed layer wins, just as it does in the artwork.
        for index = #regions, 1, -1 do
            local region = regions[index]
            if x >= region.x and x < region.x + region.w and y >= region.y and y < region.y + region.h then
                return profiles[region.material], region.material
            end
        end
    end
    return profiles.wood, "wood"
end

return Surfaces
