BEGIN {
	help_auto()
	set_arg(P, "?step", "3.5mm")
	set_arg(P, "?mark", "1")

	proc_args(P, "n,step,sideOffset,frontOffset,backOffset,mark", "n")

	P["n"] = int(P["n"])
	if ((P["n"] < 1))
		error("Number of pins have to be an even positive number")

	step=parse_dim(P["step"])

	element_begin("", "U1", P["n"] "*" P["step"] ,0, 0, 0, -step)

	for(n = 1; n <= P["n"]; n++) {
		element_pin(0, (n-1) * step, n)
	}
	
	half=step/2
	
	if (P["sideOffset"] > 0)
		sideOffset = parse_dim(P["sideOffset"])
	else
		sideOffset = half
	
	if (P["frontOffset"] > 0)
		frontOffset = parse_dim(P["frontOffset"])
	else
		frontOffset = half
	
	if (P["backOffset"] > 0)
		backOffset = parse_dim(P["backOffset"])
	else
		backOffset = half

	element_rectangle(-backOffset, -sideOffset, frontOffset, (P["n"]-1) * step + sideOffset)

	if (P["mark"] > 0) {
		element_line(-backOffset-mil(15), 0,        -backOffset-mil(65), -mil(25))
		element_line(-backOffset-mil(15), 0,        -backOffset-mil(65),  mil(25))
		element_line(-backOffset-mil(65), -mil(25), -backOffset-mil(65),  mil(25))
	}

	dimension(0, step, step, step, step*2, "spacing")

	element_end()
}
