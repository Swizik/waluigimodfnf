function start (song)
	setHudPosition(10000)
end

function setDefault(id)
	_G['defaultStrum'..id..'X'] = getActorX(id)
end

function stepHit (step)
	if curStep == 29 then	
		setHudPosition(0)
	end
	if curStep == 288 then
		setHudPosition(10000)
		setCamZoom(1.5)
		setActorAlpha(0,'boyfriend')
	end
	if curStep == 296 then
		setHudPosition(0)
		setCamZoom(1)
		setActorAlpha(1,'boyfriend')
	end
	if curStep == 392 then
		showOnlyStrums = true
		for i = 4, 7 do -- go to the center
			tweenPosXAngle(i, _G['defaultStrum'..i..'X'] - 275,getActorAngle(i), 4.5, 'setDefault')
		end
		tweenFadeIn('dad',0.1,4.5)
		for i=0,3 do
			tweenFadeIn(i,0.1,4.5)
		end
	end
	if curStep == 400 then
		setCamZoom(1.5)
	end
	if curStep == 456 then
		setCamZoom(1)
		showOnlyStrums = false
		for i = 4, 7 do -- go to the normal position
			tweenPosXAngle(i, _G['defaultStrum'..i..'X'] + 275,getActorAngle(i), 0.01, 'setDefault')
		end
		tweenFadeIn('dad',1,0.01)
		for i=0,3 do
			tweenFadeIn(i,1,0.01)
		end
	end
end