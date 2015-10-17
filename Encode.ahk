Encode(tt){
	length:=VarSetCapacity(text,strput(tt,"utf-8")),StrPut(tt,&text,length,"utf-8")
	return text
}