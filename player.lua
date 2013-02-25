--[[
	Filgrim Engine
	player.lua

	A 2D platformer engine for LÖVE
	By Hoover and Phil
]]

-- Player Class
Player = {}												-- Player object prototype
Player.mt = setmetatable(Player, { __index = Entity })	-- Derive from Entity.

-- Functions
function Player:new(x, y, width, height)
	local object = Entity:new(x, y, width, height)
	setmetatable(object, { __index = Player })
	return object
end

function Player:type()
	-- Returns the type of the object this is.
	return "player"
end

function Player:update()
	--print("Current player position: "..self.x..", "..self.y)	
	-- Move the player.
	if love.keyboard.isDown("left")  then
		self:move(-2, 0)
	elseif love.keyboard.isDown("right")  then
		self:move(2, 0)
	end

	-- Gravity
	self:move(0, 4)

	-- Move the camera.
	if love.keyboard.isDown("up")  then
		game.currentCamera:move(0, -2)
	elseif love.keyboard.isDown("down")  then
		game.currentCamera:move(0, 2)
	elseif love.keyboard.isDown("left")  then
		game.currentCamera:move(-2, 0)
	elseif love.keyboard.isDown("right")  then
		game.currentCamera:move(2, 0)
	end

	if self.x < -5 then self.x = 0 end
	if self.y < -5 then self.y = 0 end
end

function Player:draw(x, y)
	if not self.active then return end
	love.graphics.rectangle("fill", self.x - x, self.y - y, self.width, self.height)
end
