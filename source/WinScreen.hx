package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class WinScreen extends MusicBeatState
{
    var winScreen:FlxSprite;
    var pressEnter:FlxText;

    var funnyEnding:Bool = false;

    var random:FlxRandom = new FlxRandom();

    public function new(funny:Bool)
    {
        super();

        funnyEnding = funny;
    }    

    override public function create() 
    {   
        var timeForFunny = random.int(0, 100);

        if (timeForFunny == 69 || PlayState.combo == 69)
            funnyEnding = true;

        if (funnyEnding)
        {
            // haha the
            FlxG.sound.play(Paths.sound('hola_chicas_despacito', 'shared'));
            winScreen = new FlxSprite(0, 0).loadGraphic(Paths.image('endings/secret', 'shared'));
        }
        else
        {
            // not funny, didnt laugh
            FlxG.sound.play(Paths.sound('win', 'shared'));
            winScreen = new FlxSprite(0, 0).loadGraphic(Paths.image('endings/win', 'shared'));
        }

        add(winScreen);
    }

    override public function update(elapsed:Float)
    {
        if (FlxG.keys.justPressed.ENTER)
        {
            FlxG.sound.playMusic(Paths.music('freakyMenu'));
			FlxG.switchState(new StoryMenuState());
        }
    }
}