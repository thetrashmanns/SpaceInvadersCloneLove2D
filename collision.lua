function checkWalls()
  if player.x + player.w >= love.graphics.getWidth() then
    player.x = love.graphics.getWidth() - player.w
  end
  if player.x <= 0 then
    player.x = 0
  end
  for i,v in ipairs(lasers) do
    if v.y <= 0 then
      table.remove(lasers, i)
    end
  end
  for j,b in ipairs(invadersDraw) do
    if b.y + b.h >= player.y and not won then
      loveframes.SetState("lose")
      love.audio.play(lose)
      lost = true
    end
  end
end
--[[
My mess :) only because I'm a beginner who is self taught lol
Anyways this detects if a laser hit an invader and if the player
has killed all of the invaders it moves to level 2
Please note: Adding another level isn't modular AT ALL so be
ready to spend sometime doing so but I'm working on making
it modular
]]
function checkLaser()
  for i,v in ipairs(lasers) do
    local laserX = v.x
    local laserY = v.y
    local laserW = 5
    local laserH = 35
    for j,b in ipairs(invadersDraw) do
      if b.r == 3 or b.r == 4 then
        invaderW = 80
        invaderH = 19
      else
        invaderW = 81
        invaderH = 25
      end
      if b.r == 1 or b.r == 2 or b.r == 5 or b.r == 6 then
        invaderX = b.x + 10
      else
        invaderX = b.x + 16
      end
      local invaderY = b.y
      if laserX < invaderX + invaderW and invaderX < laserX + laserW then
        if laserY < invaderY + invaderH and invaderY < laserY + laserH then
          if loveframes.GetState() == "game" then
            table.remove(lasers, i)
            table.remove(invadersDraw, j)
            love.audio.play(gainpoint)
            if b.r <= 2 then
              points = points + 1
            elseif b.r <= 4 then
              points = points + 2
            else
              points = points + 3
            end
          elseif loveframes.GetState() == "lvl2" then
            if b.hp >= 1 then
              table.remove(lasers, i)
              love.audio.play(gainpoint)
              b.hp = b.hp - 1
              if b.r <= 2 then
                points = points + 1
              elseif b.r <= 4 then
                points = points + 2
              else
                points = points + 3
              end
            elseif b.hp <= 0 then
              love.audio.play(gainpoint)
              table.remove(lasers, i)
              table.remove(invadersDraw, j)
              if b.r <= 2 then
                points = points + 1
              elseif b.r <= 4 then
                points = points + 2
              else
                points = points + 3
              end
            end
          end
        end
      end
    end
  end
  if #invadersDraw <= 0 and not lost then
    love.audio.play(win)
    loveframes.SetState("win")
    won = true
  end
end
