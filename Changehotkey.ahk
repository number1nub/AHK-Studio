ChangeHotkey(){
	static hk,hotkey,hwnd,ehk
	Gui,2:Default
	hotkey:=menus.ssn("//*[@tv='" TV_GetSelection() "']"),setup(98,1)
	Gui,98:Default
	Gui,98:+Owner2
	for a,b in [["Hotkey","vhk Limit1 hwndhwnd",ssn(Hotkey,"@hotkey").text],["Text","","Or enter hotkey below (eg ^+F)"],["Edit","w200 gclearhk vehk"],["Button","gchcancel","Cancel"],["Button","x+10 gchksub","Submit"]]
		Gui,Add,% b.1,% b.2,% b.3
	Gui,Show,,Hotkey
	return
	clearhk:
	Gui,98:Submit,NoHide
	GuiControl,,%hwnd%,%ehk%
	return
	chcancel:
	Gui,98:Destroy
	return
	chksub:
	98GuiEscape:
	KeyWait,Escape,U
	Gui,98:Submit,Nohide
	if(ehk&&hk=""){
		MsgBox,563,Are you sure?,Keep in mind that if you set an invalid key Studio could end up not working.  Be careful!
		IfMsgBox Yes
		{
			hotkey.SetAttribute("hotkey",ehk)
			WinActivate,% hwnd([2])
			Gui,2:Default
			TV_Modify(TV_GetSelection(),"",RegExReplace(ssn(hotkey,"@clean").text,"_"," ") " - " convert_hotkey(ehk))
			hwnd({rem:98})
			WinActivate,% hwnd([2])
			return
		}
	}else if(hk=""){
		hotkey.RemoveAttribute("hotkey")
		WinActivate,% hwnd([2])
		Gui,2:Default
		TV_Modify(TV_GetSelection(),"",RegExReplace(ssn(hotkey,"@clean").text,"_"," "))
		hwnd({rem:98})
		WinActivate,% hwnd([2])
		return
	}menu:=menus.sn("//*[@hotkey='" hk "']")
	if(menu.length){
		duplist:=""
		Gui,2:Default
		while,mm:=menu.Item[A_Index-1]
			duplist.=RegExReplace(ssn(mm,"@clean").text,"_"," ") "`n"
		MsgBox,52,Duplicate Hotkeys,% "The Function(s):`n`n" duplist "`nHave/Has the same hotkeys.`nReplace " RegExReplace(ssn(hotkey,"@clean").text,"_"," ") " as the new hotkey?"
		IfMsgBox,Yes
		{
			while,mm:=menu.Item[A_Index-1]
				mm.RemoveAttribute("hotkey"),ea:=xml.ea(mm),TV_Modify(ea.tv,"",RegExReplace(ea.clean,"_"," "))
			ea:=xml.ea(hotkey),TV_Modify(ea.tv,"",RegExReplace(ssn(hotkey,"@clean").text,"_"," ") " - " convert_hotkey(hk)),hotkey.SetAttribute("hotkey",hk)
		}
	}else{
		hotkey.SetAttribute("hotkey",hk)
		WinActivate,% hwnd([2])
		Gui,2:Default
		TV_Modify(TV_GetSelection(),"",RegExReplace(ssn(hotkey,"@clean").text,"_"," ") " - " convert_hotkey(hk))
		hwnd({rem:98})
		WinActivate,% hwnd([2])
		return
	}
	hwnd({rem:98})
	WinActivate,% hwnd([2])
	return
}