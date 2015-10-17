Hotkeys(win,item,On:="On"){
	for key,label in item{
		label:=clean(label)
		if(IsFunc(label))
			launch:="function"
		if(IsLabel(label))
			launch:=label
		if(launch=""&&key)
			launch:="pluginlaunch"
		for a,b in win{
			if(!hwnd(b))
				Break
			Hotkey,IfWinActive,% hwnd([b])
			Hotkey,%key%,%launch%,%On%
		}launch:=""
	}
	Hotkey,IfWinActive
	return
	hotkey:
	ControlFocus,Edit1,% hwnd([1])
	return
	function:
	func:=v.hotkeyobj[A_ThisHotkey]
	if(IsFunc(func))
		%Func%()
	else
		func:=RegExReplace(A_ThisHotkey,"\W"),%func%()
	return
	pluginlaunch:
	func:=v.pluginobj[A_ThisHotkey]
	if(IsFunc(func))
		return %func%()
	ea:=menus.ea("//*[@hotkey='" A_ThisHotkey "']")
	if(ea.plugin)
		Run,% Chr(34) ea.plugin Chr(34) " " Chr(34) ea.option Chr(34)
	else if(IsLabel(ea.clean)||IsFunc(ea.clean))
		SetTimer,% ea.clean,-10
	return
}