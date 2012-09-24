package Interface {
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Nicolas BARRET
	 */
	public class Face extends Sprite {
		private const W2:int = Global.WIDTH / 2;
		private const H2:int = Global.HEIGHT / 2;
		
		public function Face(color:int, child:Sprite, isSquare:Boolean = false) {
			var w2:int = W2;
			var h2:int = H2;
			var w:int = Global.WIDTH;
			var h:int = Global.HEIGHT;
			
			if (isSquare) {
				h2 = w2;
				h = w;
			}
			
			graphics.lineStyle(2, 0xFF0000);
			graphics.beginFill(color);
			graphics.drawRect( -w2, -h2, w, h);
			child.x = -w2;
			child.y = -h2;
			addChild(child);
		}
	}
}