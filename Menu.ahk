Menu(menuname){
	v.available:=[],menu:=menus.sn("//" menuname "/descendant::*"),topmenu:=menus.sn("//" menuname "/*"),v.hotkeyobj:=[]
	Menu,main,UseErrorLevel,On
	while,mm:=topmenu.item[A_Index-1],ea:=xml.ea(mm)
		if(mm.haschildnodes())
			Menu,% ea.name,DeleteAll
	Menu,main,DeleteAll
	topmenus:=[]
	while,mm:=menu.item[A_Index-1],ea:=xml.ea(mm){
		if(mm.nodename="separator")
			Menu,%parentmenu%,Add
		if(ea.hide)
			Continue
		parentmenu:=ssn(mm.ParentNode,"@name").text,parentmenu:=parentmenu?parentmenu:menuname
		if(mm.haschildnodes()){
			Menu,%parentmenu%,Add,% ea.name,deadend
			topmenus.Insert({name:ea.name,parent:parentmenu})
		}else if(ea.name){
			if((!IsFunc(ea.clean)&&!IsLabel(ea.clean))&&!FileExist(ea.plugin))
				Continue
			hotkey:=ea.hotkey?"`t" convert_hotkey(ea.hotkey):"",v.available[ea.clean]:=1
			if(ea.hotkey)
				v.hotkeyobj[ea.hotkey]:=ea.clean
			Menu,%parentmenu%,Add,% ea.name hotkey,MenuRoute
			if(value:=settings.ssn("//*/@" ea.clean).text){
				v.options[ea.clean]:=value
				Menu,%parentmenu%,ToggleCheck,% ea.name hotkey
			}
		}
		Menu,%Parentmenu%,Icon,% ea.name hotkey,% ea.filename,% ea.icon
	}
	for a,b in topmenus
		Menu,% b.parent,Add,% b.name,% ":" b.name
	hotkeys([1],v.hotkeyobj)
	return menuname
	MenuRoute:
	item:=clean(A_ThisMenuItem),ea:=menus.ea("//*[@clean='" item "']"),plugin:=ea.plugin,option:=ea.option
	if(plugin){
		Run,"%plugin%" %option%
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