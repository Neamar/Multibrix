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
			Badies.push(new GoodBadDie("Contrôles Communs", ControlesCommuns_Enable, 5, ControlesCommuns_Disable));
			Badies.push(new GoodBadDie("Disparition", Disparition_Enable, 4, Disparition_Disable));
		}
		
		//----------------- Global ---------------
		/**
		 * Ajoute une vie
		 */
		public function AddOneLife(level:Level):void {
			Parent.Vie ++;
		}
		
		/**
		 * Enlève une vie
		 */
		public function RemoveOneLife(level:Level):void {
			if (Parent.Vie > 1)
				Parent.Vie --;
		}
		
		/**
		 * Controles Communs
		 */
		public function ControlesCommuns_Enable(level:Level):void {
			Parent.ControlesCommuns = true;
		}
		public function ControlesCommuns_Disable(level:Level):void {
			Parent.ControlesCommuns = false;
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
		
		//----------- Spécifique à un niveau ----------
		/**
		 * Flou sur un niveau
		 */
		public function Flou_Enable(level:Level):void {
			TweenMax.to(level, 0.5, { blurFilter: { blurX:4, blurY:4, quality:3 }} );
		}
		public function Flou_Disable(level:Level):void {
			TweenMax.to(level, 0.5, { blurFilter: { blurX:0, blurY:0, remove:true, quality:3 }} );
		}
		
		/**
		 * Augmente la cadence
		 */
		public function Speed_More(level:Level):void {
			TweenMax.to(level, 0.5, { Cadence:level.Cadence / 2 } );
		}
		public function Speed_Less(level:Level):void {
			TweenMax.to(level, 0.5, { Cadence:level.Cadence * 2 } );
		}
		
		/**
		 * Augmente la densité
		 */
		public function Density_More(level:Level):void {
			TweenMax.to(level, 0.5, { Densite:getValide01Number(level.Densite + 0.2) } );
		}
		public function Density_Less(level:Level):void {
			TweenMax.to(level, 0.5, { Densite:getValide01Number(level.Densite - 0.2) } );
		}
		
		/**
		 * Perte de contrôle
		 */
		public function LooseControl_Enable(level:Level):void { trace(level.y, "LooseControl_Enable");
			level.removeEventListener(Level.EVENT_UP, level.deplacerBalleHaut);
            level.removeEventListener(Level.EVENT_DOWN, level.deplacerBalleBas);
		}
		public function LooseControl_Disable(level:Level):void { trace(level.y, "LooseControl_Disable");
			level.addEventListener(Level.EVENT_UP, level.deplacerBalleHaut);
            level.addEventListener(Level.EVENT_DOWN, level.deplacerBalleBas);
		}
		
		/**
		 * Touches Inversées
		 */
		public function TouchesInversees_Enable(level:Level):void {
			LooseControl_Enable(level);
			level.addEventListener(Level.EVENT_UP, level.deplacerBalleBas);
            level.addEventListener(Level.EVENT_DOWN, level.deplacerBalleHaut);
		}
		public function TouchesInversees_Disable(level:Level):void {
			level.removeEventListener(Level.EVENT_UP, level.deplacerBalleBas);
            level.removeEventListener(Level.EVENT_DOWN, level.deplacerBalleHaut);
			LooseControl_Disable(level);
		}
		
		/**
		 * Miroir Vertical
		 */
		public function MiroirVertical_Enable(level:Level):void {
			TweenMax.to(level, 1, {rotationY:180, x:Global.WIDTH});
		}
		public function MiroirVertical_Disable(level:Level):void {
			TweenMax.to(level, 1, {rotationY:0, x:0});
		}
		
		//----------- Spécifique à un niveau, Geré dans le niveau ----------
		/**
		 * Active le pilotage automatique de la bille
		 */
		public function PiloteAuto_Enable(level:Level):void {
			level.GBHandler.goodie_enable_auto();
		}
		public function PiloteAuto_Disable(level:Level):void {
			level.GBHandler.goodie_disable_auto();
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
		
		/**
		 * Invincible (Mur)
		 */
		public function Invincible_Enable(level:Level):void {
			level.GBHandler.goodie_enable_invincible();
		}
		public function Invincible_Disable(level:Level):void {
			level.GBHandler.goodie_disable_invincible();
		}
		
		/**
		 * Met Pause à un niveau
		 */
		public function Pause_Enable(level:Level):void {
			level.GBHandler.goodie_enable_pause();
		}
		public function Pause_Disable(level:Level):void {
			level.GBHandler.goodie_disable_pause();
		}
		
		/**
		 * Attraction au centre x2
		 */
		public function AttractionX2_Enable(level:Level):void {
			level.GBHandler.goodie_enable_attraction();
		}
		public function AttractionX2_Disable(level:Level):void {
			level.GBHandler.goodie_disable_attraction();
		}
		
		//-------------------------
		//function qui renvoi 0 si n < 0, 1 si n > 1 et n sinon.
		private function getValide01Number(n:Number):Number {
			if (n <= 0)
				return 0;
			else if (n >= 1)
				return 1;
			else
				return n;
		}
	}
}