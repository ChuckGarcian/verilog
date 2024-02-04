/*
  Functionality: 4 bit multiplier.
  Description: 4 bit multiplier that uses a finite state machine internally.
*/


module mult_controler (
  input logic m,
  input logic adx,
  input logic clk_in,
  input logic rst_in,
  
  output wire sh,
  output wire add,
  output logic done
);

typedef enum logic[4:0] {
  S0,
  S1,
  S2,
  S3,
  S4
} states_t;

logic [3:0] cnt;
initial assign cnt = 4;


states_t current_state;
states_t next_state;

always_ff @(posedge clk_in or negedge rst_in) begin
  if (!rst_in) begin
    done <= '0;
    current_state <= S0;
  end
  else begin
    current_state <= next_state;
    $display ("current_state=", current_state);
    $display ("next_state=", next_state);
  end
  
end

always_comb begin: next_state_logic
  case (current_state)
    S0: begin
      if (adx == 0) next_state = S0;
      else if (adx == '1) next_state = S1;
    end
    S1:
      next_state = S2;
    S2:
      next_state = S3;
    S3:
      next_state = S4;
    S4:
      next_state = S1;
  endcase
end

always_comb begin: output_logic
    if (current_state == S4) done = '1;

end
// always_ff @(posedge clk_in) begin
//   if (cnt <= 0) done = 1;
//   cnt <= cnt - 1;

  





endmodule: mult_controler

// module multiplier (
//   input wire[3:0] x,
//   input wire[3:0] y,
//   input wire start,
//   input wire clk_in,
//   input wire rst_in,
//   output logic[3:0] product,
//   output logic ready
// );

//   typedef enum logic[1:0] {
//     IDLE,
//     RUNNING,
//     FINISHING
//   } states_t;

//   states_t current_state;
//   states_t next_state;

//   logic [3:0] tmpx;
//   logic [3:0] tmpy;
//   logic [3:0] tmpProduct;
//   logic done;
//   initial assign current_state = IDLE;

//   always_ff @(negedge rst_in) begin
//     tmpx <= 0;
//     tmpy <= 0;
//     current_state <= IDLE;
//   end

//   always @(posedge clk_in) begin
//     current_state <= next_state;
//   end;

//   always_comb begin: next_state_logic
//     case (current_state) 
//       IDLE: 
//         if (start) next_state = RUNNING;
//         else next_state = IDLE;
//       RUNNING:
//         if (done) next_state = FINISHING;
//         else next_state = RUNNING;
//       FINISHING:
//         next_state = IDLE;
//     endcase
//   end;

//   always_comb begin: output_logic 
//     case (current_state)
//       IDLE:
//         if (start) begin: load_registers
//           tmpx = x;
//           tmpy = y;
//         end   
//       RUNNING:begin
//         // m = tmpy[0];
        
//         $display ("Running. tmpy[0] = %b", tmpy[0]);
//         tmpy = tmpy >> 1;
//       end
//       FINISHING: begin
//         product = tmpProduct;        
//         ready = 1;
//       end
//         //Do nothing
      
//     endcase 
//   end;
//   logic m;
//   logic adx;
//   wire sh;
//   wire add;
  
//   mult_controler mu0 (
//     .m(m),
//     .adx(adx),
//     .sh(sh),
//     .add(add),
//     .done(done)
//   );
  
//   // salways_ff @()

// endmodule 