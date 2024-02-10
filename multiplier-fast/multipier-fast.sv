// Description: Logarithmic Implementation of integer multiplier
module adder (
  input wire [21:0] operandA,
  input wire [21:0] operandB,
  output wire [21:0] result
);
  assign result = operandA + operandB;
endmodule;

module mux2to1 (
  input wire [21:0] in0,
  input wire [21:0] in1,
  input wire sel,
  output wire out
  );
    assign out = sel == 1'b0 ? in1 : in0;
endmodule


module sm_stg_1 (
  input wire [10:0] gy,
  input wire [10:0] gx,
  input wire [4:0] ex,
  input wire [4:0] ey,
  input wire rst_in,
  input logic clk_in,
  
  output logic [21:0] stg2_out [0:5],
  output logic [4:0] eregs [0:1]
  
);
  
  logic [21:0] gx_bits [0:10]; // shifted x bits
  wire gy_bits [0:10];           // y control bits
  wire [21:0] ismr [0:4];     // intermediate sums result
  
  // Generate Row of adders
  genvar i;
  generate  
    
    for (i = 0; i < 5; i = i + 1) begin : gen_adders
      mux2to1 mx0 (
        .in0 (22'b0),
        .in1 (gx_bits[10 - (2 * i)]),
        .sel (gy_bits[10 - (2 * i)]),
        .out()
      );

      adder a0 (
        .operandA(gx_bits[10 - 2*i]),
        .operandB(gx_bits[9  - 2*i]),
        .result (ismr[i])
      );
    end

  endgenerate

  // Instead of directly left shifting the 'gx' input, we just connect
  // it to the higher order bits- this acheives the same effect 
  `define ASSIGN_GX_BITS(j) gx_bits[j] <= {{(11-j){1'b0}}, gx, {j{1'b0}}};
  
  always_ff @(posedge clk_in or negedge rst_in) begin
    if (!rst_in) begin
      // Set output registers to zero
      stg2_out[0] <= '0;
      stg2_out[1] <= '0;
      stg2_out[2] <= '0;
      stg2_out[3] <= '0;
      stg2_out[4] <= '0;
      eregs[0] <= '0;
      eregs[1] <= '0;
    end else begin
      
      stg2_out[0] <= {11'b0, gx};
      `ASSIGN_GX_BITS(1)
      `ASSIGN_GX_BITS(2)
      `ASSIGN_GX_BITS(3)
      `ASSIGN_GX_BITS(4)
      `ASSIGN_GX_BITS(5)
      `ASSIGN_GX_BITS(6)
      `ASSIGN_GX_BITS(7)
      `ASSIGN_GX_BITS(8)
      `ASSIGN_GX_BITS(9)
      `ASSIGN_GX_BITS(10)
      eregs[0] <= ex;
      eregs[1] <= ey;
    end
  
  end

endmodule

module sm_stg_2(
  input logic [10:0] gy,
  input logic [10:0] gx,
  input logic [4:0] ex,
  input logic [4:0] ey,
  input rst_in,
  input logic clk_in,
  
  output logic [21:0] stg2_out [0:5],
  output logic [4:0] eregs [0:1]
);

endmodule;

module piplined_integer_multiplier (
  input wire [10:0] gy,
  input wire [10:0] gx,
  input wire [4:0] ex,
  input wire [4:0] ey,
  input wire rst_in,
  input wire clk_in,
  output [21:0] product_out
);   
  
  // Register File
  logic [21:0] stg2 [0:5];
  logic [4:0] eregs [0:1];

  // logic [21:0] stg3 [0:3];
  // logic [21:0] stg4 [0:1];
  
  sm_stg_1 sm1 (
    .gy(gy),
    .gx(gx),
    .ex(ex),
    .ey(ey),
    .rst_in(rst_in),
    .clk_in(clk_in),
    .stg2_out(stg2),
    .eregs (eregs)
  );
  
  always @(negedge clk_in) begin: sample_inputs
    $display ("firstage outputs = %b", stg2[0]);
  end


endmodule