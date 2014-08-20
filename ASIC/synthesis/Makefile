all:
	dc_shell-xg-t < synth_test.tcl
	@echo $(grep -r -n 'Error' ./*.rpt)
clean:
	rm -rf  *.rpt *.log *.svf analyzed
