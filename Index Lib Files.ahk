Index_Lib_Files(){
	SplitPath,A_AhkPath,,ahkdir
	ahkdir.="\lib\",temp:=new xml("lib"),allfiles:=[],rem:=cexml.ssn("//lib"),rem.ParentNode.RemoveChild(rem)
	for a,b in [A_MyDocuments "\AutoHotkey\Lib\",ahkdir]{
		pos:=1,rem:=no.ssn("//bad"),rem.ParentNode.RemoveChild(rem),notop:=no.add("bad")
		Loop,%b%*.ahk{
			next:=temp.add("main",{file:A_LoopFileFullPath},,1),file:=FileOpen(A_LoopFileFullPath,0,"UTF-8"),text:=file.Read(file.length),file.close(),pos:=1,text:="`n" RegExReplace(text,"\R","`n"),fff:=allfiles[A_LoopFileFullPath]:=[],fff.text:=text
			while,RegExMatch(text,"OUm`r)\n\s*(\x2F\x2A.*\x2A\x2F)",found,pos),pos:=found.pos(1)+found.len(1)
				no.under(notop,"bad",{min:found.pos(1)-1,max:found.pos(1)+found.len(1)-1,type:"comment"})
			pos:=1
			while,RegExMatch(text,Code_Explorer.class,found,pos),pos:=found.Pos(1)+found.len(1)
				if(!no.ssn("//bad[@min<" found.pos(1) " and @max>" found.pos(1) "]"))
					temp.under(next,"info",{type:"Class",opos:found.Pos(1),pos:ppp:=StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-3,text:RegExReplace(found.1,"i)^(class|\s)"),upper:upper(RegExReplace(found.1,"i)(class|\s)"))})
	}}clist:=temp.sn("//*[@type='Class']")
	while,cc:=clist.item[A_Index-1],ea:=xml.ea(cc){
		text:=allfiles[ssn(cc.ParentNode,"@file").text].text,text:=RegExReplace(text,"\R","`n"),tt:=SubStr(text,ea.opos-1),total:="",braces:=0,start:=0
		for a,b in StrSplit(tt,"`n"){
			line:=Trim(RegExReplace(b,"(\s+" Chr(59) ".*)")),total.=b "`n"
			if(SubStr(line,0,1)="{")
				braces++,start:=1
			if(SubStr(line,1,1)="}"){
				while,((found1:=SubStr(line,A_Index,1))~="(}|\s)"){
					if(found1~="\s")
						Continue
					braces--
			}}if(start&&braces=0)
			break
		}
		total:=Trim(total,"`n"),cc.SetAttribute("end",np:=ea.pos+StrPut(total,"utf-8")-1)
		for a,b in {Property:Code_Explorer.property,Method:Code_Explorer.function}{
			pos:=1
			while,RegExMatch(total,b,found,pos),pos:=found.Pos(1)+found.len(1)
				if(no.ssn("//bad[@min<'" ea.pos+found.pos(1) "' and @max>'" ea.pos+found.pos(1) "']")=""&&found.1!="if")
					add:=a="property"?"[":"(",temp.under(cc,"info",{type:a,pos:ea.pos+StrPut(SubStr(text,1,found.Pos(1)),"utf-8")-2,text:found.1,upper:upper(found.1),args:found.value(3),class:ea.text})
	}}main:=temp.sn("//main")
	while,mm:=main.item[A_Index-1],ea:=xml.ea(mm),text:=allfiles[ea.file].text,pos:=1
		while,RegExMatch(text,Code_Explorer.function,found,pos),pos:=found.Pos(1)+found.len(1)
			if(!ssn(mm,"*[@opos<'" found.pos(1) "' and @end>'" found.pos(1) "']")&&found.1!="if")
				temp.under(mm,"info",{args:found.3,type:"Function",text:found.1,upper:upper(found.1),pos:strput(substr(text,1,found.pos(1)))-3})
	all:=temp.sn("//info[@type='Function' or @type='Class']/@text"),sort:=[]
	while,aa:=all.item[A_Index-1]
		sort[aa.text]:=1
	for a in sort
		v.keywords[SubStr(a,1,1)].=a " "
	cexml.ssn("//*").AppendChild(temp.ssn("//lib"))
}