package events
{
	import flash.events.Event;
	
	public class SettingsEvent extends Event
	{
		public static const SETTINGS_UPDATED : String = "SettingsEvent.SETTINGS_UPDATED";
		
		public function SettingsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}