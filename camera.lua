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
function Camera:new(x, y, dimensions, origin, padding, scale)
	-- Constructor
	local object = { x = x or 1, y = y or 1, width = dimensions.width, height = dimensions.height, origin = origin or {x = 0, y = 0}, padding = padding or {x = 0, y = 0}, scale = scale or 1 }
	setmetatable(object, { __index = Camera })
	return object
end

function Camera:type()
	return "camera"
end

-- Accessor Methods ===========================================================
function Camera:getPosition()
	return self.x, self.y
end

function Camera:getOriginPosition()
	return self.origin.x, self.origin.y
end

function Camera:getScale()
	return self.scale
end

function Camera:getDimensions()
	return self.width, self.height
end

-- Movement Methods ===========================================================
function Camera:moveWithinMapBounds(newX, newY, map)
	-- This is Camera's primitive move method. It makes sure that the movement stays within map bounds.
	-- All other movement methods should call it.

	local mapWidth, mapHeight = map:getDimensionsInPixels()

	if newX > mapWidth - (self.width / self.scale) then
		self.x = mapWidth - (self.width / self.scale)
	elseif newX < 1 then
		self.x = 1
	else
		self.x = newX
	end

	if newY > mapHeight - (self.height / self.scale) then
		self.y = mapHeight - (self.height / self.scale)
	elseif newY < 1 then
		self.y = 1
	else
		self.y = newY
	end
end

function Camera:trackEntity(entity)
	-- Calling this function causes the camera to continuously track an entity.
	local cameraWidth = self.width / self.scale
	local cameraHeight = self.height / self.scale
	local x, y = entity:getPosition()
	local width, height = entity:getDimensions()

	if x <= self.x + self.padding.x then
		self:move(-(self.x + self.padding.x - x), 0, entity.map)
	elseif x + width >= self.x + cameraWidth - self.padding.x then
		self:move((x + width) - (self.x + cameraWidth - self.padding.x), 0, entity.map)
	end

	if y <= self.y + self.padding.y then
		self:move(0, -(self.y + self.padding.y - y), entity.map)
	elseif y + height >= self.y + cameraHeight - self.padding.y then
		self:move(0, (y + height) - (self.y + cameraHeight - self.padding.y), entity.map)
	end
end

function Camera:move(deltaX, deltaY, map)
	-- Moves the camera by adding/subtracting the delta values to/from the camera position.
	self:moveWithinMapBounds(self.x + deltaX, self.y + deltaY, map)
end

function Camera:centerAt(x, y, map)
	-- Centers the specified coordinate in the camera's view.
	self:moveWithinMapBounds(x - self.width / 2, y - self.height / 2, map)
end
