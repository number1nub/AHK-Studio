Context(return=""){
	static lasttip
	sc:=csc(),open:=cp:=sc.2008,line:=sc.2166(cp),start:=sc.2128(line),end:=sc.2136(line),synmatch:=[],startpos:=0
	if(sc.2102)
		return
	if(cp<=start)
		return
	string:=sc.textrange(start,cp),pos:=1,fixcp:=cp,sub:=cp-start
	/*
		while,(fixcp>start){
			if(sc.2010(fixcp)="3")
				string:=RegExReplace(string,".","_",,1,sub-A_Index+2)
			fixcp--
		}co:=InStr(string,"(",,0),cc:=InStr(string,")",,0) ;,open:=cc>co?cc+start:co+start
	*/
	open:=sc.2008,commas:=0
	Loop{
		sc.2190(open),sc.2192(start),close:=sc.2197(1,")"),sc.2190(open),sc.2192(start),comma:=sc.2197(1,","),sc.2190(open),sc.2192(start),open:=sc.2197(1,"(")
		if(comma>close&&comma>open){
			if(sc.2010(comma)~="\b97|4\b")
				commas++
			open:=comma
			Continue
		}
		if(close>open&&open>start){
			bm:=sc.2353(close),wb:=sc.2266(bm,1),string:=SubStr(string,1,wb-start) SubStr(string,close+2-start),open:=sc.2266(bm,1)
			Continue
		}
		if(open<0)
			break
		word:=sc.textrange(wb:=sc.2266(open,1),sc.2267(open,1)),wordstartpos:=wb
		if(word){
			if(sc.2007(wb-1)=46)
				pre:=sc.textrange(wordstartpos:=sc.2266(wb-1,1),sc.2267(wb-1,1))
			if(inst:=cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Instance' and @upper='" upper(pre) "']")){
				if(args:=cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Class' and @upper='" upper(xml.ea(inst).class) "']/descendant-or-self::*[@upper='" upper(word) "']/@args").text)
					synmatch.push(pre "." word "(" args ")"),startpos:=startpos=0?wordstartpos:startpos,commas++
			}if(fun:=cexml.ssn("//lib/descendant::info[@upper='" upper(word) "']")){
				synmatch.push(word "(" xml.ea(fun).args ")"),startpos:=startpos=0?wordstartpos:startpos,commas++
			}if(fun:=ssn(cexml.ssn("//main[@file='" current(2).file "']/descendant::*[@type='Function'][@upper='" upper(word) "']"),"@args").text){
				synmatch.push(word "("  fun  ")"),startpos:=startpos=0?wordstartpos:startpos,commas++
			}if((ea:=scintilla.ea("//scintilla/commands/item[@code='" word "']")).syntax)
				synmatch.push(pre "." word ea.syntax "`n" ea.name),startpos:=startpos=0?wordstartpos:startpos,commas++
			if(syn:=commands.ssn("//Commands/Commands/commands[text()='" v.kw[word] "']/@syntax").text)
				synmatch.push(word syn),startpos:=startpos=0?wordstartpos:startpos,commas+=SubStr(syn,1,1)="("?1:0
			if(startpos)
				break
		}
	}if(word=""||word="if"){
		RegExMatch(string,"O)^\s*\W*(\w+)",word),word:=v.kw[word.1]?v.kw[word.1]:word.1,startpos:=start,loopword:=word,loopstring:=string,build:=word
		if((list:=v.context[word])&&word!="if"){
			for a,b in StrSplit(string,","){
				if(RegExMatch(b,"Oi)\b(" list ")\b",found))
					RegExMatch(list,"Oi)\b(" found.1 ")\b",found),last:=found.1,build.=a_index=1?",":b ","
				else
					Break
			}if(syntax:=commands.ssn("//Context/" word "/descendant-or-self::syntax[contains(text(),'" last "')]/@syntax").text)
				synmatch.push(Trim(build,",") " " syntax)
		}else if(word="if"){
			for a,b in StrSplit(string," ")
				if(RegExMatch(b,"Oi)\b(" list ")\b",found)&&InStr(b,"if")=0){
					last:=found.1,build.=a_index=1?",":b ","
					break
				}
			synmatch.push("if " commands.ssn("//Context/if/descendant-or-self::syntax[text()='" (last?last:"if") "']/@syntax").text)
		}else
			if(syntax:=commands.ssn("//Commands/commands[text()='#" word "' or text()='" word "']/@syntax").text)
				synmatch.push(word " " syntax)
	}if(wordstartpos-start>0)
		string:=LTrim(SubStr(string,wordstartpos-start),",")
	if(return)
		return word
	syntax:=""
	for a,b in synmatch{
		if(syntax~="\b\Q" b "\E"=0)
			syntax.=b "`n"
	}syntax:=Trim(syntax,"`n")
	if(return)
		return word
	if(!syntax)
		return
	synbak:=RegExReplace(syntax,"(\n.*)")
	RegExReplace(synbak:=RegExReplace(synbak,  "\(",",",,1),",","",count)
	syntax:=RegExReplace(syntax ,Chr(96) "n","`n")
	if(count=0||word="if")
		sc.2207(0xAAAAAA),sc.2200(startpos,syntax)
	else{
		ff:=RegExReplace(synbak,"\(",","),sc.2207(0xff0000),sc.2200(startpos,syntax)
		if(commas+1<=count)
			sc.2204(InStr(ff,",",0,1,commas),InStr(ff,",",0,1,commas+1)-1)
		if(commas>count){
			if(InStr(SubStr(synbak,InStr(ff,",",0,1,count)+1),"*"))
				commas:=1
			else
				sc.2204(0,StrLen(ff)),sc.2207(0x0000ff)
		}if(commas=count)
			end:=RegExMatch(syntax,"(\n|\]|\))"),end:=end?end-1:strlen(ff),sc.2204(InStr(ff,",",0,1,commas),end)
	}
	return
}