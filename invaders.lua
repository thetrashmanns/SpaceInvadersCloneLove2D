invaders = {}
invaderstwo = {}
invadersthree = {}
invadersDraw = {}
--This creates the invaders
function invaders.load()
  local column = 0
  local row = 1
  while 6 >= row do
    invader = {}
    invader.w = love.graphics.getWidth()/8 - 12
    invader.h = 25
    invader.x = column * (invader.w + 12)
    invader.y = row * (invader.h + 12)
    invader.r = row --Used for determining what invader to draw
    table.insert(invadersDraw, invader)
    column = column + 1
    if column == 8 then
      column = 0
      row = row + 1
    end
  end
end

function invaders.update(dt)
  if moveDown <= 0 then --[[
    ^This is basically a cooldown timer and is general purpose for any cooldown
    you may use (in Love2D). It functions by continuously subtracting the delta
    time (the time between each frame) from the cooldown variable which in this
    case is called moveDown and once the moveDown varible is below or equal to 0
    it will add whatever number to the timer in this case it adds 2.5 and executes
    some code.
    P.S. I don't claim to invent this method, but I can't remember where I got it from
    ]]
    moveDown = moveDown + 2.5
    for i,v in pairs(invadersDraw) do
      v.y = v.y + (750 * dt)
    end
  end
end

function invaderstwo.load()
  local column = 0
  local row = 1
  while 6 >= row do
    invader = {}
    invader.w = love.graphics.getWidth()/8 - 12
    invader.h = 25
    invader.x = column * (invader.w + 12)
    invader.y = row * (invader.h + 12)
    invader.r = row --Used for determining what invader to draw
    invader.hp = 1
    table.insert(invadersDraw, invader)
    column = column + 1
    if column == 8 then
      column = 0
      row = row + 1
    end
  end
end

function invadersthree.load()
  local column = 0
  local row = 1
  while 6 >= row do
    invader = {}
    invader.w = love.graphics.getWidth()/8 - 12
    invader.h = 25
    invader.x = column * (invader.w + 12)
    invader.y = row * (invader.h + 12)
    invader.r = row --Used for determining what invader to draw
    invader.hp = 2
    table.insert(invadersDraw, invader)
    column = column + 1
    if column == 8 then
      column = 0
      row = row + 1
    end
  end
end
--[[
  1st row Y = 37
  2nd row Y = 74
  3rd row Y = 111
  4th row Y = 148
  5th row Y = 185
  6th row Y = 222
]]
