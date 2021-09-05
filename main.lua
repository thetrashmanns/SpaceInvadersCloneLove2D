--[[
A Space Invaders Clone by Logan Connolly
Made using Love2D 11.3 and LoveFrames 11.3
And before we start this makes heavy use of LoveFrame's
state system
Copyright (c) 2014 Kenny Shields

This software is provided 'as-is', without any express or implied warranty.
In no event will the authors be held liable for any damages arising from
the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
claim that you wrote the original software. If you use this software in a
product, an acknowledgment in the product documentation would be
appreciated but is not required.

2. Altered source versions must be plainly marked as such, and must not
be misrepresented as being the original software.

3. This notice may not be removed or altered from any source
distribution.
^LoveFrames Stuff
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
    shootCooldown = 0
    points = 0
    lost = false
    won = false
    require ("collision")
    require ("invaders")
    lasers = {}
    love.window.setMode(800, 600)
    loveframes.SetState("mainmenu")
    local startButton = loveframes.Create("button")
    startButton:SetState("mainmenu")
    startButton:SetPos(320, 288)
    startButton:SetText("Start")
    startButton:SetWidth(170)
    startButton.OnClick = function(object, x, y)
      invaders.load()
      previousState = "mainmenu"
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
      points = 0
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
      run = run + 1
      previousState = "win"
      if run == 1 then
        invadersDraw = {}
        loveframes.SetState("lvl2")
        invaderstwo.load()
      elseif run == 2 then
        invadersDraw = {}
        loveframes.SetState("lvl3")
        invadersthree.load()
      end
      won = false
      lost = false
    end
    local quitGameW = loveframes.Create("button")
    quitGameW:SetState("win")
    quitGameW:SetPos(320, 348)
    quitGameW:SetText("Quit the game.")
    quitGameW:SetWidth(170)
    quitGameW.OnClick = function(object, x, y)
      love.event.quit()
    end
    local returnMain = loveframes.Create("button")
    returnMain:SetState("win")
    returnMain:SetPos(320, 318)
    returnMain:SetText("Return to Main Menu.")
    returnMain:SetWidth(170)
    returnMain.OnClick = function(object, x, y)
      love.load()
    end
  end

  function love.update(dt)
    local state = loveframes.GetState()
    if state == "game" or state == "lvl2" or state == "lvl3" then
      moveDown = moveDown - dt
      shootCooldown = shootCooldown - dt
      player.x = player.x + (player.xs * dt)
      checkWalls()
      checkLaser()
      for i,v in ipairs(lasers) do
        v.x = v.x + (v.dx * dt)
        v.y = v.y - (v.dy * dt)
      end
      invaders.update(dt)
    end
    loveframes.update(dt)
  end

  function love.draw()
    local state = loveframes.GetState()
    if state == "mainmenu" then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(logo, 275, 0)
    end
    if state == "lose" then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(losetitle, 320, 0)
    end
    if state == "win" then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(wintitle, 320, 0)
      love.graphics.print("Current Score: " .. points, 350, 120)
    end
    if state == "game" or state == "pause" or state == "lvl2" or state == "lvl3" then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(playeri, player.x, player.y)
      for i,v in ipairs(lasers) do
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.draw(laser, v.x, v.y)
      end
      for j,b in ipairs(invadersDraw) do
        if v.r == 1 then --[[eLsE iF anyways this elseif chain determines which invader to draw,
          based upon which row it's on
          ]]
          love.graphics.setColor(0.54, 0.67, 1, 1)
          love.graphics.draw(invader1, b.x + 10, b.y)
        elseif v.r == 2 then
          love.graphics.setColor(0.54, 0.67, 1, 1)
          love.graphics.draw(invader1f2, b.x + 10, b.y)
        elseif v.r == 3 then
          love.graphics.setColor(1, 0.74, 0.28, 1)
          love.graphics.draw(invader2, b.x + 16, b.y)
        elseif v.r == 4 then
          love.graphics.setColor(1, 0.74, 0.28, 1)
          love.graphics.draw(invader2f2, b.x + 16, b.y)
        elseif v.r == 5 then
          love.graphics.setColor(1, 0, 0, 1)
          love.graphics.draw(invader3, b.x + 10, b.y)
        else
          love.graphics.setColor(1, 0, 0, 1)
          love.graphics.draw(invader3f2, b.x + 10, b.y)
        end
      end
      love.graphics.setColor(0, 1, 0, 1)
      love.graphics.print("Points: " .. points, 0, 0)
    end
    loveframes.draw()
  end

  function love.mousepressed(x, y, button)
    local state = loveframes.GetState()
    if state == "game" or state == "lvl2" or state == "lvl3" then
      if button == 1 and shootCooldown <= 0 then
        shootCooldown = shootCooldown + 0.75
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
    local state = loveframes.GetState()
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
      if previousState == "mainmenu" then
        loveframes.SetState("game")
      elseif previousState == "win" and run < 2 then
        loveframes.SetState("lvl2")
      elseif previousState == "win" and run >= 2 then
        loveframes.SetState("lvl3")
      end
    end
    loveframes.keypressed(key, isrepeat)
  end

  function love.keyreleased(key)
    local state = loveframes.GetState()
    if key == "a" or key == "d" then
      player.xs = 0
    end
    loveframes.keyreleased(key)
  end

  function love.textinput(text)
    loveframes.textinput(text)
  end
