Gui(){
	static
	static controls:=["Static1","Edit1","Button1","Button2","Button3","Button4"]
	Gui,+hwndhwnd +Resize +OwnDialogs
	hwnd(1,hwnd),rb:=new rebar(1,hwnd),v.rb:=rb,pos:=settings.ssn("//gui/position[@window='1']")
	OnMessage(6,"Activate"),v.opening:=1
	Gui,Margin,0,0
	Gui,Add,TreeView,xm hwndce c0xff00ff w150
	Gui,Add,TreeView,hwndpe c0xff00ff w150 gcej
	sc:=new s(1,{pos:"w200 h200",main:1}),TV_Add("Right Click to refresh")
	Gui,Add,Text,xm+3 c0xAAAAAA,Quick Find
	Gui,Add,Edit,x+2 w200 c0xAAAAAA gqf
	ea:=settings.ea("//Quick_Find_Settings")
	for a,b in ["Regex","Case Sensitive","Greed","Multi Line"]{
		checked:=ea[clean(b)]?"Checked":"",v.options[clean(b)]:=ea[clean(b)]
		Gui,Add,Checkbox,x+3 c0xAAAAAA gqfs %Checked%,%b%
	}
	Hotkey,IfWinActive,% hwnd([1])
	Hotkey,!q,Quick_Find,On
	enter:=[]
	for a,b in ["+","!","^","~"]
		Enter[b "Enter"]:="checkqf",Enter[b "NumpadEnter"]:="checkqf"
	Enter["~Escape"]:="Escape",Enter["^a"]:="SelectAll",Enter["^v"]:="menupaste"
	for a,b in StrSplit("WheelLeft,WheelRight",",")
		Enter[b]:="scrollwheel"
	;start
	bar:=[],band:=[]
	if(rem:=settings.ssn("//rebar/band[@id='11000']"))
		rem.ParentNode.RemoveChild(rem)
	bar.10000:=[[4,"shell32.dll","Open","Open",10000,4],[8,"shell32.dll","Save","Save",10001,4],[137,"shell32.dll","Run","Run",10003,4],[249,"shell32.dll","Check_For_Update","Check For Update",10004,4],[100,"shell32.dll","New_Scintilla_Window","New Scintilla Window",10005,4],[271,"shell32.dll","Remove_Scintilla_Window","Remove Scintilla Window",10006,4]],bar.10001:=[[110,"shell32.dll","open_folder","Open Folder",10000,4],[135,"shell32.dll","google_search_selected","Google Search Selected",10001,4]],bar.10002:=[[18,"shell32.dll","Connect","Connect",10000,4],[22,"shell32.dll","Debug_Current_Script","Debug Current Script",10001,4],[21,"shell32.dll","ListVars","List Variables",10002,4],[137,"shell32.dll","Run_Program","Run Program",10003,4],[27,"shell32.dll","stop","Stop",10004,4]]
	if(!toolbarobj:=settings.ssn("//toolbar")){
		temp:=new xml("temp"),top:=temp.ssn("//*"),tbo:=temp.under(top,"toolbar")
		for a,b in bar{
			btop:=temp.under(tbo,"bar",{id:a})
			for c,d in b{
				att:=[]
				for e,f in ["icon","file","func","text","id","state"]
					att[f]:=d[A_Index]
				att["vis"]:=1
				temp.under(btop,"button",att)
			}
		}
		temp.transform(),top:=temp.ssn("//toolbar"),main:=settings.ssn("//*"),main.AppendChild(top)
		toolbarobj:=settings.ssn("//toolbar")
	}
	;redo this
	ControlGetPos,,,,h,,ahk_id%edit%
	band.10000:={id:10000,vis:1,width:263},band.10001:={id:10001,vis:1,width:150},band.10002:={id:10002,vis:0,width:200}
	if(!settings.ssn("//rebar"))
		for a,b in band
			if(!settings.ssn("//rebar/band[@id='" a "']"))
				settings.Add("rebar/band",{id:a,width:b.width,vis:b.vis},,1)
	toolbars:=settings.sn("//toolbar/bar"),bands:=settings.sn("//rebar/descendant::*")
	while,bb:=toolbars.item[A_Index-1]{
		buttons:=sn(bb,"*"),tb:=new toolbar(1,hwnd,ssn(bb,"@id").text)
		while,button:=buttons.item[A_Index-1]
			tb.add(xml.ea(button))
	}
	visible:=settings.sn("//toolbar/*/*[@vis='1']")
	while,vis:=Visible.item[A_Index-1]
		tb:=toolbar.list[ssn(vis.parentnode,"@id").text],tb.addbutton(ssn(vis,"@id").text)
	while,bb:=bands.item[A_Index-1],ea:=xml.ea(bb){
		if(bb.nodename="newline"){
			newline:=1
			continue
		}
		if(ea.id=11000)
			ea:=band[ea.id]
		if(!ea.width)
			ea.width:=toolbar.list[ea.id].barinfo().ideal+20
		rb.add(ea,newline),newline:=0
	}
	hide:=settings.sn("//rebar/descendant::*[@vis='0']")
	while,hh:=hide.item[A_Index-1],ea:=xml.ea(hh)
		rb.hide(ea.id)
	;/redo this
	;/end
	Gui,Add,StatusBar,hwndstatus
	ControlGetPos,,,,h,,ahk_id%status%
	v.status:=h
	Menu("main"),max:=ssn(pos,"@max").text?"Maximize":"",pos:=pos.text?pos.text:"w750 h500"
	Gui,Show,%pos% Hide,AHK Studio
	WinSetTitle,% hwnd([1]),,AHK Studio - Indexing Lib Files
	Index_Lib_Files(),OnMessage(5,"Resize"),open:=settings.sn("//open/file"),options()
	Gui,1:Show,%pos% %max% Hide,AHK Studio
	Margin_Left(1),csc().2400,BraceSetup(1),SetMatch(),Resize("rebar")
	SetTimer,rsize,-0
	Gui,Show,%max%
	RefreshThemes(),debug.off()
	while,oo:=open.item[A_Index-1]{
		if(!FileExist(oo.text)){
			rem:=settings.sn("//file[text()='" oo.text "']")
			while,rr:=rem.item[A_Index-1]
				rr.ParentNode.RemoveChild(rr)
		}else
			openfilelist.=oo.text "`n"
	}
	hk(1),hotkeys([1],enter)
	if(openfilelist){
		Open(trim(openfilelist,"`n"))
	}else
		New(1)
	if(last.length>1){
		while,file:=last.item[A_Index-1]{
			if(A_Index=1)
				Continue
			New_Scintilla_Window(file.text)
		}
		csc({hwnd:s.main.1.sc}).2400
	}
	SetTimer,scanfiles,-100
	WinSet,Redraw,,% hwnd([1])
	OnExit,Exit
	v.opening:=0
	GuiControl,1:+gtv,SysTreeView321
	if(select:=settings.ssn("//open/file[@select='1']"))
		tv(files.ssn("//file[@file='" select.text "']/@tv").text,1)
	else if(select:=settings.ssn("//last/file").text)
		tv(files.ssn("//file[@file='" select "']/@tv").text,1)
	else
		tv(files.ssn("//file[@tv!='']/@tv").text,1)
	while,ss:=settings.ssn("//open/file[@select='1']")
		ss.RemoveAttribute("select")
	csc(1)
	return
	GuiClose:
	SetTimer,Exit,-1
	return
}