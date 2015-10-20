Refresh_Current_Project(){
	GuiControl,1:+g,SysTreeView321
	current:=current(2).file
	file:=current(3).file
	close()
	open(current,1)
	GuiControl,1:+gtv,SysTreeView321
	tv(files.ssn("//main[@file='" current "']/descendant::file[@file='" file "']/@tv").text)
}