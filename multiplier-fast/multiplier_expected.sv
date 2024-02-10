/*
  Functionality: 4 bit multiplier expected.
  Description: 4 bit multiplier that uses a finite state machine internally.
*/
module multiplier (
  input wire[3:0] x,
  input wire[3:0] y,
  input wire start,
  input wire clk_in,
  input wire rst_in,
  output logic[3:0] product,
  output wire ready
);

  typedef enum logic {
    IDLE,
    INIT,
    RUNNING
  } states_t;

  states_t current_state;
  states_t next_state;

  logic [3:0] tmpx;
  logic [3:0] tmpy;
  initial assign current_state = IDLE;

  always_ff @(negedge rst_in) begin
    tmpx <= 0;
    tmpy <= 0;
    current_state <= IDLE;
  end

  always @(posedge clk_in) begin
    current_state <= next_state;
  end;

  always_comb begin: next_state_logic
    case (current_state) 
      IDLE: 
        if (start) next_state = INIT;
        else next_state = IDLE;
      INIT:
        next_state = RUNNING;
      RUNNING:
        if (done) next_state = 

    endcase
  end;

  always_comb begin: output_logic 
    case (current_state)
      IDLE:
        if (start) begin: load_registers
          tmpx = x;
          tmpy = y;
        end 
      INIT:
        product = x * y; 
      RUNNING:
        
        //Do nothing
      
    endcase 
  end;

endmodule