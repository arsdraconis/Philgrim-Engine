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

-- Löve's General Callback Functions
function love.load()
	print("Loading...")
	game.init()
	game.debugTest()
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

	if love.keyboard.isDown("up")  then
		game.currentCamera:move(0, -2)
	end
	if love.keyboard.isDown("down")  then
		game.currentCamera:move(0, 2)
	end
	if love.keyboard.isDown("left")  then
		game.currentCamera:move(-2, 0)
	end
	if love.keyboard.isDown("right")  then
		game.currentCamera:move(2, 0)
	end

	local scale = game.currentCamera:getScale()
	local x, y = game.currentCamera:getPosition()
	local width, height = game.currentCamera:getDimensions()
	width = width / scale
	height = height / scale

	-- If the camera is beyond the edge of the map, snap it back.
	local mapWidth, mapHeight = game.map:getDimensionsInPixels()
	mapWidth  = mapWidth  - width
	mapHeight = mapHeight - height
	if x > mapWidth  then x = mapWidth  end
	if y > mapHeight then y = mapHeight end
	if x < 1 then x = 1 end
	if y < 1 then y = 1 end

	game.currentCamera:setPosition(x, y)
	x, y = game.currentCamera:getPosition()

	-- Gravity for test entity.
	debug.test:move(0, 3)
	local currentX, currentY = debug.test:getPosition()
	if (currentY + 96) > mapHeight + height then debug.test:setPosition(currentX, mapHeight + height - 96) end

	-- Update the map.
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
