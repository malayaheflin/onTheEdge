import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/object"

local pd <const> = playdate
local gfx <const> = pd.graphics

local carSprite, finishSprite
local force
local isMoving
function setup()
	local carImage = gfx.image.new("images/Car.png")
	carSprite = gfx.sprite.new(carImage)
	carSprite:setSize(130, 100)
	carSprite:moveTo(80,120)
	carSprite:add()
	-- temp finish sprite init
	local finishImage = gfx.image.new("images/finishline.png")
	finishSprite = gfx.sprite.new(finishImage)
	finishSprite:setSize(20, 200)
	finishSprite:moveTo(250, 270)
	finishSprite:add()
	-- ground sprite
	local groundImage = gfx.image.new(350, 75)
	gfx.pushContext(groundImage)
		gfx.setLineWidth(8)
		gfx.drawLine(0, 0, 350, 0)
		gfx.drawLine(350, 0, 350, 75)
	gfx.popContext()
	groundSprite = gfx.sprite.new(groundImage)
	groundSprite:setSize(350, 75)
	groundSprite:moveTo(175, 207)
	groundSprite:add()

	force = 0
	isMoving = false
end

function reset()
	carSprite:moveTo(80,120)
	finishSprite:moveTo(250, 270)
	force = 0
	isMoving = false
end

setup()

local modifier = 0.05
local acc = 1.5 -- increase vel by 2 per frame
local dec = 0.3
local vel = 0 -- how much car moves per frame
function pd.update()
	gfx.sprite.update()
	--print(force)
	local ra, ara = pd.getCrankChange()
	force += ra

	if pd.buttonJustReleased(pd.kButtonA) then
		force *= modifier
		isMoving = true
	end
	if isMoving then
		if force <= 5 then
			if vel <= 0 then
				isMoving = false
				endGame()
			end
			vel -= dec
			carSprite:moveTo(carSprite.x + vel, carSprite.y)
		else
			force -= 5
			vel += acc
			carSprite:moveTo(carSprite.x + vel, carSprite.y)
		end
	end

	function endGame()
		if carSprite.x < finishSprite.x then
			print("u lost")
		else
			print("u won")
		end
		reset()
	end
end 