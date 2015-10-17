Scintilla_Code_Lookup(){
	static slist,cs,newwin
	scintilla(),slist:=scintilla.sn("//commands/item")
	newwin:=new GUIKeep(8)
	newwin.Add("Edit,Uppercase w500 gcodesort vcs,,w","ListView,w720 h500 -Multi,Name|Code|Syntax,wh","Radio,xm Checked gcodesort,&Commands,y","Radio,x+5 gcodesort,C&onstants,y","Radio,x+5 gcodesort,&Notifications,y","Button,xm ginsert Default,Insert code into script,y","Button,gdocsite,Goto Scintilla Document Site,y")
	while,sl:=slist.item(A_Index-1)
		LV_Add("",ssn(sl,"@name").text,ssn(sl,"@code").text,ssn(sl,"@syntax").text)
	newwin.Show("Scintilla Code Lookup")
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	hotkeys([8],{up:"page",down:"page",PgDn:"page",PgUp:"page"})
	return
	page:
	ControlSend,SysListView321,{%A_ThisHotkey%},% newwin.id
	return
	docsite:
	Run,http://www.scintilla.org/ScintillaDoc.html
	return
	codesort:
	cs:=newwin[].cs
	Gui,8:Default
	GuiControl,1:-Redraw,SysListView321
	LV_Delete()
	for a,b in {1:"commands",2:"constants",3:"notifications"}{
		ControlGet,check,Checked,,Button%a%,% hwnd([8])
		value:=b
		if(Check)
			break
	}
	slist:=scintilla.sn("//" value "/*[contains(@name,'" cs "')]")
	while,(sl:=xml.ea(slist.item(A_Index-1))).name
		LV_Add("",sl.name,sl.code,sl.syntax)
	LV_Modify(1,"Select Vis Focus")
	Loop,3
		LV_ModifyCol(A_Index,"AutoHDR")
	GuiControl,1:+Redraw,SysListView321
	return
	insert:
	LV_GetText(code,LV_GetNext(),2),hwnd({rem:8}),sc:=csc(),sc.2003(sc.2008,[code]),npos:=sc.2008+StrLen(code),sc.2025(npos)
	return
	lookupud:
	Gui,8:Default
	count:=A_ThisHotkey="up"?-1:+1,pos:=LV_GetNext()+count<1?1:LV_GetNext()+count,LV_Modify(pos,"Select Focus Vis")
	return
	8GuiClose:
	8GuiEscape:
	hwnd({rem:8})
	return
}