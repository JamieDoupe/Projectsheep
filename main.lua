





local physics = require( "physics" )
physics.start()
physics.setDrawMode( "hybrid" )

local Background = display.newImageRect( "Background.png", 360, 570 )
Background.x = display.contentCenterX
Background.y = display.contentCenterY

local platform = display.newImageRect( "platform.png", 300, 50 )
platform.x = display.contentCenterX
platform.y = display.contentHeight-25

local Sheep = display.newImageRect( "Sheep.png", 100, 112 )
Sheep.x = display.contentCenterX
Sheep.y = display.contentCenterY
Sheep.alpha = 0.8

local obstacle = display.newImageRect("wood block.png",50, 80)
obstacle.x =400
obstacle.y =230
obstacle.speed = 1

local obstacle1 = display.newImageRect("wood block.png",50, 80)
obstacle1.x =200
obstacle1.y =230
obstacle1.speed = 1
--At this point, I have created 3 objects, the sheep, the background and the platform.

local function moveobstacle()
    if obstacle.x <-200 then
      obstacle.x =650
    else
      obstacle.x =obstacle.x-obstacle.speed
  
    end
    if obstacle1.x <-200 then
      obstacle1.x =650
    else
      obstacle1.x =obstacle1.x-obstacle1.speed
      end
  end
  
  Runtime:addEventListener("enterFrame", moveobstacle)
  

-- I acidentally made the platform twice below

--local cw, ch = display.actualContentWidth, display.actualContentHeight
--local platform = display.newRect( display.contentCenterX, ch, 0, cw, 40 )
--platform:setFillColor( 0.4, 0.4, 0.8 )
--platform.objType = "platform"
--physics.addBody( platform, "static", { bounce=0.0, friction=0.3 } )

--physics.addBody( platform, "static", {bounce=0} )


physics.addBody( Sheep, "dynamic", { radius=40, bounce=0 } )

--local box={ halfWidth=40, halfHeight=10, x=100, y=70 }
--box:setFillColor(1, 0.2,0.4)

--This is where I have become confused, I seek to create a new box for the sheep's feet, once this box overlaps with the sheep's feet it should allow it to jump
physics.addBody( Sheep, "dynamic",
    { density=1.0, bounce=0.0 },  -- Main body element
    { shape = box, isSensor=true }  -- Foot sensor element, just what the hell does isSensor do?
)
Sheep.isFixedRotation = true

Sheep.sensorOverlaps = 0

local function pushSheep(event)
  if ( event.phase == "began" and Sheep.sensorOverlaps > 0 ) then

  local vx, vy = Sheep:getLinearVelocity()

 Sheep:setLinearVelocity( vx, 0 )
 Sheep:applyLinearImpulse( 0, -0.75, Sheep.x, Sheep.y )
    end
end 
Runtime:addEventListener( "touch", pushSheep )

local function sensorCollide( self, event )
 
    -- Confirm that the colliding elements are the foot sensor and a platform object
    if ( event.selfElement == 2 and event.other.objType == "platform" ) then
 
        -- Foot sensor has entered (overlapped) a platform object
        if ( event.phase == "began" ) then
            self.sensorOverlaps = self.sensorOverlaps + 1
        -- Foot sensor has exited a platform object
        elseif ( event.phase == "ended" ) then
            self.sensorOverlaps = self.sensorOverlaps - 1
        end
    end
end
-- Associate collision handler function with character
Sheep.collision = sensorCollide
Sheep:addEventListener( "collision" )
