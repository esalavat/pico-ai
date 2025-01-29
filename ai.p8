pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
objs={}
function _init()
	pinit()
	print(#objs)
	add(objs,p)
	print(#objs)
end

function _update()
	local i,j=1,1
 while(objs[i]) do
 	print(objs[i].x)
  if objs[i]:update() then
   if(i!=j) objs[j]=objs[i] objs[i]=nil
   j+=1
  else
  	objs[i]=nil
  end
  i+=1
 end
end

function _draw()
	cls(1)
 for o in all(objs) do o:draw() end
end
-->8
--player

p={}

function pinit()
	p={
		x=64,
		y=64,
		speed=2,
		anims={
			{
				action="run",
				frames={
					{
						f=4,
					 fl=false
					},{
						f=6,
						fl=false
					},{
						f=4,
						fl=true
					},{
						f=6,
						fl=true
					}
				},
				speed=2
			},
			{
				action="stand",
				frames={
					{
						f=0,
						fl=false
					},{
					 f=2,
					 fl=false
					}
				},
				speed=20
			}
		},
		c_action="run",
		c_frame=1,
		c_time=0,
		update=pupdate,
		draw=pdraw
	}
end

function pupdate()
	local dx, dy = 0, 0
	
	--update direction
	if btn(⬅️) then dx-=1 end
	if btn(➡️) then dx+=1 end
	if btn(⬆️) then dy-=1 end
	if btn(⬇️) then dy+=1 end

	-- normalize diagonal movement
	if dx ~= 0 and dy ~= 0 then
		dx *= 0.7071
		dy *= 0.7071
	end
	
	--apply movement
	p.x += dx * p.speed
	p.y += dy * p.speed
	
	--update moving flag
	local moving=false
	if dx~=0 or dy~=0 then
		moving=true
	end
	
	--update state
	if(moving) then 
		p.c_action="run"
	else
	 p.c_action="stand"
	end

	--reset time if we're switching animations	
	if p.p_action~=p.c_action then
		p.c_time=0
	end

	--update sprite frame
	local anim=find(p.anims,"action",p.c_action)
	if p.c_time%anim.speed==0 then
		p.c_frame=(p.c_frame%#anim.frames)+1
		p.c_time=0
	end
	
	p.c_time+=1
	p.p_action=p.c_action --save previous action
	
	return true
end

function pdraw()
	printh("c_action: "..p.c_action)
	printh("c_frame: "..p.c_frame)
	
	local anim=find(p.anims,"action",p.c_action)
	local frame=anim.frames[p.c_frame]
	
	printh(frame.f.." "..anim.action)
	
	palt(0, false)  -- ensure color 0 is transparent (default behavior)
	palt(11, true)
	spr(frame.f,p.x,p.y,2,2,frame.fl,false,5)
	palt()
end
-->8
--utils
function find(obj,p,val)
	for o in all(obj) do
		if o[p]==val then
		 return o
		end
	end
end
__gfx__
bbbbbbbbbbbbbbbbbbbbb666666bbbbbbbbbb666666bbbbbbbbbb666666bbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbb666666bbbbbbbbb66666666bbbbbbbb66666666bbbbbbbb66666666bbbb0000000000000000000000000000000000000000000000000000000000000000
bbbb66666666bbbbbbbbdccccccdbbbbbbbbdccccccdbbbbbbbbdccccccdbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbdccccccdbbbbbbbbdccccccdbbbbbbbbdccccccdbbbbbbbbdccccccdbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbdccccccdbbbbbbbbddddddddbbbbbbbbddddddddbbbbbbbbddddddddbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbddddddddbbbbbbbbddddddddbbbbbbbbddddddddbbbbbbbbddddddddbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbddddddddbbbbbbbbbddddddbbbbbbbbbbddddddbbbbbbbbbbddddddbbbbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbddddddbbbbbbb66bbbbbbbb66bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
bb66bbbbbbbb66bbb66dbbbbbbbbd66bbb66bbbbbbbb66bbbb66bbbbbbbb66bb0000000000000000000000000000000000000000000000000000000000000000
b66dbbb66bbbd66bb66bbbb66bbbb66bbb66bbb66bbbd66bbb66bbb66bbbd66b0000000000000000000000000000000000000000000000000000000000000000
b66bbbbddbbbb66bbddbbbbddbbbbddbbb66bbbddbbbb66bbb66bbbddbbbb66b0000000000000000000000000000000000000000000000000000000000000000
bddbbbdbbdbbbddbbbbbbbdbbdbbbbbbbbddbbdbbdbbbddbbbddbbdbbdbbbddb0000000000000000000000000000000000000000000000000000000000000000
bbbb06d00d60bbbbbbbb06d00d60bbbbbbbb06d00dd6bbbbbbbb06d00d60bbbb0000000000000000000000000000000000000000000000000000000000000000
bbb06d0000d60bbbbbb06d0000d60bbbbbb06d0000dd6bbbbbb06d0000d60bbb0000000000000000000000000000000000000000000000000000000000000000
bbb6dd0000dd6bbbbbb6dd0000dd6bbbbbb6dd000000bbbbbbb6dd0000dd6bbb0000000000000000000000000000000000000000000000000000000000000000
bbbbb000000bbbbbbbbbb000000bbbbbbbbbb000000bbbbbbbbbb000000bbbbb0000000000000000000000000000000000000000000000000000000000000000
33333333333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333333333a3333a30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33d33d33333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333003330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333003330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33d33d33333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
333333333a3333a30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
33333333333333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
