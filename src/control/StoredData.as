package control
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import model.Model;
	
	import mx.controls.Alert;

	public class StoredData
	{
		private static const SOID : String = "flembed_defaults";
		
		static public function setDefaults():void
		{
			var appdefaults : File = File.applicationStorageDirectory.resolvePath("app-defaults.xml");
			var fs : FileStream = new FileStream();
			fs.open(appdefaults, FileMode.WRITE);
			fs.writeUTFBytes(Model.getInstance().snapshot());
			fs.close();
				
			Alert.show("Settings succesfully set as default.", "Settings saved", Alert.OK); 
		}
		
		static public function loadDefaults():void
		{
			var appdefaults : File = File.applicationStorageDirectory.resolvePath("app-defaults.xml");
			if (appdefaults.exists)
			{
				var fs : FileStream = new FileStream();
				fs.open(appdefaults, FileMode.READ);
				trace("Bytes av: ", fs.bytesAvailable);
				fs.position = 0;
				var content : String = fs.readUTFBytes(fs.bytesAvailable);
				fs.close();
				
				Model.getInstance().loadSnapshot(content);
			}
		}
	}
}