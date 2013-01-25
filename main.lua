--[[
	Mockup
	main.lua

	A 2D platform mockup for LÖVE. 
	Written by Hoover.
]]

-- Modules
require("game")
require("camera")
require("map")

-- Löve's General Callback Functions
function love.load()
	print("Loading...")
	game.init()
	-- game.currentLevel.init()
	-- map.loadMap()
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

	-- Game tick code here.
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

	local x, y = game.currentCamera:getOrigin()
	local width, height = game.currentCamera:getDimensions()
	local scale = game.currentCamera:getScale()
	width = width / scale
	height = height / scale

	game.map:update(x, y, width, height)
end

function love.draw()
	-- Draw the game world.
	game.currentCamera:draw()

	if game.showFPS then
		love.graphics.print("FPS: "..love.timer.getFPS(), 15, 20)
	end
end
