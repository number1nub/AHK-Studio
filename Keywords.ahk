Keywords(){
	commands:=new xml("commands","lib\commands.xml"),list:=settings.sn("//commands/*"),top:=commands.ssn("//Commands/Commands")
	cmd:=Custom_Commands.sn("//Commands/commands"),col:=Custom_Commands.sn("//Color/*"),con:=Custom_Commands.sn("//Context/*")
	while,new:=cmd.item[A_Index-1].clonenode(1)
		commands.ssn("//Commands/Commands").replaceChild(new,commands.ssn("//Commands/commands[text()='" new.text "']"))
	while,new:=col.item[A_Index-1].clonenode(1)
		commands.ssn("//Color").replaceChild(new,commands.ssn("//Color/" new.nodename))
	while,new:=con.item[A_Index-1].clonenode(1)
		commands.ssn("//Context").replaceChild(new,commands.ssn("//Context/" new.nodename))
	v.keywords:=[],v.kw:=[],v.custom:=[],colors:=commands.sn("//Color/*")
	while,color:=colors.item[A_Index-1]{
		text:=color.text,all.=text " "
		stringlower,text,text
		v.color[color.nodename]:=text
	}
	personal:=settings.ssn("//Variables").text,all.=personal
	StringLower,per,personal
	v.color.Personal:=Trim(per),v.indentregex:=RegExReplace(v.color.indent," ","|"),command:=commands.ssn("//Commands/Commands").text
	Sleep,4
	Loop,Parse,command,%A_Space%,%A_Space%
		v.kw[A_LoopField]:=A_LoopField,all.=" " A_LoopField
	Sort,All,UD%A_Space%
	list:=settings.ssn("//custom_case_settings").text
	for a,b in StrSplit(list," ")
		all:=RegExReplace(all,"i)\b" b "\b",b)
	Loop,Parse,all,%a_space%
		v.keywords[SubStr(A_LoopField,1,1)].=A_LoopField " "
	v.all:=all,v.context:=[],list:=commands.sn("//Context/*")
	while,ll:=list.item[A_Index-1]{
		cl:=RegExReplace(ll.text," ","|")
		Sort,cl,UD|
		v.context[ll.NodeName]:=cl
	}
	return
}