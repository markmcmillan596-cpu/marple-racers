-- Positions and dimensions use pixels in the 1100 × 720 reference view.
return {
    title = "Breakfast Grand Prix",
    location = "Kitchen Table Circuit",
    outer = { x = 90, y = 169, w = 920, h = 471, corner = 132 },
    island = { x = 277, y = 307, w = 546, h = 195, corner = 82 },
    centerline = { x = 179, y = 237, w = 742, h = 335, corner = 111 },
    obstacles = {
        { x = 697, y = 225, radius = 22, kind = "blueberry" },
        { x = 950, y = 439, radius = 29, kind = "sugar" },
        { x = 333, y = 582, radius = 23, kind = "blueberry" },
        { x = 150, y = 361, radius = 27, kind = "sugar" },
    },
    totalLaps = 3,
    -- The first gate is start/finish. Forward crosses onto the positive side of A -> B
    -- by cross-product sign, using screen coordinates with Y increasing down.
    gates = {
        { ax = 416, ay = 307, bx = 416, by = 169, label = "Start / finish",
          respawn = { x = 416, y = 236, angle = 0 } },
        { ax = 823, ay = 400, bx = 1010, by = 400, label = "Right straight",
          respawn = { x = 908, y = 423, angle = math.pi / 2 } },
        { ax = 623, ay = 502, bx = 623, by = 640, label = "Far straight",
          respawn = { x = 600, y = 570, angle = math.pi } },
        { ax = 277, ay = 401, bx = 90, by = 401, label = "Left straight",
          respawn = { x = 196, y = 378, angle = 3 * math.pi / 2 } },
    },
}
