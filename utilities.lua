--[[
	Filgrim Engine
	utilities.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- This is just misc. functions, some for convenience.

util = {}	-- Keep our global scope clean by keeping these in their own table.

function util.makeSize(width, height)
	return { width = width, height = height }
end

function util.makeRect(x, y, width, height)
	return { x = x, y = y, width = width, height = height }
end

-- Object Oriented Utilities ==================================================
oo = {}

function oo.inherit(parent, metatable)
	-- Constructor
	local object = nil
	if class then object = parent:new() else object = {} end
	setmetatable(object, { __index = metatable })
	return object
end