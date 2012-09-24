package Interface {
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import Instance.Level;
	import tools.MyTools;
	import tools.Position_Taille;
	
	/**
	 * Affiche un text avec une animation
	 * @author Nicolas BARRET
	 */
	public class BonusText extends Sprite {
		//[Embed(source = "C:/Users/KissCoool/Flash Portable/MultiBrix/src/defused.ttf", fontFamily = "myDefused")]
		//var myDefused:Class;
		//var arialEmbeddedFont:Font = new myDefused();
		
		public static var BonusText_Tab:Dictionary = new Dictionary(true);
		
		public var levelConcerned:Level;
		
		private var Text:Bitmap;
		
		public function BonusText(text:String, isGoodie:Boolean, levelConcerned:Level, duration:Number) {
			this.levelConcerned = levelConcerned;
			levelConcerned.addEventListener(Level.EVENT_TERMINATE, Destroy);
			
			Text = MyTools.RenderText(text, new TextFormat("Arial", 80, (isGoodie?0x00FF00:0xFF0000)));
			Text.filters = [new GlowFilter(0xFFFFFF)];
			addChild(Text);
			
			//Init BonusText_Tab
			if (BonusText_Tab[levelConcerned] == undefined) {
				BonusText_Tab[levelConcerned] = new Vector.<BonusText>();
			}
			
			BonusText_Tab[levelConcerned].push(this);
			
			//Set Position
			x = Global.WIDTH + this.width;
			ReplaceX()
			y = getY(levelConcerned);
			rotation = Math.round(Math.random() * 20) - 10;
			
			Jeu.JeuActuel.TextesConteneur.addChild(this);
			
			TweenMax.from(this, 1, { rotation:0, scaleX:0.2, scaleY:0.2 } );
			TweenMax.delayedCall(duration, PrepareToDestroy);
		}
		
		public function ReplaceX():void {
			var TotalWidth:int = 0;
			for each (var BT:BonusText in BonusText_Tab[levelConcerned]) {
				TotalWidth += BT.width;
			}
			
			var currentX:int = Global.WIDTH / 2 - TotalWidth / 2 + BonusText_Tab[levelConcerned][0].width / 2;
			TweenMax.to(BonusText_Tab[levelConcerned][0], 0.5, { x:currentX} );
			for (var i:int = 1; i < BonusText_Tab[levelConcerned].length; i++) {
				currentX = currentX + BonusText_Tab[levelConcerned][i - 1].width / 2 + BonusText_Tab[levelConcerned][i].width / 2 + 10;
				TweenMax.to(BonusText_Tab[levelConcerned][i], 0.5, { x:currentX } );
			}
		}
		
		public static function getY(level:Level):int {
			 return level.targetY + Level.targetHeight / 2;
		}
		
		public function PrepareToDestroy():void { //trace("BonusText.PrepareToDestroy", name, y);
			TweenMax.killDelayedCallsTo(PrepareToDestroy);
			TweenMax.to(this, 0.5, { rotation:180 * Math.random(), scaleX:0.1, scaleY:0.1, onComplete:Destroy } );
		}
		
		public function Destroy(evt:Event = null):void { //trace("BonusText.Destroy", name, evt, y);
			TweenMax.killTweensOf(this);
			TweenMax.killDelayedCallsTo(PrepareToDestroy);
			levelConcerned.removeEventListener(Level.EVENT_TERMINATE, Destroy);
			
			if (evt == null) {  //cad si c'est pas le niveau en entier qui est supprimé
				ReplaceX();
				MyTools.RemoveFromVector(this, BonusText_Tab[levelConcerned]);
			} else { //Destroy appelé par levelConcerned.removeEventListener(Level.EVENT_TERMINATE, Destroy);
				BonusText_Tab[levelConcerned] = undefined;
			}
			parent.removeChild(this);
		}
	}
}