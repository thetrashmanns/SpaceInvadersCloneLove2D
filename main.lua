--[[
A Space Invaders Clone by Logan Connolly
Made using Love2D 11.3 and LoveFrames 11.3
And before we start this makes heavy use of LoveFrame's
state system
]]
  function love.load()
    loveframes = require("gui.loveframes")
    playeri = love.graphics.newImage("player.png")
    laser = love.graphics.newImage("laser.png")
    invader1 = love.graphics.newImage("invaderp1.png")
    invader1f2 = love.graphics.newImage("invaderp1f2.png")
    invader2 = love.graphics.newImage("invader2.png")
    invader2f2 = love.graphics.newImage("invader2f2.png")
    invader3 = love.graphics.newImage("invader3.png")
    invader3f2 = love.graphics.newImage("invader3f2.png")
    logo = love.graphics.newImage("logo.png")
    wintitle = love.graphics.newImage("win.png")
    losetitle = love.graphics.newImage("lose.png")
    gainpoint = love.audio.newSource("gainpoint.wav", "static")
    lose = love.audio.newSource("lose.mp3", "static")
    win = love.audio.newSource("win.mp3", "static")
    player = {
      x = love.graphics.getWidth()/2 - 45,
      y = love.graphics.getHeight() - 40,
      w = 90,
      h = 40,
      xs = 0
    }
    run = 0
    moveDown = 0
    points = 0
    lost = false
    won = false
    require ("collision")
    require ("invaders")
    lasers = {}
    invaders.load()
    loveframes.SetState("mainmenu")
    local startButton = loveframes.Create("button")
    startButton:SetState("mainmenu")
    startButton:SetPos(320, 288)
    startButton:SetText("Start")
    startButton:SetWidth(170)
    startButton.OnClick = function(object, x, y)
      loveframes.SetState("game")
    end
    local quitButton = loveframes.Create("button")
    quitButton:SetState("mainmenu")
    quitButton:SetPos(startButton:GetX(), startButton:GetY() + 30)
    quitButton:SetText("Quit")
    quitButton:SetWidth(170)
    quitButton.OnClick = function(object, x, y)
      love.event.quit()
    end
    local newGameL = loveframes.Create("button")
    newGameL:SetState("lose")
    newGameL:SetPos(320, 288)
    newGameL:SetText("Return to main menu.")
    newGameL:SetWidth(170)
    newGameL.OnClick = function(object, x, y)
      loveframes.SetState("mainmenu")
      invadersDraw = {}
      invaders.load()
    end
    local quitGameL = loveframes.Create("button")
    quitGameL:SetState("lose")
    quitGameL:SetPos(320, 318)
    quitGameL:SetText("Quit the game.")
    quitGameL:SetWidth(170)
    quitGameL.OnClick = function(object, x, y)
      love.event.quit()
    end
    local newGameW = loveframes.Create("button")
    newGameW:SetState("win")
    newGameW:SetPos(320, 288)
    newGameW:SetText("Continue")
    newGameW:SetWidth(170)
    newGameW.OnClick = function(object, x, y)
      loveframes.SetState("lvl2")
      invadersDraw = {}
      invaderstwo.load()
      won = false
      lost = false
      run = run + 1
    end
    local quitGameW = loveframes.Create("button")
    quitGameW:SetState("win")
    quitGameW:SetPos(320, 318)
    quitGameW:SetText("Quit the game.")
    quitGameW:SetWidth(170)
    quitGameW.OnClick = function(object, x, y)
      love.event.quit()
    end
  end

  function love.update(dt)
    if loveframes.GetState() == "game" or loveframes.GetState() == "lvl2" then
      moveDown = moveDown - dt
      player.x = player.x + (player.xs * dt)
      checkWalls()
      checkBullet()
      for i,v in ipairs(lasers) do
        v.x = v.x + (v.dx * dt)
        v.y = v.y - (v.dy * dt)
      end
      invaders.update(dt)
    end
    loveframes.update(dt)
  end

  function love.draw()
    if loveframes.GetState() == "mainmenu" then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(logo, 275, 0)
    end
    if loveframes.GetState() == "lose" then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(losetitle, 320, 0)
    end
    if loveframes.GetState() == "win" then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(wintitle, 320, 0)
      love.graphics.print("Current Score: " .. points, 350, 120)
    end
    if loveframes.GetState() == "game" or loveframes.GetState() == "pause" or loveframes.GetState() == "lvl2" then
      love.graphics.draw(playeri, player.x, player.y)
      for i,v in ipairs(lasers) do
        love.graphics.draw(laser, v.x, v.y)
      end
      for i,v in ipairs(invadersDraw) do
        if v.r == 1 then --[[eLsE iF anyways this elseif chain determines which invader to draw,
          based upon which row it's on
          ]]
          love.graphics.setColor(0.54, 0.67, 1, 1)
          love.graphics.draw(invader1, v.x + 10, v.y)
        elseif v.r == 2 then
          love.graphics.setColor(0.54, 0.67, 1, 1)
          love.graphics.draw(invader1f2, v.x + 10, v.y)
        elseif v.r == 3 then
          love.graphics.setColor(1, 0.74, 0.28, 1)
          love.graphics.draw(invader2, v.x + 16, v.y)
        elseif v.r == 4 then
          love.graphics.setColor(1, 0.74, 0.28, 1)
          love.graphics.draw(invader2f2, v.x + 16, v.y)
        elseif v.r == 5 then
          love.graphics.setColor(1, 0, 0, 1)
          love.graphics.draw(invader3, v.x + 10, v.y)
        elseif v.r == 6 then
          love.graphics.setColor(1, 0, 0, 1)
          love.graphics.draw(invader3f2, v.x + 10, v.y)
        end
      end
      love.graphics.setColor(0, 1, 0, 1)
      love.graphics.print("Points: " .. points, 0, 0)
    end
    loveframes.draw()
  end

  function love.mousepressed(x, y, button)
    if loveframes.GetState() == "game" or loveframes.GetState() == "lvl2" then
      if button == 1 then
        local laser = {}
        laser.x = player.x + 45
        laser.y = player.y - 40
        laser.dx = 0
        laser.dy = 160
        table.insert(lasers, laser)
      end
    end
    loveframes.mousepressed(x, y, button)
  end

  function love.mousereleased(x, y, button)
    loveframes.mousereleased(x, y, button)
  end

  function love.keypressed(key, scancode, isrepeat)
    if scancode == "d" then
      if player.xs <= 160 then
        player.xs = 0
        player.xs = player.xs + 160
      end
    end
    if scancode == "a" then
      if player.xs >= -160 then
        player.xs = 0
        player.xs = player.xs - 160
      end
    end
    if scancode == "escape" then
      loveframes.SetState("pause")
    end
    if scancode == "r" then
      loveframes.SetState("game")
    end
    loveframes.keypressed(key, isrepeat)
  end

  function love.keyreleased(key)
    if key == "a" or key == "d" and loveframes.GetState() == "game" or loveframes.GetState() == "lvl2" then
      player.xs = 0
    end
    loveframes.keyreleased(key)
  end

  function love.textinput(text)
    loveframes.textinput(text)
  end
