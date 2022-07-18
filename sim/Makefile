RTL = ../rtl/*.v
TB = tb_top.sv
compile_switches = -ntb_opts uvm-1.1 -debug_all

compile: ${RTL} ${TB}
	vcs -sverilog ${RTL} ${TB} ${compile_switches}
