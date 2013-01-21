--[[
	Mockup
	game.lua

	A 2D platform mockup for LÖVE. 
	Written by Hoover.
]]

-- Globals
game = {}
game.cameras = {}


-- Functions
function game.cameras.push(camera)
	-- TODO: Fix me!
	if camera:isCamera() then
		table.insert(game.cameras, camera)
		game.currentCamera = game.cameras[ #game.cameras ]
	else
		error("game.pushCamera was passed something that was not a camera!")
	end
end

function game.cameras.pop()
	table.remove(game.cameras)
	game.currentCamera = game.cameras[ #game.cameras ]
end

function game.init()
	-- Set general LÖVE stuff.
	love.graphics.setBackgroundColor(127, 127, 127)	-- Should really be in Camera.

	-- General Game State
	game.paused = false
	game.showFPS = true
	game.currentLevel = nil

	-- Viewport State
	-- Controls what we draw.
	-- TODO: Instead of this we should have a camera stack and init a default camera.
	local windowWidth, windowHeight = love.graphics.getMode()
	local defaultCamera = Camera:new(1, 1, windowWidth, windowHeight, 2)
	game.cameras.push(defaultCamera)

	--[[ game.viewport = {}
	game.viewport.width = 26
	game.viewport.height = 20
	game.viewport.originX = 1
	game.viewport.originY = 1]]
end
