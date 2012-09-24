package  {
	import com.greensock.easing.Elastic;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.ui.Keyboard;
	import Instance.Level;
	import Interface.BonusText;
	import Interface.Cube;
	import Interface.HUD;
	import tools.MyTools;

    /**
     * ...
     * @author Nicolas BARRET
     */
    public class Jeu extends Sprite {
        private const KEYS_CODE_TAB:Object = { (int(Keyboard.UP)):Level.EVENT_UP, (int(Keyboard.DOWN)):Level.EVENT_DOWN };
        private var $pause:Boolean = false;

        private var Levels_Tab:Vector.<Level> = new Vector.<Level>;
		
		public static var JeuActuel:Jeu;
		
		private var GBHandler:GoodBadieJeuHandler;
		
		private var $score:int = 0;
		public var Vies:int = Global.NOMBRE_NIVEAUX;
		
		private var LevelsConteneur:Sprite = new Sprite();
		public var TextesConteneur:Sprite = new Sprite();


        public function Jeu() {
            Cube.JeuConteneur.addChild(this);
			addChild(LevelsConteneur);
			addChild(TextesConteneur);

            Jeu.JeuActuel = this;
			
			GBHandler = new GoodBadieJeuHandler(this);

            stage.focus = null;
			
			HUD.TheHUD = new HUD();
			addChild(HUD.TheHUD);

            //Event
            addEventListener(Event.ENTER_FRAME, Event_Iterate);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			
			for (var i:int = 0; i < Global.NOMBRE_NIVEAUX; i++)
				AddLevel();
        }

        private function AddLevel():void {
            //Level
            var level:Level = new Level();
            level.y = Global.HEIGHT;
            LevelsConteneur.addChild(level);
            Levels_Tab.push(level);

           Level.targetHeight = Global.HEIGHT / Levels_Tab.length;

            ActivateLevelListeners(level, true);
			
			RePlaceAll_Y();
        }

        private function RemoveLevel(level:Level):void {
            ActivateLevelListeners(level, false);

            level.dispatchEvent(new Event(Level.EVENT_TERMINATE));

            TweenMax.delayedCall(2, KillLevel, [level]);
			
			RePlaceAll_Y();
        }

        private function ActivateLevelListeners(level:Level, yes:Boolean):void {
            if (yes) {
                level.addEventListener(Level.EVENT_LOST, LevelLost);
                level.addEventListener(Level.EVENT_TERMINATE, TerminateLevel);
                level.addEventListener(Level.EVENT_GOT_GOODIE, GotGoodie);
                level.addEventListener(Level.EVENT_GOT_BADIE, GotBaddie);
            } else {
                level.removeEventListener(Level.EVENT_LOST, LevelLost);
                level.removeEventListener(Level.EVENT_TERMINATE, TerminateLevel);
                level.removeEventListener(Level.EVENT_GOT_GOODIE, GotGoodie);
                level.removeEventListener(Level.EVENT_GOT_BADIE, GotBaddie);
            }
        }
		
		private function RePlaceAll_Y():void {
			var nbr:int = Levels_Tab.length;

            for (var i:String in Levels_Tab) {
				//Levels
                var level:Level = Levels_Tab[i];
				level.targetY = int(i) * Level.targetHeight;
                TweenMax.to(level, 1, { delay:(nbr - int(i)) * 0.05, height:Level.targetHeight, y:level.targetY, ease:Elastic.easeOut } );
				
				//BonusText
				var BTy:int = BonusText.getY(level);
				for each (var BT:BonusText in BonusText.BonusText_Tab[level]) {
					TweenMax.to(BT, 0.5, { y:BTy } );
				}
            }
		}

        public function get Pause():Boolean { return $pause; }

        public function set Pause(value:Boolean):void {
            $pause = value;
            if (value) {
                TweenMax.pauseAll();
                Cube.Menu_Pause.Show();
				TweenMax.to(this, 0.5, { blurFilter: { blurX:100, blurY:100, quality:3 }} );
            } else {
                TweenMax.resumeAll();
                Cube.Menu_Pause.Close();
                stage.focus = null;
				TweenMax.to(this, 0.5, { blurFilter: { blurX:0, blurY:0, remove:true, quality:3 }} );
            }
        }
		
		public function get Score():int { return $score; }
		
		public function set Score(value:int):void {
			$score = value;
			HUD.TheHUD.MAJ_Score();
		}

        private function Event_Iterate(evt:Event):void {
            if (!Pause) {
				Score += Levels_Tab.length;			//Obligé de mettre avant sinon ça pose probleme lors du game over
                stage.dispatchEvent(new Event(Level.EVENT_ITERATE));
			}
        }


        private function KeyDown(evt:KeyboardEvent):void {
			//Controles
			if (evt.keyCode == Keyboard.UP || evt.keyCode == Keyboard.DOWN) {
				var eventString:String = KEYS_CODE_TAB[evt.keyCode];
				
				dispatch_move(eventString);
			}
			
			//Pause
			else if (evt.keyCode == Keyboard.ESCAPE) {
				if (!Pause)
					Pause = true;
				else
					Pause = false;
            }
        }
		
		private function dispatch_move(evt:String):void
		{
			for each (var level:Level in Levels_Tab) {
				level.dispatchEvent(new Event(evt));
			}
		}

        private function GotGoodie(evt:Event):void {
			GBHandler.Goodies[Math.floor(Math.random() * GBHandler.Goodies.length)].Do(true, evt.target as Level);
        }

        private function GotBaddie(evt:Event):void {
			GBHandler.Badies[Math.floor(Math.random() * GBHandler.Badies.length)].Do(false, evt.target as Level);
        }

        private function LevelLost(evt:Event):void {
            TerminateLevel(evt);
            TweenMax.fromTo(this, 0.2, {removeTint:true}, { yoyo:true, repeat:1, colorTransform: { tint:0xcff0000, tintAmount:0.5 }} ); //Besoin d'un fromTo sinon problème d'overwrite
	
			Vies--;
			
			//Vies
			if (Vies == 0) {
				Destroy();
				Cube.gotoHighScoreFromJeu(Score); //Obligé de mettre après, sinon le destroy killAll !
			}
        }
		
		//Ordre des evènements : Terminate puis Kill
        private function TerminateLevel(evt:Event):void {
            RemoveLevel(evt.currentTarget as Level);
        }

        private function KillLevel(level:Level):void {
            level.dispatchEvent(new Event(Level.EVENT_KILL));
        }

        public function Destroy():void {
            removeEventListener(Event.ENTER_FRAME, Event_Iterate);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			
			for each (var level:Level in Levels_Tab) {
                ActivateLevelListeners(level, false);
                level.dispatchEvent(new Event(Level.EVENT_KILL));
            }

            TweenMax.killAll(false, true, true); //Source de bug possible : Avant :  TweenMax.killAll(false, true, false);
            Cube.JeuConteneur.removeChild(this);

            Jeu.JeuActuel = null;
        }
    }
}

