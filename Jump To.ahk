Jump_To(find:=""){
	sc:=csc(),cpos:=sc.2008,word:=sc.getword(),Index_Current_File(),word:=upper(word)
	search:=find?"[@type='" find "'][@upper='" word "']":"[@upper='" word "']"
	if(found:=cexml.ssn("//main[@file='" current(2).file "']/descendant::info" search)){
		ea:=xml.ea(found),TV(files.ssn("//main[@file='" ssn(found,"ancestor::main/@file").text "']/descendant::file[@file='" ssn(found,"ancestor::file/@file").text "']/@tv").text)
		Sleep,200
		csc().2160(ea.pos,ea.pos+StrPut(ea.text,"Utf-8")-1+_:=ea.type="class"?+6:+0),v.sc.2169,v.sc.2400
	}else if(InStr(text:=sc.textrange(sc.2128(line:=sc.2166(sc.2008)),sc.2136(line)),Chr(35) "include"))
		main:=files.ssn("//main[@file='" current(2).file "']"),tv(ssn(main,"descendant::file[@include='" text "']/@tv").text)
	else if(SubStr(word,1,1)~="i)(g|v)"){
		word:=SubStr(word,2),search:=find?"[@type='" find "'][@upper='" word "']":"[@upper='" word "']"
		if(found:=cexml.ssn("//main[@file='" current(2).file "']/descendant::info" search)){
			ea:=xml.ea(found),TV(files.ssn("//main[@file='" ssn(found,"ancestor::main/@file").text "']/descendant::file[@file='" ssn(found,"ancestor::file/@file").text "']/@tv").text)
			Sleep,200
			csc().2160(ea.pos,ea.pos+StrPut(ea.text,"Utf-8")-1+_:=ea.type="class"?+6:+0),v.sc.2169,v.sc.2400
		}
	}
}Jump_To_Class(){
	Jump_To("Class")
}Jump_To_First_Available(){
	sc:=csc(),line:=sc.getline(sc.2166(sc.2008))
	if(RegExMatch(line,"Oi)^\s*#include\s*(.*)",found))
		Jump_To("include")
	else
		Jump_To()
}Jump_To_Function(){
	Jump_To("Function")
}Jump_To_Include(){
	Jump_To("Include")
}Jump_To_Label(){
	Jump_To("Label")
}Jump_To_Method(){
	Jump_To("Method")
}