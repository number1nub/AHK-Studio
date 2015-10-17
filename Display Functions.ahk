Display_Functions(){
	code_explorer.scan(current()),all:=cexml.sn("//main[@file='" current(2).file "']/descendant::info[@type='Function']/@text")
	sc:=csc(),word:=sc.getword(),sc.2634(1)
	while,aa:=all.item[A_Index-1]
		if(aa.text~="i)^" word)
			list.=aa.text " "
	Sort,list,list,D%A_Space%
	sc.2117(5,Trim(list))
	if(!InStr(Trim(List)," "))
		sc.2104
}