csc(set:=0){
	static current
	if(set.plugin)
		return current:=set.plugin
	if(set.hwnd)
		current:=s.ctrl[set.hwnd]
	if(set=1||!current.sc||InStr(set,"Scintilla")){
		ControlGet,hwnd,hwnd,,Scintilla1,% hwnd([1])
		current:=s.ctrl[hwnd]
		if(!current.sc)
			current:=s.main.1,current.2400()
	}
	return current
}