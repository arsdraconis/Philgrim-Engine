--[[
	Filgrim Engine
	camera.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
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
Camera = {}		-- Camera object prototype

-- Functions
function Camera:new(x, y, width, height, scale)
	-- Constructor
	local object = { x = x, y = y, width = width, height = height, scale = scale or 1 }
	setmetatable(object, { __index = Camera })
	return object
end

function Camera:setPosition(x, y)
	if x ~= nil then
		self.x = x
	end
	if y ~= nil then
		self.y = y
	end
end

function Camera:getPosition()
	return self.x, self.y
end

function Camera:move(deltaX, deltaY)
	-- Moves the camera by adding/subtracting the delta values to the origin.
	self:moveWithinMapBounds(self.x + deltaX, self.y + deltaY)
end

function Camera:centerAt(x, y)
	-- Centers the specified coordinate in the camera's view.
	self:moveWithinMapBounds(x - self.width / 2, y - self.height / 2)
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
		Entity:drawAll(self.x, self.y)

		love.graphics.pop()
	-- end
end

function Camera:type()
	return "camera"
end

function Camera:convertScreenToWorld(x, y)
	-- TODO: Write me!
end

function Camera:convertWorldToScreen(x, y)
	-- TODO: Write me!
end

function Camera:moveWithinMapBounds(newX, newY)
	-- Make sure the new camera position is within the map.
	local mapWidth, mapHeight = game.map:getDimensionsInPixels()

	if newX > mapWidth - (self.width / self.scale) then
		self.x = mapWidth - (self.width / self.scale)
	elseif newX < 1 then
		self.x = 1
	else
		self.x = newX
	end

	-- FIXME: The -16 pixels are necessary. Remove them to find out why.
	if newY > mapHeight - (self.height / self.scale) - 16 then
		self.y = mapHeight - (self.height / self.scale) - 16
	elseif newY < 1 then
		self.y = 1
	else
		self.y = newY
	end
end

