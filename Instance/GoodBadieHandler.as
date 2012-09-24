package Instance
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	/**
	 * Une classe helper sur niveau pour gérer les goodie badie individuels
	 * @author Neamar
	 */
	public class  GoodBadieHandler
	{
		private var Parent:Level;
		private var Mur:Sprite = new Sprite();
		
		public function GoodBadieHandler(Parent:Level)
		{
			this.Parent = Parent;
			
			Mur.graphics.lineStyle(1);
			Mur.graphics.lineTo(0, Global.NombreLignes * Global.CaseHauteur);
			
			var F:Array = new Array(new GlowFilter());
			Mur.filters = F;
		}
		
		/**
		 * Active le pilotage automatique de la bille
		 */
		public function goodie_enable_auto():void
		{
			Parent.addEventListener(Level.EVENT_FRAME, Parent.goodie_play_auto);
		}
		public function goodie_disable_auto():void
		{
			Parent.removeEventListener(Level.EVENT_FRAME, Parent.goodie_play_auto);
		}
		
		/**
		 * Arrête complètement le niveau.
		 */
		public function goodie_enable_pause():void
		{
			Global.stage.removeEventListener(Level.EVENT_ITERATE, Parent.ajouterFrame);
		}
		public function goodie_disable_pause():void
		{
			Global.stage.addEventListener(Level.EVENT_ITERATE, Parent.ajouterFrame);
		}

		/**
		 * Attiré deux fois plus vite vers le centre que d'habitude
		 */
		public function goodie_enable_attraction():void
		{
			Parent.addEventListener(Level.EVENT_FRAME, Parent.goodie_play_attraction);
		}
		public function goodie_disable_attraction():void
		{
			Parent.addEventListener(Level.EVENT_FRAME, Parent.goodie_play_attraction);
		}
		
		/**
		 * Invincible. Peut passer par dessus les murs sans soucis :)
		 */
		public function goodie_enable_passemuraille():void
		{
			Parent.PasseMuraille = true;
		}
		public function goodie_disable_passemuraille():void
		{
			Parent.PasseMuraille = false;
		}
		
		/**
		 * Invincible. Se matérialise par l'apparition d'un mur derrère lequel on ne peut pas passer
		 */
		public function goodie_enable_invincible():void
		{
			Mur.x = Global.WALL_INVINCIBLE_x * Parent.NombreColonnes * Global.CaseLongueur;
			Parent.addChild(Mur);
			Parent.addEventListener(Level.EVENT_FRAME, Parent.goodie_play_invincible);
		}
		public function goodie_disable_invincible():void
		{
			Parent.removeChild(Mur);
			Parent.removeEventListener(Level.EVENT_FRAME, Parent.goodie_play_invincible);
		}
		
		/**
		 * Lancer la rotation du niveau, ce qui facilite énormément le jeu en donnant un bon avantage ;)
		 */
		public function goodie_enable_rotation():void
		{
			
		}
		public function goodie_disable_rotation():void
		{
			Parent.removeChild(Mur);
			Parent.removeEventListener(Level.EVENT_FRAME, Parent.goodie_play_invincible);
		}
	}
	
}