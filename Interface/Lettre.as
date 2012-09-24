package Interface {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import tools.MyTools;
	
	/**
	 * ...
	 * @author Nicolas BARRET
	 */
	public class Lettre extends Sprite {
		private const SIZE:int = 40;
		
		private var Text:Bitmap;
		
		public function Lettre(lettre:String) {
			//BackGround
			graphics.lineStyle(1, 0xFF0000);
			graphics.beginFill(0x000000);
			graphics.drawRoundRect( -SIZE / 2, -SIZE / 2, SIZE, SIZE, SIZE * 1 / 4);
			
			//Text
			Text = MyTools.RenderText(lettre, new TextFormat("Comic Sans MS", 50, 0xFFFFFF));
			addChild(Text);
			
			//Autres
			this.x = Global.WIDTH * 1 / 13;
		}
	}
}