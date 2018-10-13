playerImg=image.new(_R.IMG.img_1)

cubesX={1,5,7,6,4,6,4,1,3,2,3,7,8,9,1,2,3,4,2,6,7,1,9,1,2,3,4}
cubesY={1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9}
lastCube=1
player=0
speed=0.08                                                --default speed
moving=false
dir=1
moveStart=0                                               --default position
menu=true
score=0                                                   --preset score
level=1                                                   --preset level
rotation=50                                               --this makes the screen continuously rotate for some reason
lastTick=0
delay=0                                                   --default timer time(delay)

function render(gc)
 drawHorizon(gc)
 local size,x,y,i,polygon
 for j=1,27 do
  i=(j+lastCube-2)%27+1
  size=100/(10-cubesY[i])
  x=(cubesX[i]-7-player)/(10-cubesY[i])*150-size/2
  y=5/(10-cubesY[i])*50-180
  polygon=rotate({x,y,x+size,y,x+size,y+size,x,y+size,x,y})
  if cubesY[i]>1 and y+size<platform.window.height() then              --Critor: fillPolygon and drawPolyLine return "value out of range" if y is too high, unlike drawLine
   gc:setColorRGB(math.random(255),math.random(255),math.random(255))  --set cube color to random
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
   var.store("highscore",score)                           --store the highscore if the current score is higher than the previously stored highscore
   document.markChanged()
  end
  local str="Score : "..tostring(score).."              Highscore : "..tostring(highscore)
  gc:drawString(str,159-gc:getStringWidth(str)/2,100,"top")
 end
end

--Drawing score
function drawScore(gc)
 if not menu then                                         --draw score when game is playing
  gc:setColorRGB(0,0,0)                                   --set score letter color black
  gc:setFont("sansserif","r",12)                          --set letter type sansserif, regular, size 12
  gc:drawString(tostring(math.floor(score)),2,0,"top")    --draw score on the top left corner
  if score%1000>950 then                                  --draw "Speed Up !" when the score is between 950 and 1000
   gc:setFont("sansserif","r",30)
   gc:drawString("Speed Up !",80,10,"top")
  end
 end
end

--Leveling up
function levelUp()
 speed=speed+0.01                                         --increase speed by 0.01
 level=level+1                                            --increase level by 1
 score=score+50                                           --increase score by 50
end

function on.paint(gc)
 render(gc)
 drawPlayer(gc)
 drawMenu(gc)
 drawScore(gc)
 gc:setColorRGB(0,0,0)
 gc:setFont("sansserif","r",8)
 updateFPS()
 timer.start(0.01)
end

acc = 0                                                   --Critor's accelerometer

function on.timer()
 local tacc = math.eval("getacc()")                       --Critor's accelerometer
 if tacc~=nil then                                        --Critor's accelerometer
  acc = tacc                                              --Critor's accelerometer
 end                                                      --Critor's accelerometer
 if acc<-2 then on.arrowLeft() end                        --Critor's accelerometer
 if acc>2 then on.arrowRight() end                        --Critor's accelerometer
 timer.stop()
 updateCubes()
 updateMove()
 if not menu then
  score=score+(math.sqrt(delay))*2*speed                  --update score by adding the preexisting score to the square root of the delay times 2 times the speed
  if score>level*1000 then
   levelUp()
  end
 end
 platform.window:invalidate()
end

--Game start (pressing enter at the main menu)
function on.enterKey()
 if menu then
  menu=false                                              --leave menu
  speed=0.08                                              --set speed at 0.08
  moving=false
  rotation=0                                              --set rotation at 0 to prevent the screen from continuously rotating
  score=0                                                 --start with score 0
  level=1                                                 --set level at 1
  for i=1,27 do
   cubesY[i]=cubesY[i]-5
  end
 end
end

--Turning to the left
function on.arrowLeft()
 if not menu then
  dir=-1                                                  --go to the left by 1
  moving=true
  moveStart=timer.getMilliSecCounter()
 end
end

--Turning to the right
function on.arrowRight()
 if not menu then
  dir=1                                                   --go to the right by 1
  moving=true
  moveStart=timer.getMilliSecCounter()
 end
end

--Increasing speed
function on.arrowUp()
 if not menu then
  speed=speed+0.01                                        --increase speed by 0.01
 end
end

--Decreasing speed
function on.arrowDown()
 if not menu then
  if speed<0.08+(level*0.01) then
   speed=speed                                            --maintain speed to prevent going backwards
  else
   speed=speed-0.01                                       --decrease speed by 0.01
  end
 end
end

function on.charIn(ch)
 if ch=="6" then
  on.arrowRight()
 elseif ch=="4" then
  on.arrowLeft()
 elseif ch=="8" then
  on.arrowUp()
 elseif ch=="5" then
  on.arrowDown()
 end
end

function updateFPS()
 delay=timer.getMilliSecCounter()-lastTick
 delay=delay<300 and delay or 0
 lastTick=timer.getMilliSecCounter()
end