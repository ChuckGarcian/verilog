/*
  Verilog implimentation of multiplier
*/


module multiplier_tb ();
// module mult_controler_tb ();
  logic m;
  logic adx;
  logic clk_in;
  logic rst_in;

  logic sh;
  logic add;
  logic done;

  initial begin
    clk_in <= 0;
    forever #5 clk_in = ~clk_in;
  end

  mult_controler m0 (
    .m (m),
    .adx (adx),
    .clk_in (clk_in),
    .rst_in (rst_in),
    .sh (sh),
    .add (add),
    .done (done)
  );

  initial begin
    @(negedge clk_in);
    rst_in = '0;
    @(negedge clk_in);
    rst_in = '1;
    adx = '1;
    while (!done) @(negedge clk_in);
    $display ("Yay it works!");
    $finish;
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