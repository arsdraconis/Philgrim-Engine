--[[
	Filgrim Engine
	level.lua

	A 2D platform mockup for LÖVE. 
	Written by Hoover.
]]

-- Globals
Level = {}

-- Functions
function Level:new()
	-- Constructor
	local object = {  }
	setmetatable(object, { __index = Level })
	return object
end
