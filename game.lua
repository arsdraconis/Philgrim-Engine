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
	love.graphics.setBackgroundColor(127, 127, 127)	-- Should really be in Camera?

	-- General Game State
	game.paused = false
	game.showFPS = true
	game.currentLevel = nil

	local rawMap = { 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 234, 203, 203, 203, 203, 203, 203, 203, 203, 203, 203, 235, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 188, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 202, 203, 203, 204, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 186, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 170, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 171, 251, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 208, 203, 203, 203, 203, 235, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 145, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 147, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, 165, 166, 167, nil, nil, nil, nil, nil, 165, 166, 167, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 181, 182, 183, nil, nil, nil, nil, nil, 181, 182, 183, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, nil, nil, 197, 198, 199, nil, nil, nil, nil, nil, 197, 198, 199, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 213, 214, 215, nil, nil, nil, nil, nil, 213, 214, 215, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 141, nil, nil, nil, nil, nil, 229, 230, 231, nil, nil, nil, nil, nil, 229, 230, 231, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 141, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, 245, 246, 247, nil, nil, nil, nil, nil, 245, 246, 247, nil, nil, nil, nil, nil, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 145, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 146, 146, 146, 146, 146, 149, 150, 151, 147, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, 164, 165, 166, 167, 168, nil, nil, nil, nil, 165, 166, 167, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, 180, 181, 182, 183, 184, nil, nil, nil, nil, 181, 182, 183, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, 196, 197, 198, 199, 200, nil, nil, nil, nil, 197, 198, 199, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, 212, 213, 214, 215, 216, nil, nil, nil, nil, 213, 214, 215, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, 228, 229, 230, 231, 232, nil, nil, nil, nil, 229, 230, 231, nil, 186, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187, 187 }

	game.map = Map:new(49, 28, rawMap, 1, 1, 1)
	game.map:loadTiles("Graphics/Tileset.png", 16)

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
