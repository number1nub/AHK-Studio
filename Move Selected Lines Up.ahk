Move_Selected_Lines_Up(){
	sc:=csc()
	;GuiControl,1:-Redraw,% sc.sc
	csc().2620
	if(v.options.full_auto)
		newindent(1)
	GuiControl,1:+Redraw,% sc.sc
}