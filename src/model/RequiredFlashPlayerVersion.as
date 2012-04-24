package model
{
	public class RequiredFlashPlayerVersion
	{

		private var _lower:int;
		private var _upper:int;
		private var _mid:int;
		private var _automatic:Boolean;
		
		public function RequiredFlashPlayerVersion(upper : int, mid : int, lower : int, automatic : Boolean = false)
		{
			_upper = upper;
			_mid = mid;
			_lower = lower;
			
			_automatic = automatic;
		}
		

		public function get automatic():Boolean
		{
			return _automatic;
		}

		public function set automatic(value:Boolean):void
		{
			_automatic = value;
		}

		public function get label():String
		{
			return _automatic ? "<Automatic>" : (_upper.toString() + "." + _mid.toString() + "." + lower.toString());
		}

		public function get mid():int
		{
			return _mid;
		}

		public function set mid(value:int):void
		{
			_mid = value;
		}

		public function get upper():int
		{
			return _upper;
		}

		public function set upper(value:int):void
		{
			_upper = value;
		}

		public function get lower():int
		{
			return _lower;
		}

		public function set lower(value:int):void
		{
			_lower = value;
		}
	}
}