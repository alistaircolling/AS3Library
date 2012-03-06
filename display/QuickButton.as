package utils.display
{
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * @author ihayes
	 * 06 March 2012 - 9:43pm.
	 */
	public class QuickButton extends Sprite
	{
		private static const DEFAULT_BUTTON_WIDTH:uint = 120;
		private static const DEFAULT_BUTTON_HEIGHT:uint = 60;

		private var _buttonColour:uint;
		private var _labelColour:uint;
		private var _labelSize:uint;

		private var _button:Sprite;
		private var _labelTextField:TextField;
		private var _labelTextFormat:TextFormat;
		private var _width:Number;
		private var _height:Number;

		public function QuickButton (p_buttonColour:uint, p_labelColour:uint, p_label:String = "", p_labelSize:uint = 14)
		{
			_buttonColour = p_buttonColour;
			_labelColour = p_labelColour;
			_labelSize = p_labelSize;

			_labelTextFormat = new TextFormat ();
			_labelTextFormat.size = _labelSize;
			_labelTextFormat.color = _labelColour;

			_labelTextField = new TextField ();
			_labelTextField.multiline = false;
			_labelTextField.mouseEnabled = false;
			_labelTextField.autoSize = TextFieldAutoSize.LEFT;
			_labelTextField.antiAliasType = AntiAliasType.ADVANCED;
			_labelTextField.defaultTextFormat = _labelTextFormat;
			_labelTextField.text = p_label;

			_button = new Sprite ();
			_button.buttonMode = true;
			_button.graphics.beginFill (_buttonColour);

			if (_labelTextField.text.length > 0)
			{
				_button.graphics.drawRect (0, 0, _labelTextField.width, _labelTextField.height);
			}
			else
			{
				_button.graphics.drawRect (0, 0, DEFAULT_BUTTON_WIDTH, DEFAULT_BUTTON_HEIGHT);
			}

			_button.graphics.endFill ();

			addChild (_button);
			addChild (_labelTextField);
		}

		override public function set width (p_width:Number):void
		{
			_width = p_width;

			_button.width = _width;
			positionTextField ();
		}

		override public function set height (p_height:Number):void
		{
			_height = p_height;

			_button.height = _height;
			positionTextField ();
		}

		public function set font (p_font:String):void
		{
			_labelTextFormat.font = p_font;
			_labelTextField.defaultTextFormat = _labelTextFormat;
			resizeButton ();
		}

		public function set fontSize (p_fontSize:uint):void
		{
			_labelTextFormat.size = p_fontSize;
			_labelTextField.defaultTextFormat = _labelTextFormat;
			resizeButton ();
		}

		public function get label ():String
		{
			return _labelTextField.text;
		}

		public function set label (p_label:String):void
		{
			_labelTextField.text = p_label;

			resizeButton ();
		}

		private function resizeButton ():void
		{
			if (_labelTextField.width > _width)
			{
				width = _labelTextField.width;
			}

			if (_labelTextField.height > _height)
			{
				height = _labelTextField.height;
			}
		}

		protected function positionTextField ():void
		{
			_labelTextField.x = (_button.width * .5) - (_labelTextField.width * .5);
			_labelTextField.y = (_button.height * .5) - (_labelTextField.height * .5);
		}
	}
}
