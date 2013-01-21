--[[
	Mockup
	main.lua

	A 2D platform mockup for LÖVE. 
	Written by Hoover.
]]

-- Modules
require("game")
require("map")

-- Löve's General Callback Functions
function love.load()
	print("Loading...")
	love.graphics.setBackgroundColor(127, 127, 127)
	loadMap()
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
		moveMap(0, -2)
	end
	if love.keyboard.isDown("down")  then
		moveMap(0, 2)
	end
	if love.keyboard.isDown("left")  then
		moveMap(-2, 0)
	end
	if love.keyboard.isDown("right")  then
		moveMap(2, 0)
	end

	updateMap()
end

function love.draw()
	-- Draw the game world.
	drawMap()

	love.graphics.print("FPS: "..love.timer.getFPS(), 15, 20)
end
