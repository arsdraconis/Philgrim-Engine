--[[
	Filgrim Engine
	main.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Modules
require("game")
require("camera")
require("map")
require("entity")
require("player")

debug = {}		-- Here for experimentation.

function debug.debugTest()
	debug.test = Player:new(100, 100, 48, 48)
end


-- Löve's General Callback Functions
function love.load()
	print("Loading...")
	game.init()
	debug.debugTest()
end

function love.focus(f)
	if not f then
		game.paused = true
		print(love.graphics.getCaption().." lost focus!")
	else
		game.paused = false
		print(love.graphics.getCaption().." gained focus!")
	end
end

function love.quit()
	print("Quitting...")
end

-- Love's Game Loop Callbacks
function love.update(dt)
	if game.paused then return end

	--[[
	Game loop:
	1. Read input
	2. Update map
	3. Update entities
	That's it!
	]]

	Entity:updateAll(dt)


	-- Update the map.
	local scale = game.currentCamera:getScale()
	local x, y = game.currentCamera:getPosition()
	local width, height = game.currentCamera:getDimensions()
	width = width / scale
	height = height / scale

	game.map:update(x, y, width, height)
end

function love.draw()
	--[[
	Draw loop:
	1. Draw camera.
	2. Draw UI.
	3. Draw debug info (FPS counter, etc.)
	]]

	game.currentCamera:draw()

	if game.showFPS then love.graphics.print("FPS: "..love.timer.getFPS(), 15, 20) end
end
