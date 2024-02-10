/*
  Verilog implimentation of multiplier
*/

/*  
mult_controler m0 (
    .m (m),
    .adx (adx),
    .clk_in (clk_in),
    .rst_in (rst_in),
    .sh (sh),
    .add (add),
    .done (done)
*/

module multiplier_tb ();
// module mult_controler_tb ();
  logic [10:0] gx;
  logic [10:0] gy;  
  logic [4:0] ex;
  logic [4:0] ey;
  logic clk_in;
  logic rst_in;
  
  // Outputs
  logic[21:0] product;

  int maxCount;
  
  piplined_integer_multiplier dut (
    .gx(gx),
    .gy(gy),
    .ex(ex),
    .ey(ey),
    .clk_in(clk_in),
    .rst_in(rst_in),
    .product_out(product)
  );


  event terminate_sim;
  
  initial begin
    @terminate_sim;
      $display ("\033[31mSIM COMPLETE\033[0m");
      
      #5 $finish;
  end;
  int clk_val;
  initial begin
    clk_val = 0;
    clk_in <= 0;
    forever begin 
      $display ("clock_value=%d \n", clk_val);
      #5 clk_in = ~clk_in;
      if (clk_in ) clk_val = clk_val + 1;
    end
  end

  initial begin
    maxCount = 0;
    
    gx = 11'b1010;
    gy = 11'b0010;
    ex = 5'b00001;
    ey = 5'b00010;
    $display ("\033[31mSIM START\033[0m");

    @(negedge clk_in);
    rst_in = '0;
    @(negedge clk_in);
    rst_in = '1;
    
    #5;    
    while (maxCount != 10) begin
      @(negedge clk_in);
      maxCount = maxCount + 1;
    end;
    
    $display ("Product==%b", product);
    
    ->terminate_sim;  
  
  end

endmodule

//   logic [3:0] x;
//   logic [3:0] y;
//   logic [3:0] product;
  
//   logic ready;
//   logic start;
//   logic rst_in;
//   logic clk;

//   initial begin
//     clk <= 0;
//     forever #5 clk = ~clk;
//     //every 5 ns switch...so period of clock is 10 ns...100 MHz clock
//   end


//   initial begin
    
//     rst_in = 1;
//     x = 0;
//     y = 0;
    
//     @(negedge clk);
//     rst_in = 0;
//     @(negedge clk);
//     rst_in = 1;
//     x = $random();
//     y = $random();
//     start = 1;
//     #10
//     @(negedge clk);
//     start = 0;
//     while (!ready) @(negedge clk);
//     $display ("product_b=%b", product);
//     $display ("product_d=%d", product);
  
  
//     // $display("mcand\t\tmplier\t\tprod");
//     // multicand = 4'b0010; multiplier = 4'b0010;
//     // #10
//     // $display("%b\t\t%b\t\t%b", multicand, multiplier, product);
//   end
// endmodule