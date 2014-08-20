all:
	vcs -debug_all -f rtl_sim.f > compile.rpt
	./simv +verbose=1 > sim.rpt
	tail sim.rpt

clean:
	rm -rf *.rpt *.key simv* csrc 
