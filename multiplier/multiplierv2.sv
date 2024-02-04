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
  output [2*D_SIZE - 1: 0] product;
);

  
  logic [3:0] count;
  
  always @(posedge clk_in) begin
    if (enable == 1'b1) begin
      
      if (count == D_SIZE) begin: Finished
        product = {P, A}
        cl1_s <= 1'b0;
        c2_a <= 1'b0
      end else begin
        if ()
        count = count + 1;
        
      end
      count = count + 1;  
    end else if (enable == 1'b0) begin
      count <= 0;
    end
  end
endmodule

module adder (
  input logic cshift,
  input wire [D_SIZE-1 : 0] a,
  input wire clk_in;
  output wire [2*D_SIZE - 1: 0] p;
);
  always_ff @(posedge clk_in) begin
    if (cshift == 1'b1) begin
      p <= a >> 1;
    end
  end
endmodule

module adder (
  input logic cadd,
  input wire [D_SIZE-1 : 0] a,
  input wire [D_SIZE-1 : 0] b,
  input wire clk_in;
  output wire [2*D_SIZE - 1: 0] p;
);
  always_ff @(posedge clk_in) begin
    if (cadd == 1'b1) begin
      p <= a + b;
    end
  end
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
  
  logic cadd;
  logic cshift;

  logic running_state; 
  logic controler_strt;
  
  


  always_ff @(negedge clk_in) begin
    if (running_state == 1'b1) begin      
        if (internal_a[0] == 1) begin
          cadd = 1'b1;
          cshift = 1'b1;
        end else if (internal_a[0] == 1'b0) begin
          cadd = 1'b0;
          cshift = 1'b1;
        end
    end
  end

  always_ff @(posedge clk_in) begin 
    if (strt_in == 1'b1) begin
      internal_a <= A;
      internal_b <= B;
      internal_p <= 0;
      
      
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