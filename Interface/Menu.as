package Interface {
    import flash.display.Sprite;

    /**
     * ...
     * @author
     */
    public class Menu extends Sprite {
        private var List_Btn:Vector.<MenuButton> = new Vector.<MenuButton>();

        public var Cont:Sprite; //ATEN:a virer ou pas

        public function Menu(cont:Sprite = null):void {
            Cont = cont;
        }

        public function addButton(label:String, X:int, Y:int, scale:Number, fct:Function):void {
            var B:MenuButton = new MenuButton(label, X, Y, scale, this, fct);
            List_Btn.push(B);
        }

        public function Show():void {
            Cont.addChild(this);

            for each (var btn:MenuButton in List_Btn) {
                btn.Activate(true);
            }
        }

        public function Close():void {
            Cont.removeChild(this);

            for each (var btn:MenuButton in List_Btn) {
                btn.Activate(false);
            }
        }
    }
}

