SetMatch(){
	for a,b in {"{":"}","[":"]","<":">","(":")",Chr(34):Chr(34),"'":"'","%":"%"}
		if(!settings.find("//autoadd/key/@trigger",a))
			key:=[],key[a]:="match",hotkeys([1],key)
}