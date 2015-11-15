Hotkeys(win,item,track:=0){
	static last:=[],current
	if(track)
		while,off:=last.pop(){
			Hotkey,IfWinActive,% hwnd([off.win])
			Hotkey,% off.key,Off
			v.hotkeyobj.Delete(off.key)
		}
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
			Hotkey,%key%,%launch%,On
			if(track)
				last.push({win:b,key:key})
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
	current:=A_ThisHotkey
	func:=v.pluginobj[current]
	if(IsFunc(func))
		return %func%()
	ea:=menus.ea("//*[@hotkey='" current "']")
	if(ea.plugin){
		if(!FileExist(ea.plugin))
			MissingPlugin(ea.plugin,ea.clean)
		else
			Run,% Chr(34) ea.plugin Chr(34) " " Chr(34) ea.option Chr(34)
	}else if(IsLabel(ea.clean)||IsFunc(ea.clean))
		SetTimer,% ea.clean,-10
	return
}