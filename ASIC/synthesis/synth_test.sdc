# constraint files

#set_units -capacitance  pf
set_units -time         ps

echo "======Start Set Clock Period======"

set clk_period  770
set clk_hperiod  [expr ${clk_period}/2.0]

create_clock Clock -period ${clk_period}

set_clock_uncertainty -setup 100 Clock
set_clock_uncertainty -hold 100 Clock
set_clock_transition 40 Clock 
set_dont_touch_network Clock

# Set input and output delay
set_input_delay 0.2 -clock Clock -max [all_inputs]
set_input_delay 0 -clock Clock -min [all_inputs]
set_output_delay 0.2 -clock Clock [all_outputs]

# Set output load
set_load 0.1 [all_outputs]

echo "clk_period     = " ${clk_period}
echo "clk_hperiod    = " ${clk_hperiod}

echo "======End Set Clock Period======\n"

