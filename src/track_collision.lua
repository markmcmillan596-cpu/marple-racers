local defaults = require("data.physics.arcade")

local Collision = {}

local function clamp(value, low, high)
    return math.max(low, math.min(high, value))
end

-- Return signed distance (negative inside) and the outward unit normal.
local function roundedRectangle(rect, x, y)
    local corner = rect.corner
    local left, right = rect.x + corner, rect.x + rect.w - corner
    local top, bottom = rect.y + corner, rect.y + rect.h - corner
    local dx = x - clamp(x, left, right)
    local dy = y - clamp(y, top, bottom)
    local length = math.sqrt(dx * dx + dy * dy)

    if length > 0 then
        return length - corner, dx / length, dy / length
    end

    -- Inside the inner rectangle, pick its nearest face.
    local inwardX = math.min(x - left, right - x)
    local inwardY = math.min(y - top, bottom - y)
    if inwardX < inwardY then
        return -inwardX - corner, x - left < right - x and -1 or 1, 0
    end
    return -inwardY - corner, 0, y - top < bottom - y and -1 or 1
end

local function separate(marble, depth, nx, ny, bounce)
    if depth <= 0 then
        return
    end

    marble.x = marble.x + nx * depth
    marble.y = marble.y + ny * depth
    local closingSpeed = marble.vx * nx + marble.vy * ny
    if closingSpeed < 0 then
        -- Keep tangential motion and return a fraction of the normal speed.
        local impulse = (1 + bounce) * closingSpeed
        marble.vx = marble.vx - nx * impulse
        marble.vy = marble.vy - ny * impulse
    end
end

local function closestOnSegment(x, y, ax, ay, bx, by)
    local dx, dy = bx - ax, by - ay
    local fraction = clamp(((x - ax) * dx + (y - ay) * dy) / (dx * dx + dy * dy), 0, 1)
    return ax + dx * fraction, ay + dy * fraction
end

-- The island is a convex polygon with clockwise screen-space vertices.
local function polygonDistance(points, x, y)
    local inside = true
    local closestSquared, nearestX, nearestY = math.huge, 0, 0
    local edgeX, edgeY
    local ax, ay = points[#points - 1], points[#points]
    for index = 1, #points, 2 do
        local bx, by = points[index], points[index + 1]
        local dx, dy = bx - ax, by - ay
        if dx * (y - ay) - dy * (x - ax) < 0 then
            inside = false
        end
        local px, py = closestOnSegment(x, y, ax, ay, bx, by)
        local nx, ny = x - px, y - py
        local squared = nx * nx + ny * ny
        if squared < closestSquared then
            closestSquared, nearestX, nearestY = squared, nx, ny
            edgeX, edgeY = dx, dy
        end
        ax, ay = bx, by
    end

    if closestSquared == 0 then
        local length = math.sqrt(edgeX * edgeX + edgeY * edgeY)
        return 0, edgeY / length, -edgeX / length
    end
    local distance = math.sqrt(closestSquared)
    local signed = inside and -distance or distance
    return signed, nearestX / signed, nearestY / signed
end

local function resolveProp(prop, marble, trackBounce)
    local x, y = prop.x, prop.y
    if prop.shape == "capsule" then
        x, y = closestOnSegment(marble.x, marble.y, prop.ax, prop.ay, prop.bx, prop.by)
    end
    local dx, dy = marble.x - x, marble.y - y
    local squared = dx * dx + dy * dy
    local reach = prop.radius + marble.radius
    if squared >= reach * reach then
        return
    end

    local bounce = prop.bounce or trackBounce
    local distance = math.sqrt(squared)
    if distance > 0 then
        separate(marble, reach - distance, dx / distance, dy / distance, bounce)
    elseif prop.shape == "capsule" then
        local edgeX, edgeY = prop.bx - prop.ax, prop.by - prop.ay
        local length = math.sqrt(edgeX * edgeX + edgeY * edgeY)
        separate(marble, reach, edgeY / length, -edgeX / length, bounce)
    else
        separate(marble, reach, 1, 0, bounce)
    end
end

function Collision.resolve(track, marble, bounce)
    bounce = bounce or defaults.trackBounce
    local outer, ox, oy = roundedRectangle(track.outer, marble.x, marble.y)
    separate(marble, outer + marble.radius, -ox, -oy, bounce)

    local bounds = track.island
    local x, y, radius = marble.x, marble.y, marble.radius
    if x > bounds.x - radius and x < bounds.x + bounds.w + radius
        and y > bounds.y - radius and y < bounds.y + bounds.h + radius then
        local distance, nx, ny
        if track.infield then
            distance, nx, ny = polygonDistance(track.infield, x, y)
        else
            distance, nx, ny = roundedRectangle(bounds, x, y)
        end
        separate(marble, radius - distance, nx, ny, bounce)
    end

    for _, obstacle in ipairs(track.obstacles) do
        resolveProp(obstacle, marble, bounce)
    end
end

return Collision
