Close(x:=1,all:=""){
	if(x=1)
		save()
	Gui,1:Default
	Gui,1:TreeView,SysTreeView321
	GuiControl,1:-Redraw,SysTreeView321
	all:=all?"/@file":"[@file='" current(2).file "']/@file"
	close:=files.sn("//main" all)
	up:=update("get")
	while,file:=close.item[A_Index-1],file:=file.text{
		rem:=cexml.ssn("//main[@file='" file "']"),rem.ParentNode.RemoveChild(rem),all:=files.sn("//main[@file='" file "']/descendant::file"),Previous_Scripts(file),rem:=settings.ssn("//open/file[text()='" file "']"),rem.ParentNode.RemoveChild(rem)
		while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
			if(A_Index>1)
				TV_Delete(ea.tv)
			up.1.Delete(ea.file),up.2.Delete(ea.file)
		}
		main:=all.item[0]
		TV_Delete(ssn(main,"@tv").text)
	}
	while,file:=close.item[A_Index-1],file:=file.text
		rem:=files.ssn("//main[@file='" file "']"),rem.ParentNode.RemoveChild(rem)
	GuiControl,1:+Redraw,SysTreeView321
	if(!files.sn("//main").length)
		New(1)
}
Close_All(){
	Close(1,1),New(1)
}