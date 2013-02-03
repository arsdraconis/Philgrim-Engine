--[[
	Filgrim Engine
	player.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Globals
Player = {}		-- Player object prototype

-- Functions
function Player:new(x, y, width, height)
	local object = Entity:new(x, y, width, height)
	return object
end

function Player:type()
	-- Returns the type of the object this is.
	return "player"
end
