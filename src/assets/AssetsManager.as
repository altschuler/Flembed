package assets
{
	import flash.display.BitmapData;

	public class AssetsManager
	{
		public static var HTML_DYNAMIC : String = "HTML_DYNAMIC";
		
		[Bindable]
		[Embed(source="assets/mac_window_left.png")]
		public static var MAC_WINDOW_LEFT:Class;
		
		[Bindable]
		[Embed(source="assets/mac_window_center.png")]
		public static var MAC_WINDOW_CENTER:Class;
		
		[Bindable]
		[Embed(source="assets/mac_window_right.png")]
		public static var MAC_WINDOW_RIGHT:Class;

		[Bindable]
		[Embed(source="assets/expressInstall.swf", mimeType="application/octet-stream")]
		public static var EXPRESS_INSTALL:Class;
		
		[Bindable]
		[Embed(source="assets/file_extension_jpg.png")]
		private static var JPG_ICON:Class;
		
		[Bindable]
		[Embed(source="assets/file_extension_jpeg.png")]
		private static var JPEG_ICON:Class;
		
		[Bindable]
		[Embed(source="assets/file_extension_swf.png")]
		private static var SWF_ICON:Class;
		
		[Bindable]
		[Embed(source="assets/file_extension_png.png")]
		private static var PNG_ICON:Class;
		
		[Bindable]
		[Embed(source="assets/file_extension_gif.png")]
		private static var GIF_ICON:Class;
		
		
		[Bindable]
		[Embed(source="assets/index_dynamic.html", mimeType="application/octet-stream")]
		private static var HTML_TEMPLATE_DYNAMIC:Class;
		
		[Bindable]
		[Embed(source="assets/alternative_content.html", mimeType="application/octet-stream")]
		private static var ALTERNATIVE_CONTENT:Class;
		
		[Bindable]
		[Embed(source="assets/swfobject2_2.js", mimeType="application/octet-stream")]
		private static var SWFOBJECT_2_2:Class;
		
		public static function getHTMLTemplate(type:String):String
		{
			switch (type)
			{
				case HTML_DYNAMIC:
					return new HTML_TEMPLATE_DYNAMIC().toString();
					
				default:
					return new HTML_TEMPLATE_DYNAMIC().toString();
			}
		}
		
		public static function getAlternativeContent():String
		{
			return new ALTERNATIVE_CONTENT().toString()
		}
		
		public static function getSWFObject(version : String):String
		{
			switch (version)
			{
				case HTMLTemplate.SWF_OBJECT_1_5:
					return new SWFOBJECT_2_2().toString();
					
				case HTMLTemplate.SWF_OBJECT_2:
					return new SWFOBJECT_2_2().toString();
				
				default:
					return new SWFOBJECT_2_2().toString();
					
			}
		}
		
		public static function getIconFromExtension(ext:String):Class
		{
			switch (ext)
			{
				case "png":
					return PNG_ICON;
				case "gif":
					return GIF_ICON;
				case "jpg":
					return JPG_ICON;
				case "jpeg":
					return JPEG_ICON;
				case "swf":
					return SWF_ICON;
				default:
					return SWF_ICON;
			}
		}
	}
}