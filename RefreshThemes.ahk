RefreshThemes(){
	Refresh()
	if(node:=settings.ssn("//fonts/custom[@gui='1' and @control='msctls_statusbar321']"))
		SetStatus(node)
	else
		SetStatus(settings.ssn("//fonts/font[@style='5']"))
	default:=ea:=settings.ea("//fonts/font[@style='5']")
	for win,b in hwnd("get"){
		if(win>99)
			return
		cea:=settings.ea("//fonts/find"),tf:=v.options.top_find,bcolor:=(cea.tb!=""&&tf)?cea.tb:(cea.bb&&tf!=1)?cea.bb:ea.Background,fcolor:=(cea.tf!=""&&tf)?cea.tf:(cea.tf&&tf!=1)?cea.bf:ea.Color
		WinGet,controllist,ControlList,% "ahk_id" b
		Gui,%win%:Default
		Gui,Color,% RGB(bcolor),% RGB(bcolor)
		loop,Parse,ControlList,`n
		{
			if((A_LoopField~="i)Static1|Button|Edit1")&&win=1)
				GuiControl,% "1:+background" RGB(bcolor) " c" rgb(fcolor),%A_LoopField%
			else{
				if(node:=settings.ssn("//fonts/custom[@gui='" win "' and @control='" A_LoopField "']"))
					text:=CompileFont(node),ea:=xml.ea(node)
				else
					text:=CompileFont(node:=settings.ssn("//fonts/font[@style='5']")),ea:=xml.ea(node)
				Gui,%win%:font,%text%,% ea.font
				GuiControl,% "+background" RGB(ea.Background!=""?ea.Background:default.Background) " c" rgb(ea.color),%A_LoopField%
				GuiControl,% "font",%A_LoopField%
			}
		}
	}
	if(settings.ssn("//fonts/font[@style='34']"))
		2498(0,8)
	if(number:=settings.ssn("//fonts/font[@code='2188']/@value").text)
		for a,b in s.ctrl
			b.2188(number)
}