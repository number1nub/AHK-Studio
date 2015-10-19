Testing(x:=0){
	newwin:=new GUIKeep("flan")
	newwin.add("Edit,w200 h200,,wh","Button,,button,y")
	newwin.show("flan window!")
	return
	flanGuiEscape:
	Gui,flan:Destroy
	Gui,1:-Disabled
	WinActivate,% hwnd([1])
	return
	;m("Testing","ico:?")
}