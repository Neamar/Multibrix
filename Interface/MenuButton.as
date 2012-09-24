package Interface {
	import com.greensock.easing.Elastic;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import tools.MyTools;
	
	public dynamic class MenuButton extends Sprite {
		private const W:int = 200;
		private const H:int = 80;
		
		private var InitScale:Number;
		
		private var ActionFct:Function;

		public function MenuButton(label:String, X:int, Y:int, scale:Number, Parent:Sprite, fct:Function) {
			OverwriteManager.init(OverwriteManager.AUTO);

			this.buttonMode = true;
			this.mouseChildren = false;

			Parent.addChild(this);
			
			ActionFct = fct;
			
			//Position
			this.x = X;
			this.y = Y;
			this.scaleX = this.scaleY = InitScale = scale;
	
			//TextField
			var B:Bitmap = MyTools.RenderText(label, new TextFormat("Arial", 50, 0xFFFFFF));
			this.addChild(B);

			//Graphique
			this.graphics.beginFill(0x000000);
			this.graphics.lineStyle(3, 0xFF0000);
			this.graphics.drawRoundRect(-W/2, -H/2, W, H, 20);
		}
		
		private function Click(evt:MouseEvent):void {
			ActionFct();
		}

		private function MouseOver(evt:MouseEvent):void {
			var r:int = Math.random()*40-20;
			TweenMax.to(this, 0.5, {scaleX:InitScale*1.5, scaleY:InitScale*1.5, rotation:r, ease:Elastic.easeOut});
		}

		private function MouseOut(evt:MouseEvent):void {
			TweenMax.to(this, 0.9, {scaleX:InitScale, scaleY:InitScale, rotation:0, ease:Elastic.easeOut});
		}
		
		public function Activate(yes:Boolean):void {
			if (yes) {
				this.addEventListener(MouseEvent.MOUSE_OVER, MouseOver);
				this.addEventListener(MouseEvent.MOUSE_OUT, MouseOut);
				this.addEventListener(MouseEvent.CLICK, Click);
			} else {
				this.removeEventListener(MouseEvent.MOUSE_OVER, MouseOver);
				this.removeEventListener(MouseEvent.MOUSE_OUT, MouseOut);
				this.removeEventListener(MouseEvent.CLICK, Click);
			}
		}
	}
}