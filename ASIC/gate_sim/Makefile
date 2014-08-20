all:
	vcs -f gate_sim.f > compile.rpt
	./simv +verbose=1 > sim.rpt
	tail sim.rpt

clean:
	rm -rf *.rpt *.key simv* csrc 
