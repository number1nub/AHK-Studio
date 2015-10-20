Publish(return=""){
	sc:=csc(),text:=update("get").1,save(),mainfile:=ssn(current(1),"@file").text,publish:=update({get:mainfile}),includes:=sn(current(1),"descendant::*/@include/..")
	while,ii:=includes.item[A_Index-1]
		if(InStr(publish,ssn(ii,"@include").text))
			StringReplace,publish,publish,% ssn(ii,"@include").text,% update({get:ssn(ii,"@file").text}),All
	rem:=sn(current(1),"descendant::remove")
	while,rr:=rem.Item[A_Index-1]
		publish:=RegExReplace(publish,"m)^\Q" ssn(rr,"@inc").text "\E$")
	ea1:=xml.ea(vversion.ssn("//*[@file='" current(2).file "']")),ea:=xml.ea(vversion.ssn("//*[@file='" current(2).file "']/descendant::*[@number!='']")),newver:=(ea1.versstyle?"":"Version=") ea.number
	if(InStr(publish,Chr(59) "auto_version"))
		publish:=RegExReplace(publish,Chr(59) "auto_version",newver)
	publish:=RegExReplace(publish,"U)^\s*(;{.*\R|;}.*\R)","`n")
	StringReplace,publish,publish,`n,`r`n,All
	if(return)
		return publish
	Clipboard:=v.options.Full_Auto?PublishIndent(publish):publish
	TrayTip,AHK Studio,Code coppied to your clipboard
}
PublishIndent(Code,Indent:="`t",Newline:="`r`n"){
	indentregex:=v.indentregex,Lock:=[],Block:=[],ParentIndent:=Braces:=0,ParentIndentObj:=[]
	for each,Line in StrSplit(Code,"`n","`r"){
		Text:=Trim(RegExReplace(Line,"\s;.*")),First:=SubStr(Text,1,1),Last:=SubStr(Text,0,1),FirstTwo:=SubStr(Text,1,2),IsExpCont:=(Text~="i)^\s*(&&|OR|AND|\.|\,|\|\||:|\?)"),IndentCheck:=(Text~="iA)}?\s*\b(" IndentRegEx ")\b")
		if(First=="("&&Last!=")")
			Skip:=True
		if(Skip){
			if(First==")")
				Skip:=False
			Out.=Newline.RTrim(Line)
			continue
		}
		if(FirstTwo=="*/")
			Block:=[],ParentIndent:=0
		if(Block.MinIndex())
			Current:=Block,Cur:=1
		else
			Current:=Lock,Cur:=0
		Braces:=Round(Current[Current.MaxIndex()].Braces),ParentIndent:=Round(ParentIndentObj[Cur])
		if(First=="}"){
			while,((Found:=SubStr(Text,A_Index,1))~="}|\s"){
				if(Found~="\s")
					continue
				if(Cur&&Current.MaxIndex()<=1)
					break
				Special:=Current.Pop().Ind,Braces--
		}}
		if(First=="{"&&ParentIndent)
			ParentIndent--
		Out.=Newline
		Loop,% Special?Special-1:Round(Current[Current.MaxIndex()].Ind)+Round(ParentIndent)
			Out .= Indent
		Out.=Trim(Line)
		if(FirstTwo=="/*"){
			if(!Block.MinIndex())
				Block.Push({ParentIndent:ParentIndent,Ind:Round(Lock[Lock.MaxIndex()].Ind)+1,Braces:Round(Lock[Lock.MaxIndex()].Braces)+1})
			Current:=Block,ParentIndent:=0
		}
		if(Last=="{")
			Braces++,ParentIndent:=(IsExpCont&&Last=="{")?ParentIndent-1:ParentIndent,Current.Push({Braces:Braces,Ind:ParentIndent+Round(Current[Current.MaxIndex()].ParentIndent)+Braces,ParentIndent:ParentIndent+Round(Current[Current.MaxIndex()].ParentIndent)}),ParentIndent:=0
		if((ParentIndent||IsExpCont||IndentCheck)&&(IndentCheck&&Last!="{"))
			ParentIndent++
		if(ParentIndent>0&&!(IsExpCont||IndentCheck))
			ParentIndent:=0
		ParentIndentObj[Cur]:=ParentIndent,Special:=0
	}
	if(Braces)
		throw Exception("Segment Open!")
	return SubStr(Out,StrLen(Newline)+1)
}