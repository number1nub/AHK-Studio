Debug_Settings(){
	static values:=["max_depth","max_children"],newwin
	newwin:=new GUIKeep("Debug_Settings"),ea:=settings.ea("//features")
	for a,b in values
		newwin.add("Text,xm," b ":"),newwin.Add("Edit,x+M w100 v" b "," (ea[b]?ea[b]:0))
	newwin.Add("Button,xm gSave_Debug_Settings,Save Settings"),newwin.Show("Debug Settings")
	return
	Debug_SettingsGuiEscape:
	Save_Debug_Settings:
	Debug_SettingsGuiClose:
	top:=settings.add("features"),info:=newwin[]
	for a,b in values
		top.SetAttribute(b,info[b])
	newwin.Destroy()
	return
}