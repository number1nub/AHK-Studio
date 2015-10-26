Remove_Segment(){
	current:=current(),mainnode:=current(1),curfile:=current(3).file
	if(current(3).file=current(2).file)
		return m("Can not remove the main Project")
	all:=files.sn("//main[@file='" current(2).file "']/descendant::file"),contents:=update("get").1,inc:=current(3).include
	while,aa:=all.item[A_Index-1],ea:=xml.ea(aa){
		text:=contents[ea.file]
		if(f:=InStr(text,inc)){
			if(m("Permanently delete this file?","btn:yn","def:2")="Yes")
				FileDelete,% current(3).file
			update({file:ea.file,text:RegExReplace(text,"\R?\Q" inc "\E\R?","`n")}),Refresh_Current_Project(ea.file)
			Break
		}
	}
}