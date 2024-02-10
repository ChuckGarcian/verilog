build-ex:
		iverilog -g2012 multiplier_tb.sv multiplier_expected.sv -o mult-exp.out

run-ex: build-ex
		vvp mult-exp.out

build:
		iverilog -g2012 multiplier_tb.sv multipier-fast.sv -o mult.out

run: build
		vvp mult.out

compare:
		bash -c 'diff --color=always -u <(make run-ex | tail -n +4 | head -n -2) <(make run | tail -n +4 | head -n -2)'

clean:
		rm mult.out mult-exp.out