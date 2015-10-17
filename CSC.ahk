csc(set:=0){
	static current
	if(set.plugin)
		return current:=set.plugin
	if(get.hwnd)
		return s.ctrl[get.hwnd]
	if(set.hwnd)
		current:=s.ctrl[set.hwnd]
	if(InStr(set,"Scintilla")){
		ControlGet,hwnd,hwnd,,%set%,% hwnd([1])
		current:=s.ctrl[hwnd]
	}if(set=1){
		ControlGet,hwnd,hwnd,,Scintilla1,% hwnd([1])
		current:=s.ctrl[hwnd]
	}if(set){
		ControlGet,hwnd,hwnd,,%set%,% hwnd([1])
		current:=s.ctrl[hwnd]
	}if(!current.sc){
		ControlGet,hwnd,hwnd,,Scintilla1,% hwnd([1])
		current:=s.ctrl[hwnd]
	}return current
}