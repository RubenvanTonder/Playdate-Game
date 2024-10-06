import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

local playerSprite = nil
local playerBullet = nil
local bulletFiredTimer = nil
local bulletFired = false
local spriteBullet = {}


-- Class for sprite bullet
function spriteBullet:new(x,y)
    self.__index = self
    self.x = x or 0
    self.y = y or 0
end



-- A function to set up your game environment

function myGameSetup()

	-- Set up the player sprite

	local playerImage = gfx.image.new("Images/playerImage")
	assert(playerImage) -- raises error if value assignment is false

	playerSprite = gfx.sprite.new(playerImage)
    assert(playerSprite)
	playerSprite:moveTo(200,120) -- place sprite to centre
	playerSprite:add()

    -- Assing bullet sprite
    local playerBulletImage = gfx.image.new("Images/bullet")
    assert(playerBulletImage)

    playerBullet = gfx.sprite.new(playerBulletImage)


	-- We want an environment displayed behind our sprite.
    -- There are generally two ways to do this:
    -- 1) Use setBackgroundDrawingCallback() to draw a background image. (This is what we're doing below.)
    -- 2) Use a tilemap, assign it to a sprite with sprite:setTilemap(tilemap),
    --       and call :setZIndex() with some low number so the background stays behind
    --       your otherd sprites.

	local backgroundImage = gfx.image.new("Images/background")
	assert(backgroundImage)

	gfx.sprite.setBackgroundDrawingCallback(
		function (x,y,width,height)
			-- x,y,width,height is the updated area in sprite-local coordinates
            -- The clip rect is already set to this area, so we don't need to set it ourselves
			backgroundImage:draw(0,0)
		end
	)
end

-- Now we'll call the function above to configure our game.
-- After this runs (it just runs once), nearly everything will be
-- controlled by the OS calling `playdate.update()` 30 times a second.

myGameSetup()

-- Start a timer
local timer = playdate.timer

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.

function playdate.update()

	-- Poll the d-pad and move our player accordingly.
    -- (There are multiple ways to read the d-pad; this is the simplest.)
    -- Note that it is possible for more than one of these directions
    -- to be pressed at once, if the user is pressing diagonally.

    -- Update Timers

    if (playerSprite ~= nil) then
        
        if playdate.buttonIsPressed( playdate.kButtonUp ) then
            playerSprite:moveBy( 0, -2 )
        end
        if playdate.buttonIsPressed( playdate.kButtonRight ) then
            playerSprite:moveBy( 2, 0 )
        end
        if playdate.buttonIsPressed( playdate.kButtonDown ) then
            playerSprite:moveBy( 0, 2 )
        end
        if playdate.buttonIsPressed( playdate.kButtonLeft ) then
            playerSprite:moveBy( -2, 0 )
        end

        if (playerBullet ~= nil ) then
            if (playdate.buttonIsPressed(playdate.kButtonA) and ((playdate.timer.currentTime - bulletFiredTimer)>1)) then
                playerBullet:moveTo(playerSprite.x+20,playerSprite.y-15)
                playerBullet:add()
                bulletFiredTimer = timer.start()
                bulletfired = true
            end
            if bulletFired == true and playdate.buttonIsPressed(playdate.kButtonB) then
                playerBullet:moveBy(1,0)
                
            end
        end
    end

    

	-- Call the functions below in playdate.update() to draw sprites and keep
    -- timers updated. (We aren't using timers in this example, but in most
    -- average-complexity games, you will.)

    gfx.sprite.update()
    playdate.timer.updateTimers()
end