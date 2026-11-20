-- Original, resolution-independent breakfast art drawn with LÖVE primitives.
local Art = {}
local g = love.graphics

local function ink(r, green, b, alpha)
    g.setColor(r / 255, green / 255, b / 255, alpha or 1)
end

local function rounded(mode, rect, inset)
    inset = inset or 0
    g.rectangle(mode, rect.x + inset, rect.y + inset, rect.w - 2 * inset,
        rect.h - 2 * inset, rect.corner - inset, rect.corner - inset, 72)
end

function Art.drawWood(track)
    local outer = track.outer
    ink(92, 52, 39)
    g.setLineWidth(13)
    rounded("line", outer)
    ink(220, 158, 99)
    rounded("fill", outer)

    -- Keep grain inside the curved course edge. The parallel strips make
    -- the grain visible at a reduced resolution without obscuring racers.
    g.stencil(function() rounded("fill", outer) end, "replace", 1)
    g.setStencilTest("equal", 1)
    for row = 0, 19 do
        local y = outer.y + row * 25
        ink(250, 195 + row * 7 % 19, 133, 0.28)
        g.rectangle("fill", outer.x, y, outer.w, 25)
        ink(140, 77, 46, 0.26)
        g.setLineWidth(1)
        g.line(outer.x, y, outer.x + outer.w, y)
        for grain = 1, 6 do
            local x = outer.x + (row * 391 + grain * 157) % outer.w
            local gy = y + 4 + (row * 6 + grain * 9) % 17
            local length = 38 + (row * 13 + grain * 29) % 110
            g.line(x, gy, x + length * 0.42, gy - 2, x + length, gy)
        end
    end
    g.setStencilTest()
    ink(255, 236, 186)
    g.setLineWidth(4)
    rounded("line", outer, 3)
    ink(108, 61, 44, 0.22)
    g.setLineWidth(2)
    rounded("line", track.centerline)
end

local function infield(mode, track)
    if track.infield then
        g.polygon(mode, track.infield)
    else
        rounded(mode, track.island)
    end
end

function Art.drawInfield(track)
    ink(41, 85, 83)
    infield("fill", track)
    g.stencil(function() infield("fill", track) end, "replace", 1)
    g.setStencilTest("equal", 1)
    ink(143, 198, 174, 0.23)
    for row = 0, 9 do
        g.rectangle("fill", 270, 305 + row * 21, 560, 8)
    end
    for column = 0, 26 do
        g.rectangle("fill", 270 + column * 21, 305, 8, 205)
    end
    g.setStencilTest()
    ink(242, 222, 167)
    g.setLineWidth(4)
    infield("line", track)
end

local function citrus(x, y, radius)
    ink(146, 64, 34)
    g.circle("fill", x + 2, y + 4, radius)
    ink(208, 108, 47)
    g.circle("fill", x, y, radius)
    ink(252, 213, 140)
    g.circle("fill", x, y, radius * 0.89)
    for wedge = 0, 7 do
        local angle = wedge * math.pi / 4
        ink(249, 166 + (wedge % 3) * 11, 66)
        g.arc("fill", "pie", x, y, radius * 0.76, angle + 0.05, angle + math.pi / 4 - 0.05)
    end
    ink(255, 234, 177)
    g.circle("fill", x, y, radius * 0.10)
end

local function cutlery(x, y, fork)
    ink(63, 50, 49, 0.28)
    g.ellipse("fill", x + 4, y + 10, 13, 69)
    ink(135, 146, 145)
    g.rectangle("fill", x - 4, y - 18, 8, 82, 4)
    ink(237, 236, 212)
    g.rectangle("fill", x - 3, y - 20, 5, 80, 3)
    if fork then
        g.rectangle("fill", x - 10, y - 32, 20, 19, 7)
        for tine = -1, 1 do
            g.rectangle("fill", x + tine * 8 - 2, y - 62, 4, 36, 2)
        end
    else
        g.ellipse("fill", x, y - 40, 12, 24)
        ink(178, 193, 184)
        g.ellipse("fill", x + 1, y - 44, 8, 16)
    end
end

function Art.drawDecor(prop, track, fonts)
    local x, y = prop.x, prop.y
    if prop.kind == "napkin" then
        g.push()
        g.translate(x, y)
        g.rotate(-0.16)
        ink(35, 60, 61, 0.55)
        g.rectangle("fill", -45, -43, 100, 103, 8)
        ink(234, 177, 121)
        g.rectangle("fill", -51, -51, 100, 103, 6)
        ink(189, 100, 79, 0.6)
        for i = -35, 37, 12 do
            g.rectangle("fill", i, -48, 3, 97)
        end
        ink(253, 223, 170)
        g.polygon("fill", 49, 27, 26, 51, 49, 51)
        g.pop()
    elseif prop.kind == "saucer" then
        ink(23, 42, 43, 0.55)
        g.ellipse("fill", x + 2, y + 8, 186, 78)
        ink(247, 234, 199)
        g.ellipse("fill", x, y, 186, 78)
        ink(79, 131, 119)
        g.setLineWidth(3)
        g.ellipse("line", x, y, 177, 69)
        g.setLineWidth(1)
        g.ellipse("line", x, y, 164, 56)
        ink(83, 79, 63)
        g.setFont(fonts.small)
        g.printf(string.upper(track.location), x - 170, y - 32, 340, "center")
        ink(60, 72, 61)
        g.setFont(fonts.large)
        g.printf(track.title, x - 181, y - 11, 362, "center")
    elseif prop.kind == "orange" then
        citrus(x, y, prop.radius)
    elseif prop.kind == "juice" then
        ink(79, 54, 43, 0.40)
        g.circle("fill", x + 3, y + 5, prop.radius)
        ink(255, 235, 193)
        g.circle("fill", x, y, prop.radius)
        ink(247, 169, 78)
        g.circle("fill", x, y, prop.radius - 5)
        g.setLineWidth(7)
        ink(232, 102, 98)
        g.line(x + 3, y + 3, x + 11, y - 27, x + 20, y - 36)
        citrus(x - 12, y + 8, 10)
        ink(255, 249, 220, 0.70)
        g.setLineWidth(2)
        g.arc("line", "open", x, y, prop.radius - 7, 2.9, 4.65)
    else
        cutlery(x, y, prop.kind == "fork")
    end
end

function Art.drawSolid(prop)
    local x, y, r = prop.x, prop.y, prop.radius
    ink(81, 50, 43, 0.34)
    g.circle("fill", x + 3, y + 5, r)
    if prop.kind == "blueberry" then
        ink(39, 51, 93)
        g.circle("fill", x, y, r)
        ink(77, 102, 153)
        g.circle("fill", x - 2, y - 3, r - 4)
        ink(35, 50, 84)
        for petal = 1, 5 do
            local angle = petal * math.pi * 2 / 5
            g.circle("fill", x + 5 * math.cos(angle), y - 2 + 5 * math.sin(angle), 3.5)
        end
        ink(170, 189, 219)
        g.circle("fill", x - r * 0.43, y - r * 0.41, 3)
    else
        ink(118, 83, 67)
        g.circle("fill", x, y, r)
        ink(245, 233, 198)
        g.circle("fill", x, y, r - 2)
        ink(217, 191, 155)
        g.circle("fill", x, y, r - 6)
        for piece = 1, 3 do
            local px = x - 12 + (piece - 1) * 12
            local py = y - 5 + (piece % 2) * 8
            ink(177, 151, 122)
            g.rectangle("fill", px - 6, py - 4, 13, 13, 2)
            ink(254, 247, 223)
            g.rectangle("fill", px - 7, py - 6, 13, 12, 2)
        end
    end
end

return Art
