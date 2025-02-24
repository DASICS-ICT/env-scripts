# synth_design -directive AlternateRoutability ?
open_project ./xs_nanhu_fpga/xs_nanhu/xs_nanhu.xpr
synth_design
opt_design -directive ExploreArea 
opt_design -directive AddRemap 
opt_design -control_set_merge -merge_equivalent_drivers
place_design -directive SSI_SpreadLogic_high
phys_opt_design -directive AggressiveExplore
phys_opt_design -directive ExploreWithAggressiveHoldFix
route_design -directive AggressiveExplore
report_timing_summary
report_utilization
write_bitstream ./xs_fpga_top_debug.bit
write_debug_probes ./xs_fpga_top_debug.ltx

