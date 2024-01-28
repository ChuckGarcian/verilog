/* 
  Issues:
    ∙ What edge of clock should actions occur?
*/


module controler #(parameter int D_SIZE) (
  input wire[D_SIZE-1:0] A,
  input wire[D_SIZE-1:0] P,
  input wire clk_in,
  input wire rst_in,
  input wire enable, // Two states: 0=idle, 1=running

  output wire c1_s, // Control signal for shifting
  output wire c2_a // Control signal for adding
);

  
  logic [3:0] count;
  always @()
endmodule

module multiplier #(parameter int D_SIZE) (
  input wire[D_SIZE-1: 0] A,
  input wire[D_SIZE-1: 0] B,
  
  input wire clk_in,
  input wire rst_in,
  input wire strt_in,
  
  output logic [D_SIZE-1:0] P

);
  reg [D_SIZE-1:0] internal_a; 
  reg [D_SIZE-1:0] internal_b; 
  reg [D_SIZE-1:0] internal_p;

  
  always_ff @(posedge clk_in) begin 
    if (strt_in = 1'b1) begin
      internal_a <= A;
      internal_b <= B;
      internal_p <= P;
      
      
      @(negedge clk_in)
        strt_in = 0; // To ensure internal registers are changed through multiplication
         
      // Hand off control to controller? 
    end else if (rst_in == 1'b1) begin
      internal_a <= 0;
      internal_b <= 0;
      internal_p <= 0;
    end

  end 
endmodule


module testbed #(parameter int D_SIZE = 10) ();
endmodule