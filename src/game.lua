local Marble = require("src.marble")
local Physics = require("src.physics")
local RaceProgress = require("src.race_progress")
local Driver = require("src.ai_driver")
local defaults = require("data.physics.arcade")

local Game = {}
Game.__index = Game

local STEP = 1 / 120
local MAX_FRAME_TIME = 0.1

local function addRacer(game, spawn, driver)
    local marble = Marble.new(spawn, game.tuning)
    local racer = {
        id = #game.racers + 1,
        marble = marble,
        spawn = spawn,
        driver = driver,
        progress = RaceProgress.new(game.track.gates, game.track.totalLaps),
        recoveries = 0,
    }
    game.marbles[racer.id] = marble
    game.racers[racer.id] = racer
    return racer
end

function Game.new(track, tuning, playerSpawn)
    local game = setmetatable({
        track = track,
        tuning = tuning or defaults,
        marbles = {},
        racers = {},
        inputs = {},
        finishOrder = {},
        elapsed = 0,
        accumulator = 0,
        paused = false,
    }, Game)
    local player = addRacer(game, playerSpawn or track.gates[1].respawn)
    game.player, game.progress = player.marble, player.progress
    return game
end

function Game.newRace(track, tuning)
    local game = Game.new(track, tuning, track.grid[1])
    for index, style in ipairs(track.opponents) do
        addRacer(game, track.grid[index + 1], Driver.new(track.waypoints, style, track.shortcut))
    end
    game.waiting = true
    return game
end

function Game:pause()
    self.paused = true
    self.accumulator = 0
end

function Game:togglePause()
    if self.paused then
        self.paused = false
    else
        self:pause()
    end
end

local function recoverRacer(racer, startGate)
    local progress = racer.progress
    local gate = progress.lastGate
    local spawn = gate.respawn
    if gate == startGate and progress.completedLaps == 0 then
        spawn = racer.spawn
    end
    racer.marble:reset(spawn)
    if racer.driver then
        racer.driver:resetAtGate(gate)
    end
    racer.recoveries = racer.recoveries + 1
end

function Game:recover()
    recoverRacer(self.racers[1], self.track.gates[1])
    self.accumulator = 0
end

local function finishesBefore(a, b)
    if a.finishTime == b.finishTime then
        return a.id < b.id
    end
    return a.finishTime < b.finishTime
end

function Game:step()
    for _, racer in ipairs(self.racers) do
        local marble = racer.marble
        if racer.driver then
            local input = racer.driver:update(marble, STEP, racer.progress.finished)
            if not input then
                recoverRacer(racer, self.track.gates[1])
            end
            self.inputs[racer.id] = input
        end
        -- Capture the beginning of physical movement after any recovery.
        racer.oldX, racer.oldY = marble.x, marble.y
    end
    Physics.step(self.track, self.marbles, self.inputs, STEP, self.tuning)

    for _, racer in ipairs(self.racers) do
        local marble, progress = racer.marble, racer.progress
        local gate, fraction = progress:advance(racer.oldX, racer.oldY, marble.x, marble.y)
        if gate then
            if racer.driver then
                racer.driver:onGate()
            end
            if progress.finished then
                racer.finishTime = self.elapsed + fraction * STEP
                self.finishOrder[#self.finishOrder + 1] = racer
                table.sort(self.finishOrder, finishesBefore)
            end
        end
    end
    self.elapsed = self.elapsed + STEP
end

function Game:update(dt, input)
    if self.paused or (self.waiting and not (input and input.accelerate and not input.brake)) then
        return
    end

    -- Fixed simulation steps keep steering and collisions independent of redraw rate.
    self.waiting = false
    self.inputs[1] = input
    self.accumulator = self.accumulator + math.min(dt, MAX_FRAME_TIME)
    while self.accumulator + 1e-10 >= STEP do
        self.accumulator = math.max(0, self.accumulator - STEP)
        self:step()
    end
end

return Game
