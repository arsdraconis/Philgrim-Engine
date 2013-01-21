--[[
	Mockup
	game.lua

	A 2D platform mockup for LÖVE. 
	Written by Hoover.
]]

-- Globals
-- General Game State
game = {}
game.paused = false
game.currentLevel = nil

-- Viewport State
-- Controls what we draw.
game.viewport = {}
game.viewport.width = 26
game.viewport.height = 20
game.viewport.originX = 1
game.viewport.originY = 1
