package dragdrop
{
	import events.FileEvent;
	
	import flash.desktop.ClipboardFormats;
	import flash.events.EventDispatcher;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	import model.FileInfo;
	import model.Model;
	
	import mx.controls.Alert;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.managers.DragManager;
			
	public class DragDropManager extends EventDispatcher
	{
		public function DragDropManager(dropTargets : Array)
		{   
			for each (var dropTarget : IUIComponent in dropTargets)
			{
				dropTarget.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, onDragIn);
				dropTarget.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, onDrop);
			}			
		}
		
		private function addFile(f:File):void
		{
			var fileInfo : FileInfo = new FileInfo();
			fileInfo.file = f;
			Model.getInstance().addFile(fileInfo);
			Model.getInstance().notify();
		}
		
		private function onDrop(event:NativeDragEvent):void
		{
			var dropfiles:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			for each (var file:File in dropfiles)
			{
				switch (file.extension.toLowerCase())
				{   
					case "swf" :
					case "jpg" :
					case "jpeg" :
					case "png" :
					case "bmp" :
					case "gif" :
						addFile(file);
						break;
					default:
						Alert.show("Unsupported file format (."+file.extension.toLowerCase()+")","Error");
				}
			}
		}
		
		private function onDragIn(event:NativeDragEvent):void
		{
			DragManager.acceptDragDrop(event.currentTarget as IUIComponent);
		}
	}
}