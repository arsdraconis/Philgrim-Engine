--[[
	Filgrim Engine
	game.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Globals
game = {}
game.cameras = {}

-- Camera Functions ===========================================================
function game.cameras.push(camera)
	-- Pushes the camera onto the camera stack and makes it the current camera.
	if camera:type() == "camera" then
		table.insert(game.cameras, camera)
		game.currentCamera = game.cameras[ #game.cameras ]
	else
		error("game.pushCamera was passed something that was "..camera:type().."!")
	end
end

function game.cameras.pop()
	-- Pops the last camera off the stack and makes the next one the current camera.
	table.remove(game.cameras)
	game.currentCamera = game.cameras[ #game.cameras ]
end

-- General Game Functions =====================================================
function game.init()
	-- Set general LÖVE stuff.
	love.graphics.setBackgroundColor(127, 127, 127)	-- Should this be in Camera?

	-- General Game State
	game.paused = false
	game.showFPS = true
	game.currentLevel = nil

	-- Set up our map.
	debug.createDebugMap()

	-- Set up a default camera.
	local windowWidth, windowHeight = love.graphics.getMode()
	local defaultCamera = Camera:new(1, 1, windowWidth, windowHeight, 2)
	game.cameras.push(defaultCamera)
end
