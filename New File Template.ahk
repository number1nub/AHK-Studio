New_File_Template(){
	newwin:=new GUIKeep(28),newwin.add("Edit,w500 r30,,wh","Button,gnftdefault,Default Template,y"),newwin.show("New File Template")
	if(template:=settings.ssn("//template").text)
		ControlSetText,Edit1,%template%,% hwnd([28])
	else
		goto,nftdefault
	return
	28GuiEscape:
	28GuiClose:
	ControlGetText,edit,Edit1,% hwnd([28])
	settings.Add("template",,edit),hwnd({rem:28})
	return
	nftdefault:
	FileRead,template,c:\windows\shellnew\template.ahk
	ControlSetText,Edit1,%template%,% hwnd([28])
	return
}