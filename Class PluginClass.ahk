Class PluginClass{
	__New(){
		return this
	}
	file(){
		return A_ScriptFullPath
	}
	path(){
		return A_ScriptDir
	}
	SetTimer(timer,period:=-10){
		period:=period>0?-period:period
		SetTimer,%timer%,%period%
	}
	debugwindow(){
		v.debug:=new s(1,{pos:"w200 h200"}),Resize("rebar")
	}
	AutoClose(script){
		if(!this.Close[script])
			this.Close[script]:=1
	}
	Color(con){
		v.con:=con
		SetTimer,Color,-1
		Sleep,10
		v.con:=""
	}
	Focus(){
		ControlFocus,Scintilla1,% hwnd([1])
		GuiControl,+Redraw,Scintilla1
		Gui,1:Default
		Gui,1:TreeView,SysTreeView321
		setpos(TV_GetSelection()),csc(1)
	}
	update(filename,text){
		update({file:filename,text:text})
	}
	Show(){
		sc:=csc()
		WinActivate,% hwnd([1])
		GuiControl,+Redraw,% sc.sc
		setpos(sc.2357),sc.2400
	}
	Style(){
		return ea:=settings.ea(settings.ssn("//fonts/font[@style='5']")),ea.color:=RGB(ea.color),ea.Background:=RGB(ea.Background)
	}
	TrayTip(info){
		TrayTip,AHK Studio,%info%,2
	}
	csc(obj,hwnd){
		csc({plugin:obj,hwnd:hwnd})
	}
	MoveStudio(){
		version:=";auto_version"
		SplitPath,A_ScriptFullPath,,,,name
		FileMove,%A_ScriptFullPath%,%name%-%version%.ahk,1
	}
	version(){
		return ";auto_version"
	}
	EnableSC(x:=0){
		sc:=csc()
		if(x){
			GuiControl,1:+Redraw,% sc.sc
			GuiControl,1:+gnotify,% sc.sc
		}else{
			;GuiControl,1:-Redraw,% sc.sc
			GuiControl,1:+g,% sc.sc
		}
	}
	Publish(info:=0){
		return,Publish(info)
	}
	Hotkey(win:=1,key:="",label:="",on:=1){
		if(!(win,key,label))
			return m("Unable to set hotkey")
		Hotkey,IfWinActive,% hwnd([win])
		Hotkey,%key%,%label%,% _:=on?"On":"Off"
	}
	save(){
		save()
	}
	sc(){
		return csc()
	}
	hwnd(win:=1){
		return hwnd(win)
	}
	get(name){
		return _:=%name%
	}
	tv(tv){
		return tv(tv)
	}
	Current(x:=""){
		return current(x)
	}
	m(info*){
		m(info*)
	}
	allctrl(code,lp,wp){
		for a,b in s.ctrl
			b[code](lp,wp)
	}
	DynaRun(script){
		return DynaRun(script)
	}
	activate(){
		WinActivate,% hwnd([1])
	}
	call(info*){
		;this can cause major errors
		if(IsFunc(info.1)&&info.1~="i)(Fix_Indent|newindent)"=0){
			func:=info.1,info.Remove(1)
			return %func%(info*)
		}
		SetTimer,% info.1,-100
	}
	Plugin(action,hwnd){
		SetTimer,%action%,-10
	}
	open(info){
		tv:=open(info),tv(tv)
		WinActivate,% hwnd([1])
	}
	GuiControl(info*){
		GuiControl,% info.1,% info.2,% info.3
	}
	ssn(node,path){
		return node.SelectSingleNode(path)
	}
	__Call(x*){
		m(x)
	}
	__Delete(){
		;m("ok")
	}
	StudioPath(){
		return A_ScriptFullPath
	}
	files(){
		return update("get").1
	}
	SetText(contents){
		length:=VarSetCapacity(text,strput(contents,"utf-8")),StrPut(contents,&text,length,"utf-8")
		csc().2181(0,&text)
	}
	ReplaceSelected(text){
		csc().2170(0,&text:=encode(text))
	}
}