BEGIN {
	help_auto()
	set_arg(P, "?spacing", 300)
	set_arg(P, "?step", 100)
	set_arg(P, "?margins", -1)

	proc_args(P, "n,spacing,step", "n")

	P["n"] = int(P["n"])
	if ((P["n"] < 2) || ((P["n"] % 2) != 0))
		error("Number of pins have to be an even positive number")

	spacing=parse_dim(P["spacing"])
	step=parse_dim(P["step"])

	element_begin("", "U1", P["n"] "*" P["spacing"] ,0, 0, 0, -step)

	for(n = 1; n <= P["n"]/2; n++) {
		element_pin(0, (n-1) * step, n)
		element_pin(spacing, (n-1) * step, P["n"] - n + 1)
	}
	
	if (P["margins"] >= 0)
		margins = parse_dim(P["margins"])
	else
		margins = step/2

	dip_outline(-margins, -margins, spacing + margins , (n-2) * step + margins,  margins)


	dimension(0, 0, spacing, 0, step, "spacing")

	element_end()
}
