InputBox(parent,title,prompt,default=""){
	WinGetPos,x,y,,,ahk_id%parent%
	sc:=csc(),RegExReplace(prompt,"\n","",count),count:=count+2,sc:=csc(),height:=(sc.2279(0)*count)+(v.caption*3)+23+34,y:=((cpos:=sc.2165(0,sc.2008))<height)?y+cpos+sc.2279(sc.2166(sc.2008))+5:y
	InputBox,var,%title%,%prompt%,,,%height%,%x%,%y%,,,%default%
	if ErrorLevel
		Exit
	return var
}