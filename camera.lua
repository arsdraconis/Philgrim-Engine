--[[
	Mockup
	camera.lua

	A 2D platform mockup for LÖVE.
	Written by Hoover
]]

--[[
	TODO:
	1. Add functions for converting coordinates from world to screen and vice versa.
]]

-- Globals
Camera = {}		-- A table to hold our class methods.

-- Functions
function Camera:new(x, y, width, height, scale)
	local object = { x = x, y = y, width = width, height = height, scale = scale or 1 }
	setmetatable(object, { __index = Camera })
	return object
end

function Camera:move(deltaX, deltaY)
	self.x = self.x + deltaX
	self.y = self.y + deltaY
end

function convertScreenToWorld(x, y)
	-- TODO: Write me!
end

function convertWorldToScreen(x, y)
	-- TODO: Write me!
end

