help permute
webuse permute2
reg y group
bysort group:sum y

permute group _b[group],reps(500):reg y group
