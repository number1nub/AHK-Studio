Replace_Selected(){
	sc:=csc(),OnMessage(6,""),replace:=InputBox(sc.sc,"Replace Selected","Input text to replace what is selected"),clip:=Clipboard
	if ErrorLevel
		return
	for a,b in StrSplit("``r,``n,``r``n,\r,\n,\r\n",",")
		replace:=RegExReplace(replace,"i)\Q" b "\E","`n")
	Clipboard:=replace,sc.2614(1),sc.2179,Clipboard:=clip,OnMessage(6,"Activate")
}