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
    checkpoints = {
        { x = 416, y = 236, angle = 0, radius = 50, label = "START" },
        { x = 623, y = 570, angle = math.pi, radius = 50, label = "RECOVERY" },
    },
}
