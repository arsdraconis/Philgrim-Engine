--[[
	Filgrim Engine
	level.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Globals
Level = {}		-- Level object prototype

-- Functions
function Level:new()
	-- Constructor
	local object = {  }
	setmetatable(object, { __index = Level })
	return object
end
