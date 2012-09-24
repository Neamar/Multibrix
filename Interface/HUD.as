package Interface {
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Nicolas BARRET
	 */
	public class HUD extends Sprite {
		public static var TheHUD:HUD;
		
		private var Score_Txt:TextField = new TextField();
		
		public function HUD() {
			//Score
			Score_Txt.border = true;
			Score_Txt.borderColor = 0xFF0000;
			Score_Txt.background = true;
			Score_Txt.backgroundColor = 0x000000;
			Score_Txt.autoSize = TextFieldAutoSize.RIGHT;
			Score_Txt.x = Global.WIDTH - 20;
			Score_Txt.y = 10;
			Score_Txt.selectable = false;
			addChild(Score_Txt);
			MAJ_Score();
		}
		
		public function MAJ_Score():void {
			Score_Txt.text = Jeu.JeuActuel.Score.toString();
			Score_Txt.setTextFormat(new TextFormat("Arial", 20, 0xFFFFFF));
		}
	}
}