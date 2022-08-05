RTL = ../rtl/*.v
TB = tb_top.sv
compile_switches = -sverilog -ntb_opts uvm-1.1 -lca -debug_access+all -timescale=1ns/1ns -kdb +vcs+vcdpluson -l comp.log
verbosity = UVM_MEDIUM 
runtime_switches = +UVM_VERBOSITY=${verbosity} +UVM_OBJECTION_TRACE -l sim.log 
all: compile run

compile: ${RTL} ${TB}
	vcs ${RTL} ${TB} ${compile_switches}

run: 
	./simv ${runtime_switches}

dve:
	dve -vpd vcdplus.vpd

verdi:
	verdi -sverilog -ntb_opts uvm-1.1 ${RTL} ${TB} -ssf tb_top.fsdb -no_logo &

clean:
	rm -rf simv* csrc* *.tmp *.vpd *.key log *.h temp *.log .vcs* *.txt DVE* *.hvp urg* .inter.vpd.uvm .restart* .synopsys* novas.* *.dat *.fsdb verdi* work* vlog*


