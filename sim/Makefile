RTL = ../rtl/*.v
SVA = *sva/*sva.sv
TB = tb_top.sv
verbosity = UVM_MEDIUM 
compile_switches = -sverilog -assert enable_diag -ntb_opts uvm-1.1 -lca -debug_access+all -timescale=1ns/1ns -kdb +vcs+vcdpluson -l comp.log
runtime_switches = -assert verbose +UVM_VERBOSITY=${verbosity} +UVM_OBJECTION_TRACE -l sim.log 
all: compile run

compile: 
	vcs ${RTL} ${TB} ${SVA} ${compile_switches}

run: 
	./simv ${runtime_switches}

dve:
	dve -vpd vcdplus.vpd

verdi:
	verdi -sverilog -ntb_opts uvm-1.1 ${RTL} ${TB} -ssf tb_top.fsdb -no_logo &

clean:
	rm -rf *report* simv* csrc* *.tmp *.vpd *.key log *.h temp *.log .vcs* *.txt DVE* *.hvp urg* .inter.vpd.uvm .restart* .synopsys* novas.* *.dat *.fsdb verdi* work* vlog*


