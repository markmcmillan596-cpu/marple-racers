local Game = require("src.game")
local Renderer = require("src.renderer")
local track = require("tracks.kitchen")

local game
local view

function love.load(arguments)
    love.keyboard.setKeyRepeat(false)
    local course = track
    for _, option in ipairs(arguments) do
        if option == "--classic" then
            course = require("tracks.breakfast")
        end
    end
    game = Game.newRace(course)
    view = Renderer.new()
end

function love.update(dt)
    game:update(dt, {
        accelerate = love.keyboard.isDown("w", "up"),
        brake = love.keyboard.isDown("s", "down"),
        steer = (love.keyboard.isDown("d", "right") and 1 or 0)
            - (love.keyboard.isDown("a", "left") and 1 or 0),
    })
end

function love.keypressed(key)
    if key == "escape" then
        game:togglePause()
    elseif key == "r" then
        game:recover()
    end
end

function love.focus(focused)
    if not focused and game then
        game:pause()
    end
end

function love.draw()
    view:draw(game)
end
