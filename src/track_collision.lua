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

local function separate(marble, depth, nx, ny)
    if depth <= 0 then
        return
    end

    marble.x = marble.x + nx * depth
    marble.y = marble.y + ny * depth
    local closingSpeed = marble.vx * nx + marble.vy * ny
    if closingSpeed < 0 then
        -- Keep tangential motion and return a fraction of the normal speed.
        local impulse = 1.42 * closingSpeed
        marble.vx = marble.vx - nx * impulse
        marble.vy = marble.vy - ny * impulse
    end
end

function Collision.resolve(track, marble)
    local outer, ox, oy = roundedRectangle(track.outer, marble.x, marble.y)
    separate(marble, outer + marble.radius, -ox, -oy)

    local island, ix, iy = roundedRectangle(track.island, marble.x, marble.y)
    separate(marble, marble.radius - island, ix, iy)

    for _, obstacle in ipairs(track.obstacles) do
        local dx, dy = marble.x - obstacle.x, marble.y - obstacle.y
        local distance = math.sqrt(dx * dx + dy * dy)
        local overlap = obstacle.radius + marble.radius - distance
        if overlap > 0 then
            if distance > 0 then
                separate(marble, overlap, dx / distance, dy / distance)
            else
                separate(marble, overlap, 1, 0)
            end
        end
    end
end

return Collision
