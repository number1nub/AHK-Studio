hk(win){
	hk:=menus.sn("//*[@hotkey!='']|//*[@clean!='omni_search']")
	list:=[]
	while,(ea:=xml.ea(hk.item[A_Index-1])).clean{
		if(!ea.Hotkey)
			Continue
		if(win!=1){
			if RegExMatch(ea.clean,"i)\b(Run|Run_As_Ansii|Run_As_U32|Run_As_U64|save|Debug_Current_Script)\b")
				Continue
		}
		List[ea.hotkey]:=ea.clean
	}
	hotkeys([win],list)
}