Move_Selected_Lines_Down(){
	GuiControl,1:-Redraw,% csc().sc
	csc().2621
	if(v.options.full_auto)
		newindent(1)
	GuiControl,1:+Redraw,% csc().sc
}