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
	3. We could allow for multiple cameras to draw to the screen (e.g., for picture-in-picture)
	   if we store the origin at which to draw on the window at.
]]

-- Globals
Camera = {}

-- OO Methods =================================================================
function Camera:new(x, y, width, height, scale)
	-- Constructor
	local object = { x = x, y = y, width = width, height = height, scale = scale or 1 }
	setmetatable(object, { __index = Camera })
	return object
end

function Camera:type()
	return "camera"
end

-- Movement Methods ===========================================================
function Camera:moveWithinMapBounds(newX, newY)
	-- This is Camera's primitive move method. It makes sure that the values are within map bounds.
	-- All other movement methods should call it.
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

function Camera:trackEntity(x, y, width, height, xSpeed, ySpeed)
	-- Calling this function causes the camera to continuously track an entity (or just a point in space if you want).
	local xPadding = 160
	local yPadding = 120  -- Fucking with this will cause the display to fuck up. Try it and see!
	local cameraWidth = self.width / self.scale
	local cameraHeight = self.height / self.scale

	-- This seems to be working properly now.
	if x <= self.x + xPadding then
		self:move(-xSpeed, 0)
	elseif x + width >= self.x + cameraWidth - xPadding then
		self:move(xSpeed, 0)
	end

	if y <= self.y + yPadding then
		self:move(0, -ySpeed)
	elseif y + height >= self.y + cameraHeight - yPadding then
		self:move(0, ySpeed)
	end
end

function Camera:move(deltaX, deltaY)
	-- Moves the camera by adding/subtracting the delta values to/from the camera position.
	self:moveWithinMapBounds(self.x + deltaX, self.y + deltaY)
end

function Camera:centerAt(x, y)
	-- Centers the specified coordinate in the camera's view.
	self:moveWithinMapBounds(x - self.width / 2, y - self.height / 2)
end

-- Accessor Methods ===========================================================
function Camera:setX(x)
	self:moveWithinMapBounds(x, self.y)
end

function Camera:setY(y)
	self:moveWithinMapBounds(self.x, y)
end

function Camera:getPosition()
	return self.x, self.y
end

function Camera:getScale()
	return self.scale
end

function Camera:getDimensions()
	return self.width, self.height
end

-- Other Methods ==============================================================
function Camera:draw()
	-- Draws the current scene.
	-- TODO: Finish me!

	-- Store the current graphics state.
	love.graphics.push()

	love.graphics.scale(self.scale)

	-- Draw the map layers, from back to front.
	--[[for _, currentMap in ipairs(game.currentLevel.maps) do
		currentMap:draw()
	end]]
	game.map:draw() -- Level stuff isn't finished yet, so for debug this is here.

	-- Draw the entities in the game world, back to front.
	Entity:drawAll(self.x, self.y)

	love.graphics.pop()
end

function Camera:convertScreenToWorld(x, y)
	-- TODO: Write me!
end

function Camera:convertWorldToScreen(x, y)
	-- TODO: Write me!
end

