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
		private var Vie_Txt:TextField = new TextField();
		
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
			
			//Vie
			Vie_Txt.border = true;
			Vie_Txt.borderColor = 0xFF0000;
			Vie_Txt.background = true;
			Vie_Txt.backgroundColor = 0x000000;
			Vie_Txt.autoSize = TextFieldAutoSize.RIGHT;
			Vie_Txt.y = Score_Txt.y;
			Vie_Txt.selectable = false;
			addChild(Vie_Txt);
			MAJ_Vie();
		}
		
		public function MAJ_Score():void {
			Score_Txt.text = Jeu.JeuActuel.Score.toString();
			Score_Txt.setTextFormat(new TextFormat("Arial", 20, 0xFFFFFF));
			Vie_Txt.x = Score_Txt.x - Vie_Txt.width - 10;
		}
		
		public function MAJ_Vie():void {
			var V:String = (Jeu.JeuActuel.Vie > 1) ? "Vies" : "Vie";
			Vie_Txt.text = Jeu.JeuActuel.Vie.toString() + " " + V;
			Vie_Txt.setTextFormat(new TextFormat("Arial", 20, 0xFFFFFF));
		}
	}
}