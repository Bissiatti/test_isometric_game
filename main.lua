Widht, Height, Flags = love.window.getMode( )

function ConvertXY(x,y)
	return {Widht/2+(x-y),(x+y)/2}
end

function love.load()
	-- load libs
	wf = require "libs/windfield"
	sti = require 'libs/sti'

	-- create map

	gameMap = sti("maps/test.lua")

	world = wf.newWorld(0,0)


	Walls = {}

	if gameMap.layers['player'] then
		for key, object in pairs(gameMap.layers['player'].objects) do
			player = object
			break
		end
	end

	if gameMap.layers['paredeObj'] then
		for k, object in pairs(gameMap.layers["paredeObj"].objects) do
			local newPoint = {{ConvertXY(object.x,object.y),ConvertXY(object.x+object.width,object.y)},
						{ConvertXY(object.x,object.y+object.height),ConvertXY(object.x+object.width,object.y+object.height)}}
			local wall = world:newPolygonCollider({newPoint[1][1][1],newPoint[1][1][2],
													newPoint[1][2][1],newPoint[1][2][2],
													newPoint[2][2][1],newPoint[2][2][2],
													newPoint[2][1][1],newPoint[2][1][2]})  -- world:newRectangleCollider(xNew,yNew,object.width,object.height)
			wall:setType('static')
			table.insert(Walls,wall)
		end
	end

	
	local t = ConvertXY(player.x,player.y)

	player.x = t[1]
	player.y = t[2]

	player.h = 10
	player.w = 10
	player.speed = 100


	player.collider = world:newRectangleCollider(player.x,player.y,player.w,player.h)
	player.collider:setFixedRotation(true)

end

function love.update(dt)
	local vx, vy = 0, 0
	if love.keyboard.isDown("w") and love.keyboard.isDown("d") then
		vy = - 0.5*player.speed
		vx = 1*player.speed
	elseif love.keyboard.isDown("s") and love.keyboard.isDown("a") then
		vy = 0.5*player.speed
		vx = - 1*player.speed

	elseif love.keyboard.isDown("a") and love.keyboard.isDown("w") then
		vx = - 1*player.speed
		vy = - 0.5*player.speed
	elseif love.keyboard.isDown("d") and love.keyboard.isDown("s") then
		vx = 1*player.speed
		vy = 0.5*player.speed
	elseif love.keyboard.isDown("d") then
		vx =  1*player.speed
	elseif love.keyboard.isDown("a") then
		vx = - 1*player.speed
	elseif love.keyboard.isDown("s") then
		vy = 1*player.speed
	elseif love.keyboard.isDown("w") then
		vy = -1*player.speed
	end
	world:update(dt)
	player.collider:setLinearVelocity(vx,vy)
	player.x = player.collider:getX() - player.w/2
	player.y = player.collider:getY() - player.h/2
end

function love.draw()
	gameMap:draw()
	love.graphics.setColor(1,0,0)
	love.graphics.rectangle("fill",player.x,player.y,player.w,player.h)
	love.graphics.setColor(1,1,1)
	world:draw()
end