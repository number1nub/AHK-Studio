Escape(){
	sc:=csc()
	ControlGetFocus,Focus,% hwnd([1])
	if(!InStr(Focus,"scintilla")){
		selections:=[],main:=sc.2575,sel:=sc.2570()
		Loop,% sc.2570()
			selections.push([sc.2577(A_Index-1),sc.2579(A_Index-1)])
		sc.2400(),sc.2571()
		Sleep,0
		for a,b in selections{
			if(A_Index=1)
				sc.2160(b.2,b.1)
			else
				sc.2573(b.1,b.2)
		}
		sc.2574(main),CenterSel()
	}
}