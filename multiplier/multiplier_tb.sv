/*
  Verilog implimentation of multiplier
*/

module multiplier_compare #(parameter int D_SIZE) (
  input wire [D_SIZE-1 : 0] a,
  input wire [D_SIZE-1 : 0] b,
  output logic [D_SIZE * 2:0] p
);

  always_comb begin
    p = a * b;
  end

endmodule 

module multiplier_tb #(parameter int D_SIZE = 8) ();
  logic [D_SIZE-1 : 0] multicand;
  logic [D_SIZE-1 : 0] multiplier;
  logic [D_SIZE * 2:0] product;
  
  multiplier_compare #(.D_SIZE(D_SIZE)) u0  (
    .a(multicand),
    .b(multiplier),
    .p(product)
  );

  initial begin
    $display("mcand\t\tmplier\t\tprod");
    multicand = 4'b0010; multiplier = 4'b0010;
    #10
    $display("%b\t\t%b\t\t%b", multicand, multiplier, product);
  end
endmodule