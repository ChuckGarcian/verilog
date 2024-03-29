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
  logic [3:0] x;
  logic [3:0] y;  
  logic start;
  logic clk_in;
  logic rst_in;
  
  // Outputs
  logic[7:0] product;
  logic done;
  int maxCount;

  multiplier  m0 (
    .x (x),
    .y (y),
    .start (start),
    .clk_in (clk_in),
    .rst_in (rst_in),
    .product (product),
    .ready (done)
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
    start = '0;
    x = 4'b1010;
    y = 4'b0010;
    $display ("\033[31mSIM START\033[0m");

    $monitor ("done=%b \n", done);
    @(negedge clk_in);
    rst_in = '0;
    @(negedge clk_in);
    rst_in = '1;
    @(negedge clk_in);
    start = '1;
    #5;
    
    start = '0;
    while (!done && maxCount != 10) begin
      @(negedge clk_in);
      maxCount = maxCount + 1;
    end;
    $display ("Product==%b", product);
    $display ("Product==%d", product);
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