Plugins(refresh:=0){
	Plugins:
	if(!FileExist("plugins"))
		FileCreateDir,Plugins
	plHks:=[]
	if(refresh){
		while,pl:=menus.sn("//menu[@clean='Plugin']/menu[@hotkey!='']").item[A_Index-1],ea:=xml.ea(pl)
			plHks[ea.name]:=ea.hotkey
		rem:=menus.ssn("//menu[@clean='Plugin']"),rem.ParentNode.RemoveChild(rem)
	}all:=menus.sn("//*[@clean]")
	while,aa:=all.item[A_Index-1],ea:=menus.ea(aa)
		if((dup:=menus.sn("//*[@clean='" ea.clean "']")).length>1)
			while,dd:=dup.item[A_Index-1]
				if(A_Index>1)
					dd.ParentNode.RemoveChild(dd)
	pin:=menus.sn("//*[@clean='Plugin']/descendant::menu")
	while,pp:=pin.item[A_Index-1],ea:=xml.ea(pp)
		if(!FileExist(ea.plugin))
			pp.ParentNode.RemoveChild(pp)
	if(!menus.sn("//*[@clean='Plugin']/descendant::menu").length)
		rem:=menus.ssn("//*[@clean='Plugin']"),rem.ParentNode.RemoveChild(rem)
	Loop,plugins\*.ahk
	{
		if(!plugin:=menus.ssn("//menu[@clean='Plugin']"))
			plugin:=menus.Add("menu",{clean:"Plugin",name:"P&lugin"},,1)
		FileRead,plg,%A_LoopFileFullPath%
		pos:=1
		while,pos:=RegExMatch(plg,"Oim)\;menu\s+(.*)\R",found,pos){
			item:=StrSplit(found.1,","),item.1:=Trim(item.1,"`r|`r`n|`n")
			if(!ii:=menus.ssn("//*[@clean='" clean(Trim(item.1)) "']"))
				menus.under(plugin,"menu",{name:Trim(item.1),clean:clean(item.1),plugin:A_LoopFileFullPath,option:item.2,hotkey:plHks[item.1]})
			else
				ii.SetAttribute("plugin",A_LoopFileFullPath)
			pos:=found.Pos(1)+1
		}
	}
	if(refresh)
		SetTimer,refreshmenu,-300
	return
	refreshmenu:
	Menu("main"),MenuWipe(),omni_search_class.Menus()
	Gui,1:Menu,% Menu("main")
	return
}