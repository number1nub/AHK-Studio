ShowLabels(x:=0){
	code_explorer.scan(current()),all:=cexml.sn("//main[@file='" current(2).file "']/descendant::info[@type='Function' or @type='Label']/@text")
	sc:=csc(),sc.2634(1),dup:=[]
	if(x!="nocomma")
		sc.2003(sc.2008,","),sc.2025(sc.2008+1)
	while,aa:=all.item[A_Index-1]
		if(!dup[aa.text])
			list.=aa.text " ",dup[aa.Text]:=1
	Sort,list,list,D%A_Space%
	sc.2100(0,Trim(list))
}