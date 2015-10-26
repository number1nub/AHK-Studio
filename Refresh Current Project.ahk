Refresh_Current_Project(file:=""){
	GuiControl,1:+g,SysTreeView321
	GuiControl,1:-Redraw,SysTreeView321
	current:=current(2).file,file:=file?file:current(3).file,Close(1,,0),open(current,0,0)
	GuiControl,1:+gtv,SysTreeView321
	tv(files.ssn("//main[@file='" current "']/descendant::file[@file='" file "']/@tv").text)
	GuiControl,1:+Redraw,SysTreeView321
}