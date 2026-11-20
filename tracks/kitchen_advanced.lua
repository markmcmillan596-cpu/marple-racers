local kitchen = require("tracks.kitchen")

local obstacles = {}
for index, prop in ipairs(kitchen.obstacles) do
    obstacles[index] = prop
end

-- The mug separates the shortcut from the regular bend. Cereals leave a
-- passable center line through the napkin. The ruler forms an optional bank.
local additions = {
    { shape = "circle", kind = "mug", x = 831, y = 492, radius = 28, bounce = 0.52 },
    { shape = "circle", kind = "cereal", x = 832, y = 456, radius = 6, bounce = 0.28 },
    { shape = "circle", kind = "cereal", x = 744, y = 480, radius = 6, bounce = 0.28 },
    { shape = "circle", kind = "cereal", x = 783, y = 516, radius = 7, bounce = 0.28 },
    { shape = "capsule", kind = "ruler", ax = 974, ay = 501, bx = 928, by = 567, radius = 8, bounce = 0.78 },
}
for _, prop in ipairs(additions) do
    obstacles[#obstacles + 1] = prop
end

return setmetatable({
    obstacles = obstacles,
    surfaceRegions = {
        { x = 518, y = 184, w = 105, h = 94, material = "placemat" },
        { x = 725, y = 424, w = 113, h = 101, material = "napkin" },
    },
    -- Clockwise convex island. The diagonal from (823,384) to (699,502)
    -- opens the inside line between the right and far checkpoints.
    infield = {
        277, 389, 283, 358, 299, 332, 325, 314, 359, 307,
        741, 307, 770, 313, 798, 330, 815, 355, 823, 384,
        699, 502, 359, 502, 326, 495, 299, 477, 283, 451, 277, 420,
    },
    shortcut = {
        label = "SHORTCUT",
        signX = 823,
        signY = 374,
        -- Replace these route targets while preserving recovery indices.
        waypoints = {
            [8] = { x = 845, y = 405, speed = 214 },
            [9] = { x = 819, y = 440, speed = 204 },
            [10] = { x = 779, y = 476, speed = 207 },
            [11] = { x = 742, y = 520, speed = 219 },
            [12] = { x = 694, y = 549, speed = 247 },
        },
    },
}, { __index = kitchen })
