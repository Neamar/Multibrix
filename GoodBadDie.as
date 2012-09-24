package  {
	import com.greensock.TweenMax;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import Instance.Level;

	/**
	 * ...
	 * @author Nicolas BARRET
	 */
	public class GoodBadDie {
		private var Name:String;
		private var Init:Function;
		private var Duration:Number;
		private var End:Function;
		private var Cumulatif:Boolean;
		
		private var levelsConcerned:Dictionary = new Dictionary(); //Keys : Level | Value : {bonusText:BonusText, caller:TweenMax} (le BonusText est utile seulement en non Cumulatif)
		
		public function GoodBadDie(name:String, init:Function, duration:Number = 0, end:Function = null, cumulative:Boolean = false) {
			Name = name;
			Init = init;
			Duration = duration;
			End = end;
			Cumulatif = cumulative;
		}
		
		public function Do(isGoodie:Boolean, levelConcerned:Level):void {
			if (levelsConcerned[levelConcerned] == undefined) {
				levelsConcerned[levelConcerned] = new Object();
				
				Init(levelConcerned);
			} else {
				if (Cumulatif) {
					Init(levelConcerned);
				} else {
					if (levelsConcerned[levelConcerned].caller != null) //Car dans le cas des bonus sans temps, pas de caller ! (si Duration  = 0)
						levelsConcerned[levelConcerned].caller.kill();	//Detruit le delayedCall de Ending
					levelsConcerned[levelConcerned].bonusText.PrepareToDestroy(); //Detruit l'ancien BonusText
				}
			}
			
			//End
			if (Duration != 0) {
				levelsConcerned[levelConcerned].caller = TweenMax.delayedCall(Duration, Ending, [{currentTarget:levelConcerned}]);
				levelConcerned.addEventListener(Level.EVENT_TERMINATE, Ending);
			}
		}
		
		private function Ending(evt:Object):void {
			var levelConcerned:Level = evt.currentTarget;
			
			if (evt is Event) {	//Si Ending appelé à cause de la fin d'un niveau
				levelsConcerned[levelConcerned].caller.kill();
			}
			levelConcerned.removeEventListener(Level.EVENT_TERMINATE, Ending);
			
			
			End.apply(null, [levelConcerned]);
			delete levelsConcerned[levelConcerned];
		}
	}
}