-- Run from the project root with lua tests/practice_loop.lua.
local Game = require("src.game")
local track = require("tracks.breakfast")
local game = Game.new(track)
local atan2 = math.atan2 or math.atan

-- Drive clockwise through the practice lane and around each prop.
local waypoints = {
    { 550, 247 }, { 690, 278 }, { 795, 251 }, { 866, 270 }, { 913, 332 }, { 911, 412 },
    { 907, 471 }, { 879, 530 }, { 823, 570 }, { 728, 571 }, { 623, 570 }, { 498, 567 },
    { 385, 534 }, { 285, 542 }, { 226, 516 }, { 190, 466 }, { 193, 397 }, { 201, 328 },
    { 219, 279 }, { 270, 247 }, { 329, 236 }, { 450, 236 },
}
for lap = 1, track.totalLaps do
    for index, point in ipairs(waypoints) do
        local reached = false
        for _ = 1, 240 do
            local player = game.player
            local dx, dy = point[1] - player.x, point[2] - player.y
            if dx * dx + dy * dy < 22 * 22 then
                reached = true
                break
            end
            local angleToPoint = atan2(dy, dx)
            local difference = (angleToPoint - player.angle + math.pi) % (2 * math.pi) - math.pi
            local speed = player:speed()
            game:update(1 / 60, {
                accelerate = speed < 178,
                brake = speed > 190,
                steer = math.max(-1, math.min(1, difference * 4)),
            })
        end
        assert(reached, ("Waypoint %d blocked at %.1f, %.1f"):format(index, game.player.x, game.player.y))
        if index == 12 then
            assert(game.progress.lastGate == track.gates[3], "Far checkpoint did not activate")
        end
    end
    assert(game.progress.completedLaps == lap, ("Expected %d completed laps"):format(lap))
end
assert(game.progress.finished, "The third lap did not finish the race")
print("PASS three player-driven laps with ordered gates and a finish")
