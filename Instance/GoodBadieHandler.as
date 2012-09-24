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
		
		public function GoodBadieHandler(Parent:Level)
		{
			this.Parent = Parent;

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
	}
	
}