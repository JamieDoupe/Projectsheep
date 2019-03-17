





local Background = display.newImageRect( "Background.png", 360, 570 )
Background.x = display.contentCenterX
Background.y = display.contentCenterY

local platform = display.newImageRect( "platform.png", 300, 50 )
platform.x = display.contentCenterX
platform.y = display.contentHeight-25

local Sheep = display.newImageRect( "Sheep.png", 112, 112 )
Sheep.x = display.contentCenterX
Sheep.y = display.contentCenterY
Sheep.alpha = 0.8

local physics = require( "physics" )
physics.start()

physics.addBody( platform, "static", {bounce=0} )
physics.addBody( Sheep, "dynamic", { radius=55, bounce=0 } )


local physics = require( "physics" )
physics.start()
physics.setDrawMode( "hybrid" )

local cw, ch = display.actualContentWidth, display.actualContentHeight
local ground = display.newRect( display.contentCenterX, ch-64, cw, 64 )
ground:setFillColor( 0.4, 0.4, 0.8 )
ground.objType = "ground"
physics.addBody( ground, "static", { bounce=0.0, friction=0.3 } )

local Sheep = display.newRect( display.contentCenterX, ground.y-150, 80, 120 )
Sheep:setFillColor( 1, 0.2, 0.4 )

physics.addBody( Sheep, "dynamic",
    { density=1.0, bounce=0.0 },  -- Main body element
    { box={ halfWidth=30, halfHeight=10, x=0, y=60 }, isSensor=true }  -- Foot sensor element
)
Sheep.isFixedRotation = true
Sheep.sensorOverlaps = 0

local function pushSheep()
  if ( event.phase == "began" and Sheep.sensorOverlaps > 0 ) then

  local vx, vy = Sheep:getLinearVelocity()

 Sheep:setLinearVelocity( vx, 0 )
 Sheep:applyLinearImpulse( 0, -0.75, Sheep.x, Sheep.y )
end

Sheep:addEventListener( "tap", pushSheep )

local function sensorCollide( self, event )
 
    -- Confirm that the colliding elements are the foot sensor and a ground object
    if ( event.selfElement == 2 and event.other.objType == "ground" ) then
 
        -- Foot sensor has entered (overlapped) a ground object
        if ( event.phase == "began" ) then
            self.sensorOverlaps = self.sensorOverlaps + 1
        -- Foot sensor has exited a ground object
        elseif ( event.phase == "ended" ) then
            self.sensorOverlaps = self.sensorOverlaps - 1
        end
    end
end
-- Associate collision handler function with character
Sheep.collision = sensorCollide
Sheep:addEventListener( "collision" )

end