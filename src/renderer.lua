local Renderer = {}
Renderer.__index = Renderer

local g = love.graphics
local WIDTH, HEIGHT = 1100, 720

local function color(r, green, b, alpha)
    g.setColor(r / 255, green / 255, b / 255, alpha or 1)
end

local function panel(mode, x, y, w, h, corner)
    g.rectangle(mode, x, y, w, h, corner, corner, 72)
end

local function contour(mode, rect)
    panel(mode, rect.x, rect.y, rect.w, rect.h, rect.corner)
end

function Renderer.new()
    return setmetatable({
        small = g.newFont(12),
        medium = g.newFont(16),
        large = g.newFont(30),
        display = g.newFont(37),
    }, Renderer)
end

function Renderer:drawTable()
    color(70, 45, 37)
    g.rectangle("fill", 0, 0, WIDTH, HEIGHT)
    color(34, 26, 26)
    panel("fill", 26, 117, 1048, 558, 40)
    color(192, 129, 79)
    panel("fill", 26, 108, 1048, 553, 40)
    color(221, 159, 101)
    panel("fill", 34, 116, 1032, 536, 34)

    -- A few deterministic grain strokes keep the tabletop readable behind the lane.
    g.setLineWidth(1)
    for grain = 1, 45 do
        local x = 53 + (grain * 139) % 780
        local y = 134 + (grain * 53) % 500
        local length = 44 + (grain * 29) % 160
        color(121, 63, 41, 0.17)
        g.line(x, y, x + length * 0.46, y + 2, x + length, y)
    end
    color(255, 222, 169, 0.55)
    g.setLineWidth(2)
    panel("line", 39, 121, 1022, 526, 29)
end

local function drawCheckpoint(checkpoint, active)
    g.push()
    g.translate(checkpoint.x, checkpoint.y)
    g.rotate(checkpoint.angle)

    local start = checkpoint.label == "START"
    -- Crosswise stripe and two end caps mark each recovery location.
    if start then
        for row = 0, 8 do
            for column = 0, 1 do
                local shade = (row + column) % 2 == 0 and 240 or 64
                color(shade, shade, shade, 0.92)
                g.rectangle("fill", -10 + column * 10, -45 + row * 10, 10, 10)
            end
        end
    else
        color(246, 198, 117, 0.72)
        g.setLineWidth(3)
        for y = -38, 38, 19 do
            g.line(-8, y - 6, 1, y, -8, y + 6)
        end
    end

    if active then
        color(143, 221, 205)
    else
        color(200, 173, 137)
    end
    g.circle("fill", -2, -49, 3)
    g.circle("fill", -2, 49, 3)
    g.pop()
end

local function drawObstacle(prop)
    color(26, 20, 25, 0.40)
    g.ellipse("fill", prop.x + 3, prop.y + 6, prop.radius + 4, prop.radius * 0.8)
    if prop.kind == "blueberry" then
        color(36, 54, 91)
        g.circle("fill", prop.x, prop.y, prop.radius)
        color(81, 111, 159)
        g.circle("fill", prop.x - 3, prop.y - 4, prop.radius * 0.76)
        color(40, 59, 103)
        for petal = 1, 5 do
            local angle = petal * math.pi * 2 / 5
            g.circle("fill", prop.x + 4 * math.cos(angle), prop.y - 5 + 4 * math.sin(angle), 3.5)
        end
        color(171, 192, 224, 0.82)
        g.circle("fill", prop.x - 9, prop.y - 10, 2.5)
    else
        g.push()
        g.translate(prop.x, prop.y)
        g.rotate(-0.22)
        color(211, 178, 142)
        panel("fill", -20, -20, 40, 40, 5)
        color(251, 226, 189)
        panel("fill", -20, -20, 40, 32, 5)
        color(255, 248, 228, 0.8)
        for i = 1, 9 do
            g.circle("fill", -15 + i * 7 % 30, -15 + i * 11 % 24, 1.3)
        end
        g.pop()
    end
end

function Renderer:drawTrack(game)
    local track = game.track
    color(103, 63, 49)
    panel("fill", track.outer.x, track.outer.y + 7, track.outer.w, track.outer.h, track.outer.corner)
    color(76, 60, 65)
    contour("fill", track.outer)
    color(107, 84, 80)
    g.setLineWidth(2)
    contour("line", track.centerline)
    color(247, 219, 173)
    g.setLineWidth(5)
    contour("line", track.outer)

    color(156, 75, 58)
    contour("fill", track.island)
    color(252, 212, 156)
    contour("line", track.island)
    -- Clipped-looking tile accents stay inside the rounded infield.
    color(252, 203, 154, 0.18)
    for row = 1, 5 do
        for column = 1, 14 do
            if (row + column) % 2 == 0 then
                panel("fill", 304 + column * 31, 312 + row * 27, 29, 25, 3)
            end
        end
    end
    self:drawPlate(track)

    for _, checkpoint in ipairs(track.checkpoints) do
        drawCheckpoint(checkpoint, checkpoint == game.checkpoint)
    end
    for _, prop in ipairs(track.obstacles) do
        drawObstacle(prop)
    end
end

function Renderer:drawPlate(track)
    color(87, 45, 42, 0.50)
    g.ellipse("fill", 550, 410, 242, 82)
    color(245, 225, 190)
    g.ellipse("fill", 550, 404, 242, 82)
    color(200, 148, 117)
    g.setLineWidth(2)
    g.ellipse("line", 550, 404, 228, 70)
    color(136, 72, 53)
    g.setFont(self.small)
    g.printf(string.upper(track.location), 310, 369, 480, "center")
    color(65, 43, 45)
    g.setFont(self.display)
    g.printf(track.title, 310, 390, 480, "center")
end

local function drawMarble(player)
    local x, y, r = player.x, player.y, player.radius
    color(24, 22, 29, 0.55)
    g.circle("fill", x + 3, y + 5, r + 2)
    color(26, 81, 82)
    g.circle("fill", x, y, r)
    color(104, 239, 214)
    g.circle("fill", x - 1, y - 1, r - 2)
    color(213, 255, 241)
    g.circle("fill", x - 4, y - 5, 4)
    color(229, 255, 246)
    g.setLineWidth(2)
    g.circle("line", x, y, r)

    -- A dark pip shows the steering heading even while the marble is sliding.
    color(26, 81, 82)
    g.circle("fill", x + 9 * math.cos(player.angle), y + 9 * math.sin(player.angle), 2.5)

    -- The outer arrow follows actual travel, falling back to heading at rest.
    local direction = player.angle
    if player:speed() > 8 then
        direction = math.atan2(player.vy, player.vx)
    end
    g.push()
    g.translate(x, y)
    g.rotate(direction)
    color(36, 36, 40)
    g.polygon("fill", r + 18, 0, r + 4, -8, r + 4, 8)
    color(240, 254, 239)
    g.polygon("fill", r + 15, 0, r + 6, -5, r + 6, 5)
    g.pop()
end

function Renderer:drawHUD(game)
    color(246, 221, 186)
    g.setFont(self.large)
    g.print("Marble Racers", 34, 19)
    color(231, 172, 125)
    g.setFont(self.medium)
    g.print("Around the House", 35, 58)

    color(101, 65, 54)
    panel("fill", 787, 21, 280, 62, 11)
    color(240, 204, 165)
    g.setFont(self.small)
    g.print("RECOVERY POINT", 801, 31)
    g.printf("SPEED", 962, 31, 89, "right")
    color(255, 236, 210)
    g.setFont(self.medium)
    g.print(game.checkpoint.label == "START" and "Start line" or "Far straight", 801, 49)
    g.printf(("%d px/s"):format(math.floor(game.player:speed() + 0.5)), 944, 49, 107, "right")

    color(246, 221, 186)
    g.printf("W / Up  Accelerate     S / Down  Brake     A D / Left Right  Steer     R  Recover     Esc  Pause",
        25, 684, 1050, "center")
end

function Renderer:draw(game)
    local w, h = g.getDimensions()
    local scale = math.min(w / WIDTH, h / HEIGHT)
    g.clear(0.12, 0.09, 0.10)
    g.push()
    g.translate((w - WIDTH * scale) / 2, (h - HEIGHT * scale) / 2)
    g.scale(scale)
    self:drawTable()
    self:drawTrack(game)
    drawMarble(game.player)
    self:drawHUD(game)

    if game.paused then
        color(24, 16, 20, 0.72)
        g.rectangle("fill", 0, 0, WIDTH, HEIGHT)
        color(70, 45, 37)
        panel("fill", 375, 289, 350, 130, 18)
        color(255, 236, 210)
        g.setFont(self.display)
        g.printf("Paused", 375, 309, 350, "center")
        g.setFont(self.medium)
        g.printf("Press Esc to resume", 375, 367, 350, "center")
    end
    g.pop()
end

return Renderer
