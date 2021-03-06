package;

import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;

#if windows
import Discord.DiscordClient;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay'];
	#end

	var newGaming:FlxText;
	var newGaming2:FlxText;
	public static var firstStart:Bool = true;

	public static var nightly:String = "";

	public static var kadeEngineVer:String = "1.5.1" + nightly;
	public static var gameVer:String = "0.2.7.1";

	var purple:FlxSprite;
	var camFollow:FlxObject;
	var streakleft:FlxSprite;
	var streakright:FlxSprite;
	var GFDance:FlxSprite;
	var BFDance:FlxSprite;
	var WaluigiDance:FlxSprite;
	
	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		#if windows
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('bg_blur'));
		bg.scrollFactor.x = 0.05;
		bg.scrollFactor.y = 0.10;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		purple = new FlxSprite(-80).loadGraphic(Paths.image('bg_bawe'));
		purple.scrollFactor.x = 0.05;
		purple.scrollFactor.y = 0.10;
		purple.setGraphicSize(Std.int(purple.width * 1.1));
		purple.updateHitbox();
		purple.screenCenter();
		purple.visible = false;
		purple.antialiasing = true;
		purple.color = 0xFFcbc3e3;
		add(purple);
		// purple.scrollFactor.set();
		
		// unused image of "vs" in main menu
		// var vs:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('vs'));
		// vs.scrollFactor.y = 0.05;
		// vs.antialiasing = true;
		// add(vs);
		
		BFDance = new FlxSprite(25, 175);
		BFDance.frames = Paths.getSparrowAtlas('BFMenu');
		BFDance.antialiasing = true;
		BFDance.animation.addByPrefix('bfdance', 'BF idle dance', 24);
		BFDance.animation.play('bfdance');
		BFDance.scrollFactor.x = 0;
		BFDance.scrollFactor.y = 0.01;
		add(BFDance);
		
		WaluigiDance = new FlxSprite(550, -25);
		WaluigiDance.frames = Paths.getSparrowAtlas('WaluigiMenu');
		WaluigiDance.antialiasing = true;
		WaluigiDance.animation.addByPrefix('waldance', 'idle', 24);
		WaluigiDance.animation.play('waldance');
		WaluigiDance.scrollFactor.x = 0;
		WaluigiDance.scrollFactor.y = 0.01;
		add(WaluigiDance);
		
		// unused gf in main menu
		// GFDance = new FlxSprite(-192.35, -10);
		// GFDance.frames = Paths.getSparrowAtlas('GFMenu');
		// GFDance.antialiasing = true;
		// GFDance.animation.addByPrefix('gfdance', 'GF Dancing Beat', 24);
		// GFDance.animation.play('gfdance');
		// GFDance.scrollFactor.x = 0;
		// GFDance.scrollFactor.y = 0.01;
		// add(GFDance);

		streakleft = new FlxSprite(-500, 13).loadGraphic(Paths.image('bluestreakleft'));
		streakleft.scrollFactor.x = 0;
		streakleft.scrollFactor.y = 0.02;
		streakleft.antialiasing = true;
		add(streakleft);

		FlxTween.tween(streakleft, { x: -14.85, y: 13 }, 2, {ease: FlxEase.expoOut});	
		
		streakright = new FlxSprite(1500, 598.7).loadGraphic(Paths.image('bluestreakright'));
		streakright.scrollFactor.x = 0;
		streakright.scrollFactor.y = 0.02;
		streakright.antialiasing = true;
		add(streakright);
		
		FlxTween.tween(streakright, { x: 0, y: 598.7 }, 2, {ease: FlxEase.expoOut});
			
		var menutext:FlxSprite = new FlxSprite(250, 10).loadGraphic(Paths.image('text_mainmenu'));
		menutext.scrollFactor.x = 0;
		menutext.scrollFactor.y = 0.04;
		menutext.antialiasing = true;
		add(menutext);
		
		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, FlxG.height * 1.6);
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			if (firstStart)
				FlxTween.tween(menuItem,{y: 60 + (i * 160)},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween) 
					{ 
						finishedFunnyMove = true; 
						changeItem();
					}});
			else
				menuItem.y = 60 + (i * 160);
		}

		firstStart = false;

		FlxG.camera.follow(camFollow, null, 0.60 * (60 / FlxG.save.data.fpsCap));

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, gameVer +  (Main.watermarks ? " FNF - " + kadeEngineVer + " Kade Engine" : ""), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();


		if (FlxG.save.data.dfjk)
			controls.setKeyboardScheme(KeyboardScheme.Solo, true);
		else
			controls.setKeyboardScheme(KeyboardScheme.Duo(true), true);

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					fancyOpenURL("https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game");
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));
					
					if (FlxG.save.data.flashing)
						FlxFlicker.flicker(purple, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 1.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							if (FlxG.save.data.flashing)
							{
								FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
								{
									goToState();
								});
							}
							else
							{
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									goToState();
								});
							}
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}
	
	function goToState()
	{
		var daChoice:String = optionShit[curSelected];

		switch (daChoice)
		{
			case 'story mode':
				FlxG.switchState(new StoryMenuState());
				trace("Story Menu Selected");
			case 'freeplay':
				FlxG.switchState(new FreeplayState());

				trace("Freeplay Menu Selected");

			case 'options':
				FlxG.switchState(new OptionsMenu());
		}
	}

	function changeItem(huh:Int = 0)
	{
		if (finishedFunnyMove)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected && finishedFunnyMove)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
