Edit_Replacements(){
	static
	newwin:=new GUIKeep(7),sn:=settings.sn("//replacements/*"),newwin.Add("ListView,w500 h400 ger AltSubmit,Value|Replacement,wh","Text,,Value:,y","Edit,w500 vvalue,,wy","Text,xm,Replacement:,y","Edit,w500 r6 vreplacement gedrep,,wy","Button,xm geradd Default,Add,y","Button,x+10 gerremove,Remove Selected,y")
	while,val:=sn.item(A_Index-1)
		LV_Add("",ssn(val,"@replace").text,val.text)
	newwin.Show("Edit Replacements",1),LV_Modify(1,"Select Focus Vis AutoHDR")
	Loop,2
		LV_ModifyCol(A_Index,"AutoHDR")
	return
	edrep:
	info:=[]
	for a,b in {replacement:1,value:2}{
		ControlGetText,value,Edit%b%,% hwnd([7])
		info[a]:=value
	}
	if(item:=settings.ssn("//replacements/replacement[@replace='" info.replacement "']"))
		item.text:=info.value,LV_Modify(LV_GetNext(),"Col2",info.value)
	return
	eradd:
	rep:=newwin[]
	if(!(rep.replacement&&rep.value))
		return m("both values are required")
	if(!settings.ssn("//replacements/*[@replace='" rep.value "']"))
		settings.Add("replacements/replacement",{replace:rep.value},rep.replacement,1),LV_Add("",rep.value,rep.replacement)
	Loop,2
		ControlSetText,Edit%A_Index%
	ControlFocus,Edit1
	return
	er:
	LV_GetText(rep,LV_GetNext()),LV_GetText(rep1,LV_GetNext(),2)
	for a,b in {Edit1:rep,Edit2:rep1}
		ControlSetText,%a%,% RegExReplace(b,"(\r|\r\n|\n)","`r`n"),% hwnd([7])
	return
	erremove:
	Gui,7:Default
	while,LV_GetNext(),LV_GetText(value,LV_GetNext())
		rem:=settings.ssn("//replacements/*[@replace='" value "']"),LV_Delete(LV_GetNext()),rem.ParentNode.RemoveChild(rem)
	return
	7GuiClose:
	7GuiEscape:
	hwnd({rem:7})
	return
}