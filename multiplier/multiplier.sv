





module andlg # (parameter int D_SIZE) (
  input wire [D_SIZE-1 : 0] a,
  input wire [D_SIZE-1 : 0] b,
  output logic [D_SIZE-1 : 0] res
);

  always_comb begin
    res <= a && b;
  end 
endmodule

module ripple_carry #(parameter int D_SIZE) (
  input wire [D_SIZE-1 : 0] a,
  input wire [D_SIZE-1 : 0] b,
  output logic [D_SIZE-1 : 0] sum
);
  always_ff @(posedge) begin
    sum <= a + b;
  end 
endmodule

module multiplier #(parameter int D_SIZE) (
  input wire[D_SIZE-1: 0] A,
  input wire[D_SIZE-1: 0] B,
  input wire clk_in;
  output logic [D_SIZE-1:0] P

);
  
  wire[D_SIZE-1:0] w1;
  
  // Registers to place operands and result in temprarly 
  logic [D_SIZE-1:0] tempP = 0;
  logic [D_SIZE-1:0] tempA = 0;  
  logic [D_SIZE-1:0] tempB = 0;
  
  // Count number of multiplications made


  // andlg #(.D_SIZE(D_SIZE)) a0 (
  //   .a(w1), 
  //   .b({D_SIZE{tempA[0]}}),
  //   .res(B)
  // );

  ripple_carry #(.D_SIZE(D_SIZE)) rc0 (
    .a(w1),
    .b(tempP),
    .sum(tempP)  
  );

  always_ff @(posedge clk_in) begin
    // If we are currently in the multyply state
    if (mult == 1) begin
      count = count + 1;
      if (count == D_SIZE - 1 )
        tempA
      else 
        if (temp) 
        tempA = tempA >> 1;
        
      mult = 0;
    end
  end

  always_ff @(A, B) begin
    @(negedge clk_in)
    tempA = A;
    tempB = B;
    tempP = 0;
    mult == 1;
    
  
    if (tempA[0] == 1) begin
      
    end 
      
      // 


    end
/*
    init P gets 0

    if (A[0] == 1)
    add (P, B, P)
    else if (A[0] == 0)
    add (P B, 0...0)

    right_shift(A by one)
    
    repeat P times 
  */
  end

endmodule