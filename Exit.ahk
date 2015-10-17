Exit(x:="",reload:=0){
	Exit:
	rem:=settings.ssn("//last"),rem.ParentNode.RemoveChild(rem),notesxml.save(1),savegui(),vault.save(1)
	for a,b in s.main{
		file:=files.ssn("//*[@sc='" b.2357 "']/@file").text
		if file
			settings.add("last/file",,file,,1)
	}
	toolbar.save(),positions.save(1),rebar.save(),menus.save(1),getpos(),settings.add({path:"gui",att:{zoom:csc().2374}}),settings.save(1),bookmarks.save(1)
	for a in pluginclass.close
		If WinExist("ahk_id" a)
			WinClose,ahk_id%a%
	if(debug.socket){
		debug.send("stop")
		sleep,500
		debug.disconnect()
	}
	if(save(v.options.disable_autosave?1:0)="cancel")
		return
	if(Reload)
		return
	if(x=""||InStr(A_ThisLabel,"Gui"))
		ExitApp
	return
}