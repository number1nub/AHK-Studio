hwnd(win,hwnd=""){
	static window:=[]
	if win=get
		return window
	if(win.rem){
		GUIKeep.save(win.rem)
		Gui,1:-Disabled
		if(!window[win.rem])
			Gui,% win.rem ":Destroy"
		Else
			DllCall("DestroyWindow",uptr,window[win.rem])
		window[win.rem]:=""
		WinActivate,% hwnd([1])
	}
	if IsObject(win)
		return "ahk_id" window[win.1]
	if !hwnd
		return window[win]
	window[win]:=hwnd
}