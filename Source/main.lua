import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

-- Sprites
local playerSprite = nil
local playerBullet = nil

-- Bullets
local bulletFired = false
local spriteBullet = {}
local bulletA = false
local bulletB = false
local bulletC = false
local bulletD = false
local timerA = 0
local timerB = 0


-- A function to set up your game environment

function myGameSetup()

    -- display scale 
    playdate.display.setScale(1)

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

    playerBulletA = gfx.sprite.new(playerBulletImage)
    assert(playerBulletA)
    playerBulletB = gfx.sprite.new(playerBulletImage)
    assert(playerBulletB)
    playerBulletC = gfx.sprite.new(playerBulletImage)
    assert(playerBulletC)
    playerBulletD = gfx.sprite.new(playerBulletImage)
    assert(playerBulletD)

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

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.

function playdate.update()

	-- Poll the d-pad and move our player accordingly.
    -- (There are multiple ways to read the d-pad; this is the simplest.)
    -- Note that it is possible for more than one of these directions
    -- to be pressed at once, if the user is pressing diagonally.

    -- Update Timers
    playdate.timer.updateTimers()
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
        
        -- control of left turrents bullets, bullet A and B
        if playerBulletA ~=nil and playerBulletB ~= nil then
            if playdate.buttonJustPressed(playdate.kButtonA) and timerA > 50 then
                -- create bullet A
                if bulletA == false then
                    playerBulletA:moveTo(playerSprite.x+20,playerSprite.y-15)
                    playerBulletA:add()
                    bulletA = true
                    timerA = playdate.timer.new(100)
                end
                 -- create bullet B
                 if bulletB == false then
                    playerBulletB:moveTo(playerSprite.x+20,playerSprite.y-15)
                    playerBulletB:add()
                    bulletB = true
                end
            end

            if playerBulletA.x >= 200 then
                playerBulletA:remove()
                bulletA = false
            elseif bulletA == true then
                playerBulletA:moveBy(4,0)
            end 

            if playerBulletB.x >= 200 then
                playerBulletB:remove()
                bulletB = false
            elseif bulletB == true then
                playerBulletB:moveBy(4,0)
            end

        end
                
        if playerBulletC ~=nil and playerBulletD ~= nil then
            if playdate.buttonJustPressed(playdate.kButtonB) then
               -- create bullet A
               if bulletC == false then
                playerBulletC:moveTo(playerSprite.x+20,playerSprite.y+15)
                playerBulletC:add()
                bulletC = true
                end
                -- create bullet B
                if bulletD == false then
                    playerBulletD:moveTo(playerSprite.x+20,playerSprite.y+15)
                    playerBulletD:add()
                    bulletD = true
                end
            end

            if playerBulletC.x >= 200 then
                playerBulletC:remove()
                bulletC = false
            elseif bulletC == true then
                playerBulletC:moveBy(4,0)
            end 

            if playerBulletD.x >= 200 then
                playerBulletD:remove()
                bulletD = false
            elseif bulletD == true then
                playerBulletD:moveBy(4,0)
            end
           

        end
    end
	-- Call the functions below in playdate.update() to draw sprites and keep
    -- timers updated. (We aren't using timers in this example, but in most
    -- average-complexity games, you will.)

    gfx.sprite.update()
    playdate.timer.updateTimers()
end