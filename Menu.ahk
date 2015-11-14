Menu(menuname:="main"){
	v.available:=[],menu:=menus.sn("//" menuname "/descendant::*"),topmenu:=menus.sn("//" menuname "/*"),v.hotkeyobj:=[],track:=[],exist:=[],Exist[menuname]:=1
	Menu,%menuname%,UseErrorLevel,On
	while,mm:=topmenu.item[A_Index-1],ea:=xml.ea(mm)
		if(mm.haschildnodes())
			Menu,% ea.name,DeleteAll
	Menu,%menuname%,DeleteAll
	while,aa:=menu.item[A_Index-1],ea:=xml.ea(aa),pea:=xml.ea(aa.ParentNode){
		parent:=pea.name?pea.name:menuname
		if(ea.hide)
			Continue
		if(!aa.haschildnodes()){
			if(aa.nodename="separator"){
				Menu,%parent%,Add
				Continue
			}
			if((!IsFunc(ea.clean)&&!IsLabel(ea.clean))&&!ea.plugin){
				aa.SetAttribute("no",1),fixlist.=ea.clean "`n"
				Continue
			}if(ea.no)
				aa.RemoveAttribute("no")
			exist[parent]:=1
		}v.available[ea.clean]:=1
		(aa.haschildnodes())?(track.push({name:ea.name,parent:parent,clean:ea.clean}),route:="deadend"):(route:="MenuRoute")
		if(ea.hotkey)
			v.hotkeyobj[ea.hotkey]:=ea.clean
		hotkey:=ea.hotkey?"`t" convert_hotkey(ea.hotkey):""
		Menu,%parent%,Add,% ea.name hotkey,menuroute
		if(value:=settings.ssn("//*/@" ea.clean).text){
			v.options[ea.clean]:=value
			Menu,%parent%,ToggleCheck,% ea.name hotkey
		}if(ea.icon!=""&&ea.filename)
			Menu,%Parent%,Icon,% ea.name hotkey,% ea.filename,% ea.icon
	}
	;m(Clipboard:=fixlist)
	for a,b in track{
		if(!Exist[b.name])
			Menu,% b.parent,Delete,% b.name
		Menu,% b.parent,Add,% b.name,% ":" b.name
	}
	hotkeys([1],v.hotkeyobj,1)
	Gui,1:Menu,%menuname%
	return menuname
	MenuRoute:
	item:=clean(A_ThisMenuItem),ea:=menus.ea("//*[@clean='" item "']"),plugin:=ea.plugin,option:=ea.option
	if(plugin){
		if(!FileExist(plugin))
			MissingPlugin(plugin)
		else
			Run,"%plugin%" %option%
		; , , ,
		return
	}
	if(IsFunc(item))
		%item%()
	else
		SetTimer,%item%,-1
	return
	show:
	WinActivate,% hwnd([1])
	return
}