AddBookmark(line,search){
	sc:=csc(),end:=sc.2136(line),start:=sc.2128(line),name:=(settings.ssn("//bookmark").text),name:=name?name:SubStr(StrSplit(current(2).file,"\").pop(),1,-4)
	for a,b in {"$file":SubStr(StrSplit(current(3).file,"\").pop(),1,-4),"$project":SubStr(StrSplit(current(2).file,"\").pop(),1,-4)}
		name:=RegExReplace(name,"i)\Q" a "\E",b)
	if(RegExMatch(name,"UO)\[(.*)\]",time)){
		FormatTime,currenttime,%A_Now%,% time.1
		name:=RegExReplace(name,"\Q[" time.1 "]\E",currenttime)
	}sc.2003(end," " Chr(59) search.1 "[" name "]"),sc.2160(end+4,end+4+StrPut(name,utf-8)-1)
}