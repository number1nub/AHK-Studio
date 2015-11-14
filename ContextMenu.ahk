ContextMenu(){
	GuiContextMenu:
	ControlGetFocus,Focus,% hwnd([1])
	MouseGetPos,,,,ctl ;#[ADDED: Context menu shown when quick find is right clicked allowing moving between top & bottom]
	MouseGetPos,,,,control,2
	if(control=v.debug.sc){
		Menu,rcm,Add,Close,SciDebug
		Menu,rcm,Show
		Menu,rcm,Delete
		return
		SciDebug:
		if(A_ThisMenuItem="Close")
			stop()
		return
	}
	if(InStr(ctl,"Scintilla")){
		for a,b in ["Bookmark Search","Class Search","Close","Copy","Cut","Delete","Function Search","Hotkey Search","Instance Search","Menu Search","Method Search","Open Folder","Paste","Property Search","Redo","Search Label","Select All","Undo"]
			Menu,rcm,Add,%b%,SciRCM
		Menu,rcm,Show
		Menu,rcm,DeleteAll
		return
		SciRCM:
		item:=clean(A_ThisMenuItem)
		if(IsFunc(item))
			%item%()
		return
	}
	if(ctl="Static1"||ctl="Edit1"){
		Menu,qfm,Add,% "Move to " (v.options.top_find?"Bottom":"Top"),Top_Find
		Menu,qfm,Show
		Menu,qfm,Delete
	}
	if(Focus="SysTreeView322"){
		GuiControl,+g,SysTreeView322
		code_explorer.Refresh_Code_Explorer()
		GuiControl,+gcej,SysTreeView322
	}
	if(Focus="SysTreeView321"){
		static info
		TV_GetText(text,A_EventInfo),info:=A_EventInfo
		main:=files.ssn("//*[@tv='" A_EventInfo "']/ancestor::main")
		type:=files.ssn("//*[@tv='" A_EventInfo "']")
		Menu,rcm,Add,%text%,deadend
		Menu,rcm,Disable,%text%
		Menu,rcm,Add
		if(type.nodename="folder"){
			for a,b in {Disable_Folders_In_Project_Explorer:"Disable Folders In Project Explorer",Folder_Icon:"Folder Icon"}
				Menu,rcm,Add,%b%,%a%
		}else
			for a,b in StrSplit("New Project,Close Project,Open,Rename,Remove Segment,,Copy File Path,Copy Folder Path,Open Folder,Width,Hide/Show Icons,File Icon",",")
				Menu,rcm,Add,%b%,rcm
		Menu,rcm,show
		Menu,rcm,DeleteAll
		Menu,rcm,Delete
		return
		Folder_Icon:
		TVIcons(2)
		return
		rcm:
		MouseGetPos,,,win
		if(win=v.debug.sc)
			return m("here")
		if(A_ThisMenuItem="close project")
			return Close(main)
		if(A_ThisMenuItem="Open")
			Open()
		else if(A_ThisMenuItem="Hide/Show Icons")
			top:=settings.add("icons/pe"),top.SetAttribute("show",_:=xml.ea(top).show?0:1),TVIcons()
		else if(A_ThisMenuItem~="Copy (File|Folder) Path"){
			pFile:=current(3).file
			SplitPath,pFile,,pFolder
			Clipboard:=InStr(A_ThisMenuItem,"Folder")?pFolder:pFile
		}else if(A_ThisMenuItem="Remove Segment")
			Remove_Segment()
		else if(A_ThisMenuItem="width")
			widths()
		else if(A_ThisMenuItem="Rename")
			Rename_Current_Segment(files.ssn("//*[@tv='" info "']")),info:=""
		else if(A_ThisMenuItem="File Icon")
			TVIcons(1)
		else if(A_ThisMenuItem="New Project")
			new()
		else if(A_ThisMenuItem="Open Folder")
			open_folder()
		else
			m("Coming Soon....maybe")
		return
	}
	return
}