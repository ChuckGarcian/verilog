build:
		iverilog -g2012 multiplier_tb.sv multiplier.sv -o mult.out
run: build
	  vvp mult.out
clean:
		rm mult.out