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
				action="run_s",
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
			},{
				action="run_n",
				frames={
					{
						f=38,
					 fl=false
					},{
						f=40,
						fl=false
					},{
						f=38,
						fl=true
					},{
						f=40,
						fl=true
					}
				},
				speed=2
			},{
				action="run_e",
				frames={
					{
						f=12,
					 fl=false
					},{
						f=14,
						fl=false
					},{
						f=42,
						fl=false
					},{
						f=44,
						fl=false
					}
				},
				speed=2
			},{
				action="run_w",
				frames={
					{
						f=12,
					 fl=true
					},{
						f=14,
						fl=true
					},{
						f=42,
						fl=true
					},{
						f=44,
						fl=true
					}
				},
				speed=2
			},{
				action="stand_s",
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
			},{
				action="stand_n",
				frames={
					{
						f=34,
						fl=false
					},{
					 f=36,
					 fl=false
					}
				},
				speed=20
			},{
				action="stand_e",
				frames={
					{
						f=8,
						fl=false
					},{
					 f=10,
					 fl=false
					}
				},
				speed=20
			},{
				action="stand_w",
				frames={
					{
						f=8,
						fl=true
					},{
					 f=10,
					 fl=true
					}
				},
				speed=20
			}
		},
		c_action="stand_s",
		c_frame=1,
		c_time=0,
		l_dir="s",
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
	
	--update direction
	local dirx,diry
	if dx>0 then
		dirx="e"
	elseif dx<0 then
	 dirx="w"
	else
	 dirx=nil
	end
	
	if dy>0 then
	 diry="s"
	elseif dy<0 then
	 diry="n"
	else
	 diry=nil
	end
	
	--update state
	if dirx==nil and diry==nil then 
		p.c_action="stand_"..p.l_dir
	else 
	 p.l_dir=(diry or dirx)
	 p.c_action="run_"..p.l_dir
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
bbbbbbbbbbbbbbbbbbbbb666666bbbbbbbbbbbbbbbbbbbbbbbbbb666666bbbbbbbbbbbbbbbbbbbbbbbbbbb66666bbbbbbbbbbbbbbbbbbbbbbbbbbb66666bbbbb
bbbbb666666bbbbbbbbb66666666bbbbbbbbb666666bbbbbbbbb66666666bbbbbbbbbb66666bbbbbbbbbb6666666bbbbbbbbbb66666bbbbbbbbbb6666666bbbb
bbbb66666666bbbbbbbbdccccccdbbbbbbbb66666666bbbbbbbbdccccccdbbbbbbbbb6666666bbbbbbbbbddddcccbbbbbbbbb6666666bbbbbbbbbddddcccbbbb
bbbbdccccccdbbbbbbbbdccccccdbbbbbbbbdccccccdbbbbbbbbdccccccdbbbbbbbbbddddcccbbbbbbbbbddddcccbbbbbbbbbddddcccbbbbbbbbbddddcccbbbb
bbbbdccccccdbbbbbbbbddddddddbbbbbbbbdccccccdbbbbbbbbddddddddbbbbbbbbbddddcccbbbbbbbbbdddddddbbbbbbbbbddddcccbbbbbbbbbdddddddbbbb
bbbbddddddddbbbbbbbbddddddddbbbbbbbbddddddddbbbbbbbbddddddddbbbbbbbbbdddddddbbbbbbbbbdddddddbbbbbbbbbdddddddbbbbbbbbbdddddddbbbb
bbbbddddddddbbbbbbbbbddddddbbbbbbbbbddddddddbbbbbbbbbddddddbbbbbbbbbbdddddddbbbbbbbbbbdddddbbbbbbbbbbdddddddbbbbbbbbbbdddddbbbbb
bbbbbddddddbbbbbbb66bbbbbbbb66bbbbbbbddddddbbbbbbbbbbbbbbbbbbbbbbbbbbbdddddbbbbbbbbbbbbbbbbbbbbbbbbbbbdddddbbbbbbbbbbbbbbbbbbbbb
bb66bbbbbbbb66bbb66dbbbbbbbbd66bbb66bbbbbbbb66bbbb66bbbbbbbb66bbbbbbbbbbbbbbbbbbbbbbbbbb66bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb
b66dbbb66bbbd66bb6dbbbb66bbbbd6bbb66bbb66bbbd66bbb66bbb66bbbd66bbbbbbbbd66bbbbbbbbbbbbbddd6bbbbbbbbbb6b66b66bbbbbbbbb6b66b66bbbb
b6dbbbbddbbbbd6bbddbbbbddbbbbddbbb6dbbbddbbbbd6bbb6dbbbddbbbbd6bbbbbbbbddd6bbbbbbbbbbbbddddbbbbbbbbb6dbddbbd6bbbbbbb6dbddbbd6bbb
bddbbbdbbdbbbddbbbbbbbdbbdbbbbbbbbddbbdbbdbbbddbbbddbbdbbdbbbddbbbbbbbbddddbbbbbbbbbbbbddbbbbbbbbbbbddbdddbddbbbbbbbddbddbbddbbb
bbbb06d00d60bbbbbbbb06d00d60bbbbbbbb06d00dd6bbbbbbbb06d00d60bbbbbbbbbb0dd00bbbbbbbbbbb0dd00bbbbbbbbbbb6ddd6bbbbbbbbbbb0dd00bbbbb
bbb06d0000d60bbbbbb06d0000d60bbbbbb06d0000dd6bbbbbb06d0000d60bbbbbbbb00dd600bbbbbbbbb00dd600bbbbbbbbb0d60dd6bbbbbbbbb00dd600bbbb
bbb6dd0000dd6bbbbbb6dd0000dd6bbbbbb6dd000000bbbbbbb6dd0000dd6bbbbbbbb000dd60bbbbbbbbb000dd60bbbbbbbbb0d60000bbbbbbbbb000dd60bbbb
bbbbb000000bbbbbbbbbb000000bbbbbbbbbb000000bbbbbbbbbb000000bbbbbbbbbbb00000bbbbbbbbbbb00000bbbbbbbbbbb00000bbbbbbbbbbb00000bbbbb
bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb666666bbbbbbbbbbbbbbbbbbbbbbbbbb666666bbbbbbbbbbbbbbbbbbbbbbbbbbb66666bbbbb0000000000000000
bbbbbbbbbbabbabbbbbbb666666bbbbbbbbb66666666bbbbbbbbb666666bbbbbbbbb66666666bbbbbbbbbb66666bbbbbbbbbb6666666bbbb0000000000000000
bbdbbdbbbbb00bbbbbbb66666666bbbbbbbbd666666dbbbbbbbb66666666bbbbbbbbd666666dbbbbbbbbb6666666bbbbbbbbbddddcccbbbb0000000000000000
bbbbbbbbbba00bbbbbbbd666666dbbbbbbbbddddddddbbbbbbbbd666666dbbbbbbbbddddddddbbbbbbbbbddddcccbbbbbbbbbddddcccbbbb0000000000000000
bbbbbbbbbbb00abbbbbbddddddddbbbbbbbbddddddddbbbbbbbbddddddddbbbbbbbbddddddddbbbbbbbbbddddcccbbbbbbbbbdddddddbbbb0000000000000000
bbdbbdbbbbb00bbbbbbbddddddddbbbbbbbbddddddddbbbbbbbbddddddddbbbbbbbbddddddddbbbbbbbbbdddddddbbbbbbbbbdddddddbbbb0000000000000000
bbbbbbbbbbabbabbbbbbddddddddbbbbbbbbbddddddbbbbbbbbbddddddddbbbbbbbbbddddddbbbbbbbbbbdddddddbbbbbbbbbbdddddbbbbb0000000000000000
3333333333333333bbbbbddddddbbbbbbb66bbbbbbbb66bbbbbbbddddddbbbbbbbbbbbbbbbbbbbbbbbbbbbdddddbbbbbbbbbbbbbbbbbbbbb0000000000000000
bbbbbbbbbbbbbbbbbb66bbbbbbbb66bbb6ddbbbbbbbbdd6bbb66bbbbbbbb66bbbb66bbbbbbbb66bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb0000000000000000
bbbbbbbbbbbbbbbbb6ddbbbddbbbdd6bbddbbbbddbbbbddbbbddbbbddbbbdd6bbbddbbbddbbbdd6bbbbb66b66b6bbbbbbbbb66b66b6bbbbb0000000000000000
bbbbbbbbbbbbbbbbbddbbbbddbbbbddbbddbbbbddbbbbddbbbddbbbddbbbbddbbbddbbbddbbbbddbbbb6dbbddbd6bbbbbbb6dbbddbd6bbbb0000000000000000
bbbbbbbbbbbbbbbbbddbbbdbbdbbbddbbbbbbbdbbdbbbbbbbbddbbdbbdbbbddbbbddbbdbbdbbbddbbbbddbbdd6ddbbbbbbbddbbddbddbbbb0000000000000000
bbbbbbbbbbbbbbbbbbbb06d00d60bbbbbbbb06d00d60bbbbbbbb06d00dd6bbbbbbbb06d00dd6bbbbbbbbbb0ddd6bbbbbbbbbbb0dd00bbbbb0000000000000000
bbbbbbbbbbbbbbbbbbb06d0000d60bbbbbb06d0000d60bbbbbb06d0000dddbbbbbb06d0000dddbbbbbbbb0dd0dd0bbbbbbbbb00dd600bbbb0000000000000000
bbbbbbbbbbbbbbbbbbbddd0000dddbbbbbbddd0000dddbbbbbbddd000000bbbbbbbddd000000bbbbbbbbb0dd6000bbbbbbbbb000dd60bbbb0000000000000000
3333333333333333bbbbb000000bbbbbbbbbb000000bbbbbbbbbb000000bbbbbbbbbb000000bbbbbbbbbbb00000bbbbbbbbbbb00000bbbbb0000000000000000
__map__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2020202020202020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
