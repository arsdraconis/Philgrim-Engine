--[[
	Filgrim Engine
	player.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Player Class
Player = {}												-- Player object prototype
Player.mt = setmetatable(Player, { __index = Character })	-- Derive from Character.

-- OO Methods =================================================================
function Player:new(x, y, width, height)
	local object = Character:new(x, y, width, height)
	setmetatable(object, { __index = Player })
	return object
end

function Player:type()
	-- Returns the type of the object this is.
	return "player"
end

-- Player Methods =============================================================
function Player:update(deltaTime)
	-- Gravity
	local jumpVelocity = 4
	local newJumpVelocity = 0

	-- Move the player.
	if love.keyboard.isDown("left") then
		self:move(-2, 0)
	end
	if love.keyboard.isDown("right") then
		self:move(2, 0)
	end
	if love.keyboard.isDown(" ") then
		-- We use a cubic-ish function to calculate our jump velocities.
		newJumpVelocity = self:jump(deltaTime)
	end

	if newJumpVelocity ~= 0 then
		jumpVelocity = newJumpVelocity
	end

	-- Move based on our jump arc or gravity.
	self:move(0, jumpVelocity)

	-- Move the camera.
	game.currentCamera:trackEntity(self.x, self.y, self.width, self.height)

	-- If we don't stop our object from falling off the map, then Lua will go into an infinite loop for some reason related to collision calculation.
	local mapWidth, mapHeight = game.map:getDimensionsInPixels()
	if self.x < -5 then self.x = 0 end
	if self.y < -5 then self.y = 0 end
	if self.x + self.width > mapWidth   then self.x = mapWidth  - self.width end
	if self.y + self.height > mapHeight then self.y = mapHeight - self.height end
end

function Player:draw(x, y)
	if not self.active then return end
	love.graphics.rectangle("fill", self.x - x, self.y - y, self.width, self.height)
end
