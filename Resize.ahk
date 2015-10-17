Resize(info*){
	static
	static width,height,flip:={x:"w",y:"h"}
	if(info.2>>16&&A_Gui=1)
		height:=info.2>>16?info.2>>16:height,width:=info.2&0xffff?info.2&0xffff:width
	if(i:=GuiKeep.current(A_Gui)){
		wid:=info.2&0xffff,hei:=info.2>>16
		if(wid=""||hei="")
			return
		for a,b in i.gui
			for c,d in b{
				if(c~="y|h")
					GuiControl,MoveDraw,%a%,% c hei+d-(c="y"?i.border:0)
				else
					GuiControl,MoveDraw,%a%,% c wid+d
			}
		return
	}
	if(info.1="get"){
		WinGetPos,x,y,,,% hwnd([1])
		return size:="x" x " y" y " w" width " h" height
	}
	if(A_Gui=1||info.1="rebar"){
		if(info.1="rebar")
			wp:=winpos(),width:=wp.w,height:=wp.h
		height:=info.2>>16?info.2>>16:height,width:=info.2&0xffff?info.2&0xffff:width
		SendMessage,0x400+27,0,0,,% "ahk_id" rebar.hw.1.hwnd
		rheight:=ErrorLevel
		SetTimer,rsize,-100
	}
	return
	rsize:
	WinGet,cl,ControlListHWND,% hwnd([1])
	ControlMove,,,,%width%,,% "ahk_id" rebar.hw.1.hwnd
	ControlGetPos,,y,,h,,% "ahk_id" rebar.hw.1.hwnd
	ControlGetPos,,,,eh,Edit1,% hwnd([1])
	;Gui,1:Color,% v.options.top_find?"E1E6F6":"F1EDED",White	;#[ADDED: Quick Find colors customized based on top/bottom]
	hh:=height-v.status-rheight-v.menu-(v.dbgsock>0?200:0)
	v.options.Top_Find?(fy:=y+h,top:=y+h+eh,td:=hh+top):(fy:=hh+y+h,hh:=hh,top:=y+h,td:=hh+top+eh)
	for a,b in s.main
		GuiControl,-Redraw,% b.sc
	start:=project:=v.options.Hide_Project_Explorer?0:settings.get("//gui/@projectwidth",200),code:=v.options.Hide_Code_Explorer?0:settings.get("//gui/@codewidth",200)
	ControlMove,SysTreeView321,,%top%,%project%,%hh%,% hwnd([1])
	ControlMove,SysTreeView322,width-code+v.Border,top,%code%,%hh%,% hwnd([1])
	div:=s.main.MaxIndex(),left:=width-project-code
	for a,b in s.main{
		ControlMove,,start+v.Border,top,% A_Index=div?(Floor(left/div)+(left-Floor(left/div)*div)):Floor(left/div),%hh%,% "ahk_id" b.sc
		start+=Floor(left/div)
	}
	ControlMove,Static1,,% fy+4,,,% hwnd([1])
	ControlMove,Edit1,,%fy%,% width-330,,% hwnd([1])
	Loop,4{
		if(A_Index=1){
			ControlGetPos,x,,w,,Edit1,% hwnd([1])
			start:=x+w+2
		}else{
			ControlGetPos,,,w,,% "Button" A_Index-1,% hwnd([1])
			start+=w+2
		}
		ControlMove,Button%A_Index%,%start%,% fy+4,,,% hwnd([1])
	}
	if(v.debug.sc)
		ControlMove,,% v.border,%td%,%width%,% _:=v.dbgsock>0?200:0,% "ahk_id" v.debug.sc
	for a,b in s.main
		GuiControl,+Redraw,% b.sc
	WinSet,Redraw,,% hwnd([1])
	return
}