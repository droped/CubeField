playerImg=image.new("\020\000\000\000\020\000\000\000\000\000\000\000(\000\000\000\016\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\000\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\128\000\128\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\000\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\128\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\128\000\128\000\128")

cubesX={1,5,7,6,4,6,4,1,3,2,3,7,8,9,1,2,3,4,2,6,7,1,9,1,2,3,4}
cubesY={1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9}
lastCube=1
player=0
speed=0.08
moving=false
dir=1
moveStart=0
menu=true
score=0
level=1
color={225,170,0}
rotation=0
lastTick=0
delay=0

function render(gc)
 drawHorizon(gc)
 local size,x,y,i,polygon
 for j=1,27 do
  i=(j+lastCube-2)%27+1
  size=100/(10-cubesY[i])
  x=(cubesX[i]-7-player)/(10-cubesY[i])*150-size/2
  y=5/(10-cubesY[i])*50-180
  polygon=rotate({x,y,x+size,y,x+size,y+size,x,y+size,x,y})
  if cubesY[i]>1 and y+size<platform.window.height() then -- Critor: fillPolygon and drawPolyLine return "value out of range" if y is too high, unlike drawLine
   gc:setColorRGB(color[1],color[2],color[3])
   gc:fillPolygon(polygon)
   gc:setColorRGB(0,0,0)
   gc:drawPolyLine(polygon)
  end
  if y+size>3 and y<17 then
   if x<6 and x+size>-6 then
    menu=true
    score=math.floor(score)
   end
  end
 end
end

function rotate(p)
 local s,c=math.sin(rotation),math.cos(rotation)
 return {p[1]*c-p[2]*s+159,p[1]*s+p[2]*c+202,p[3]*c-p[4]*s+159,p[3]*s+p[4]*c+202,p[5]*c-p[6]*s+159,p[5]*s+p[6]*c+202,p[7]*c-p[8]*s+159,p[7]*s+p[8]*c+202,p[9]*c-p[10]*s+159,p[9]*s+p[10]*c+202}
end

function updateCubes()
 local step=menu and 0.06 or speed
 for i=1,27 do
  cubesY[i]=cubesY[i]+step*delay/30
  if cubesY[i]>10 then
   if score%1000<800 then
    cubesX[i]=math.random(0,140)/10+player
   else
    cubesX[i]=math.random(0,140)/200+player+(i-1)%2*5+4.1
   end
   cubesY[i]=cubesY[i]-9
   lastCube=lastCube==1 and 27 or lastCube-1
  end
 end
end

function updateMove()
 if moving then
  player=player+0.07*dir*delay/30
  if math.abs(rotation)<0.15 or dir==rotation/math.abs(rotation) then
   rotation=rotation-0.005*dir*delay/30
  end
  if timer.getMilliSecCounter()-moveStart>=150 then
   moving=false
  end
 else
  if math.abs(rotation)>0.005 then
   rotation=rotation-0.005*rotation/math.abs(rotation)*delay/30
  end
 end
end

function drawPlayer(gc)
 if not menu then
  gc:drawImage(playerImg,149,192)
 end
end

function drawHorizon(gc)
 local s,c=math.sin(rotation),math.cos(rotation)
 gc:setColorRGB(0,0,0)
 gc:drawLine(s*142-c*200+159,202-c*142-s*200,c*200+s*142+159,s*200-c*142+202)
end

function drawMenu(gc)
 if menu then
  gc:setColorRGB(0,0,0)
  gc:setFont("sansserif","r",30)
  gc:drawString("CubeField",80,10,"top")
  gc:setFont("sansserif","b",12)
  gc:drawString("Press Enter",115,150,"top")
  local highscore=var.recall("highscore")
  if not highscore then
   var.store("highscore",0)
   highscore=0
  end
  if score>highscore then
   var.store("highscore",score)
   document.markChanged()
  end
  local str="Score : "..tostring(score).."              Highscore : "..tostring(highscore)
  gc:drawString(str,159-gc:getStringWidth(str)/2,100,"top")
 end
end

function drawScore(gc)
 if not menu then
  gc:setColorRGB(0,0,0)
  gc:setFont("sansserif","r",12)
  gc:drawString(tostring(math.floor(score)),2,0,"top")
  if score%1000>950 then
   gc:setFont("sansserif","r",30)
   gc:drawString("Speed Up !",80,10,"top")
  end
 end
end

function levelUp()
 speed=speed+0.02
 level=level+1
 if (level-1)%5==0 then
  color={225,170,0}
 elseif (level-1)%5==1 then
  color={0,0,255}
 elseif (level-1)%5==2 then
  color={100,100,100}
 elseif (level-1)%5==3 then
  color={90,255,0}
 elseif (level-1)%5==4 then
  color={255,255,255}
 end
end

function on.paint(gc)
 render(gc)
 drawPlayer(gc)
 drawMenu(gc)
 drawScore(gc)
 gc:setColorRGB(0,0,0)
 gc:setFont("sansserif","r",8)
 gc:drawString("Lua CubeField - Par Loic Pujet",10,200,"top")
 updateFPS()
 timer.start(0.01)
end

acc = 0 -- Critor's accelerometer

function on.timer()
 local tacc = math.eval("getacc()")     -- Critor's accelerometer
 if tacc~=nil then                      -- Critor's accelerometer
  acc = tacc                            -- Critor's accelerometer
 end                                    -- Critor's accelerometer
 if acc<-2 then on.arrowLeft() end      -- Critor's accelerometer
 if acc>2 then on.arrowRight() end      -- Critor's accelerometer
 timer.stop()
 updateCubes()
 updateMove()
 if not menu then
  score=score+delay/30
  if score>level*1000 then
   levelUp()
  end
 end
 platform.window:invalidate()
end

function on.enterKey()
 if menu then
  menu=false
  speed=0.08
  moving=false
  score=0
  level=1
  color={225,170,0}
  for i=1,27 do
   cubesY[i]=cubesY[i]-5
  end
 end
end

function on.arrowLeft()
 if not menu then
  dir=-1
  moving=true
  moveStart=timer.getMilliSecCounter()
 end
end

function on.arrowRight()
 if not menu then
  dir=1
  moving=true
  moveStart=timer.getMilliSecCounter()
 end
end

function on.charIn(ch)
 if ch=="6" then
  on.arrowRight()
 elseif ch=="4" then
  on.arrowLeft()
 end
end

function updateFPS()
 delay=timer.getMilliSecCounter()-lastTick
 delay=delay<300 and delay or 0
 lastTick=timer.getMilliSecCounter()
end