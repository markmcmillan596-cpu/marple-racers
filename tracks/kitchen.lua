-- Dressed course. The placeholder in tracks/breakfast.lua retains its own art
-- and remains selectable. Both layouts share the verified grid and race lines.
local placeholder = require("tracks.breakfast")

return setmetatable({
    theme = "kitchen",
    decorations = {
        { kind = "napkin", x = 380, y = 405 },
        { kind = "saucer", x = 537, y = 404 },
        { kind = "orange", x = 753, y = 385, radius = 25 },
        { kind = "juice", x = 1009, y = 155, radius = 33 },
        { kind = "fork", x = 1038, y = 369 },
        { kind = "spoon", x = 60, y = 382 },
    },
    -- Only these objects participate in physics. Their painted rims match
    -- their collision circles. Decorative shadows extend beyond the rims.
    obstacles = {
        { shape = "circle", kind = "blueberry", x = 697, y = 225, radius = 22 },
        { shape = "circle", kind = "sugar", x = 950, y = 439, radius = 29 },
        { shape = "circle", kind = "blueberry", x = 333, y = 582, radius = 23 },
        { shape = "circle", kind = "sugar", x = 150, y = 361, radius = 27 },
    },
}, { __index = placeholder })
