package {
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import Instance.Level;
	
	/**
	 * Une classe helper sur niveau pour gérer les goodie badie individuels
	 * @author Nicolas BARRET
	 */
	public class GoodBadieJeuHandler {
		private var Parent:Jeu;
		
		public var Goodies:Vector.<GoodBadDie> = new Vector.<GoodBadDie>();

		public var Badies:Vector.<GoodBadDie> = new Vector.<GoodBadDie>();
		
		public function GoodBadieJeuHandler(parent:Jeu):void {
			this.Parent = parent;
			
			Goodies.push(new GoodBadDie("+ 1 Vie", AddOneLife, 0, null, true));
			Goodies.push(new GoodBadDie("Passe Muraille", PasseMuraille_Enable, 5, PasseMuraille_Disable));
			
			Badies.push(new GoodBadDie("- 1 Vie", RemoveOneLife, 0, null, true));
			Badies.push(new GoodBadDie("Disparition", Disparition_Enable, 4, Disparition_Disable));
		}
		
		//----------------- Global ---------------
		/**
		 * Ajoute une vie
		 */
		public function AddOneLife(level:Level):void {
			//Parent.Vies++;
		}
		
		/**
		 * Enlève une vie
		 */
		public function RemoveOneLife(level:Level):void {
			//Parent.Vies--;
		}

		/**
		 * Disparition
		 */
		public function Disparition_Enable(level:Level):void {
			TweenMax.killTweensOf(level.Balle);
			level.Balle.alpha = .1;
		}
		public function Disparition_Disable(level:Level):void {
			TweenMax.to(level.Balle, 2, { alpha:1 } );
		}
		
		/**
		 * Passe Muraillle
		 */
		public function PasseMuraille_Enable(level:Level):void {
			level.GBHandler.goodie_enable_passemuraille();
		}
		public function PasseMuraille_Disable(level:Level):void {
			level.GBHandler.goodie_disable_passemuraille();
		}
	}
}