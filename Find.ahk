Find(){
	static
	sc:=csc(),order:=[],file:=current(2).file,infopos:=positions.ssn("//*[@file='" file "']"),last:=ssn(infopos,"@search").text,search:=last?last:"Type in your query here",ea:=settings.ea("//search/find"),newwin:=new GUIKeep(5),value:=[],order[sc.2585(0)]:=1,order[sc.2587(0)]:=1,last:=(order.MinIndex()!=order.MaxIndex())?sc.textrange(order.MinIndex(),order.MaxIndex()):last
	for a,b in ea
		value[a]:=b?"Checked":""
	newwin.Add("Edit,gfindcheck w400 vfind r1,,w","TreeView,w400 h200 AltSubmit gstate,,wh","Checkbox,vregex " value.regex ",Regex Search,y","Checkbox,vgr x+10 " value.gr ",Greed,y","Checkbox,xm vcs " value.cs ",Case Sensitive,y","Checkbox,vsort gfsort " value.sort ",Sort by Segment,y","Checkbox,vallfiles " value.allfiles ",Search in All Files,y","Checkbox,vacdc " value.acdc ",Auto Close on Double Click,y","Button,gsearch Default,   Search   ,y","Button,gcomment,Toggle Comment,y"),newwin.Show("Search"),hotkeys([5],{"^Backspace":"findback"})
	if(value.regex&&order.MinIndex()!=order.MaxIndex())
		for a,b in StrSplit("\.*?+[{|()^$")
			StringReplace,last,last,%b%,\%b%,All
	ControlSetText,Edit1,%last%,% hwnd([5])
	ControlSend,Edit1,^a,% hwnd([5])
	Gui,1:-Disabled
	return
	OnClipboardChange:
	if(hwnd(5)||hwnd(30)){
		win:=hwnd(5)?hwnd([5]):hwnd([30])
		ControlSetText,Edit1,%Clipboard%,%win%
	}
	return
	findback:
	GuiControl,5:-Redraw,Edit1
	ControlSend,Edit1,^+{Left}{Backspace},% hwnd([5])
	GuiControl,5:+Redraw,Edit1
	return
	findcheck:
	ControlGetText,Button,Button7,% hwnd([5])
	if(Button!="search")
		ControlSetText,Button7,Search,% hwnd([5])
	return
	search:
	ControlGetText,Button,Button7,% hwnd([5])
	if(InStr(button,"search")){
		ea:=newwin[],count:=0
		if(!find:=ea.find)
			return
		infopos.setattribute("search",find),foundinfo:=[]
		Gui,5:Default
		GuiControl,5:+g,SysTreeView321
		GuiControl,5:-Redraw,SysTreeView321
		list:=ea.allfiles?files.sn("//file/@file"):sn(current(1),"descendant::file/@file"),contents:=update("get").1,TV_Delete()
		pre:="m`nO",pre.=ea.cs?"":"i",pre.=ea.greed?"":"U",parent:=0,ff:=ea.regex?find:"\Q" find "\E"
		while,l:=list.item(A_Index-1){
			out:=contents[l.text],found:=1,r:=0,fn:=l.text
			SplitPath,fn,file
			while,found:=RegExMatch(out,pre ")(^.*" ff ".*$)",pof,found){
				parentfile:=files.ssn("//*[@file='" fn "']/ancestor::main/@file").text
				if(ea.sort&&lastl!=fn)
					parent:=TV_Add(RelativePath(parentfile,fn))
				np:=found=1?0:StrPut(SubStr(out,1,found),"utf-8")-1-(StrPut(SubStr(pof.1,1,1),"utf-8")-1)
				fpos:=1
				while,fpos:=RegExMatch(pof.1,pre ")[^.*]?(" ff ")",loof,fpos){
					add:=loof.Pos(1)-1,foundinfo[TV_Add(loof.1 " : " Trim(pof.1,"`t"),parent)]:={start:np+add,end:np+add+StrPut(loof.1,"Utf-8")-1,file:l.text}
					fpos+=StrLen(loof.1)
				}
				found:=pof.Pos(1)+pof.len(1)-1
				lastl:=fn,count++
			}
		}
		WinSetTitle,% hwnd([5]),,Find : %count%
		if(TV_GetCount())
			ControlFocus,SysTreeView321
		GuiControl,5:+Redraw,SysTreeView321
		SetTimer,findlabel,-200
		GuiControl,5:+gstate,SysTreeView321
	}else if(Button="jump"){
		Gui,1:+Disabled
		ea:=foundinfo[TV_GetSelection()],SetPos(ea),xpos:=sc.2164(0,ea.start),ypos:=sc.2165(0,ea.start)
		Sleep,300
		WinGetPos,xx,yy,ww,hh,% newwin.ahkid
		WinGetPos,px,py,,,% "ahk_id" sc.sc
		WinGet,trans,Transparent,% newwin.ahkid
		cxpos:=px+xpos,cypos:=py+ypos
		if(cxpos>xx&&cxpos<xx+ww&&cypos>yy&&cypos<yy+hh)
			WinSet,Transparent,50,% newwin.ahkid
		else if(trans=50)
			WinSet,Transparent,255,% newwin.ahk
	}else{
		sel:=TV_GetSelection(),TV_Modify(sel,ec:=TV_Get(sel,"E")?"-Expand":"Expand")
		SetTimer,findlabel,-200
	}
	return
	state:
	if(A_GuiEvent="DoubleClick"){
		info:=newwin[]
		ea:=foundinfo[TV_GetSelection()]
		Sleep,200
		SetPos({start:ea.start,end:ea.end,file:ea.file})
		if(info.acdc)
			goto,5GuiClose
	}if(A_GuiEvent=="f")
		return
	sel:=TV_GetSelection()
	Gui,5:TreeView,SysTreeView321
	if(refreshing)
		return
	ControlGetFocus,focus,% hwnd([5])
	SetTimer,findlabel,-200
	if(v.options.auto_close_find){
		hwnd({rem:5})
	}else
		WinActivate,% hwnd([5])
	return
	findlabel:
	Gui,5:Default
	sel:=TV_GetSelection()
	if(!TV_GetCount())
		Buttontext:="Search"
	else if(TV_GetChild(sel))
		Buttontext:=TV_Get(sel,"E")?"Contract":"Expand"
	else if(TV_GetCount()&&TV_GetChild(sel)=0)
		Buttontext:="Jump"
	ControlSetText,Button7,%Buttontext%,% hwnd([5])
	return
	fsort:
	ControlSetText,Button7,Search,% hwnd([5])
	goto,search
	return
	5GuiEscape:
	5GuiClose:
	Gui,5:Submit,NoHide
	ea:=newwin[],settings.add("search/find",{acdc:ea.acdc,regex:ea.regex,cs:ea.cs,sort:ea.sort,gr:ea.gr,allfiles:ea.allfiles}),foundinfo:="",positions.ssn("//*[@file='" file "']/@search").text:=ea.find,hwnd({rem:5})
	return
	comment:
	sc:=csc()
	toggle_comment_line()
	return
}