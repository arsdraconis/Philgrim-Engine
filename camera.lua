--[[
	Filgrim Engine
	camera.lua

	A 2D platform mockup for LÖVE.
	Written by Hoover
]]

--[[
	TODO:
	1. Add functions for converting coordinates from world to screen and vice versa.
	2. Add more settings, like setting background color, tint/filters, etc.
	3. Add stuff to get the width/height in tiles, etc.
	4. We could allow for multiple cameras to draw to the screen (e.g., for picture-in-picture)
	   if we store the origin at which to draw on the window at.
]]

-- Globals
Camera = {}		-- A table to hold our class methods.

-- Functions
function Camera:new(x, y, width, height, scale)
	-- Constructor
	local object = { x = x, y = y, width = width, height = height, scale = scale or 1, lastPosition = { x = x, y = y } }
	setmetatable(object, { __index = Camera })
	return object
end

function Camera:move(deltaX, deltaY)
	-- Moves the camera by adding/subtracting the delta values to the origin.
	self.x = self.x + deltaX
	self.y = self.y + deltaY
end

function Camera:centerAt(x, y)
	-- Centers the specified coordinate in the camera's view.
	self.x, self.y = x - self.width / 2, y - self.height / 2
end

function Camera:getOrigin()
	return self.x, self.y
end

function Camera:getScale()
	return self.scale
end

function Camera:getDimensions()
	return self.width, self.height
end

function Camera:draw()
	-- Draws the current scene.
	-- TODO: Currently broken. Finish me!

	-- If our position hasn't changed, don't bother recalculating the map position.
	-- if self.x == self.lastPosition.x and self.y == self.lastPosition.y then return end

	--[[ Check if the current map has map layers. If so, draw them.
	if game.currentLevel.mapLayers > 0 then]]
		love.graphics.push()
		love.graphics.scale(self.scale)

		-- Draw the map layers, from back to front.
		game.map:draw()
		-- Draw the entities in the game world, back to front.

		love.graphics.pop()
	-- end
end

function Camera:isCamera()
	return true
end

function Camera:convertScreenToWorld(x, y)
	-- TODO: Write me!
end

function Camera:convertWorldToScreen(x, y)
	-- TODO: Write me!
end

