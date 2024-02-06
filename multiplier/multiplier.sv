/*
  Functionality: 4 bit multiplier.
  Description: 4 bit multiplier that uses a finite state machine internally.
*/


module mult_controler (
  input logic m,
  input logic adx,
  input logic clk_in,
  input logic rst_in,
  
  output logic sh,
  output logic add,
  output logic done
);

typedef enum logic[4:0] {
  IDLE = 'b0000,
  S1 = 'b00001,
  S2 = 'b00010,
  S3 = 'b00011,
  S4 = 'b00100
} mc_states_t;

mc_states_t current_state;
mc_states_t next_state;

always_ff @(posedge clk_in or negedge rst_in) begin
  if (!rst_in) begin
    done <= '0;
    current_state <= IDLE;
  end
  else begin
    current_state <= next_state;
    $display ("multiplier.mult_controller: next_state=", next_state);
    // $display ("next_state=", next_state);
  end
  
end

always_comb begin: next_state_logic
  case (current_state)
    IDLE: begin
      if (adx) next_state = S1;
      else next_state = IDLE;
      
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

always @(posedge clk_in) begin: output_logic
    if (current_state == IDLE) done <= '0;
    if (current_state == S4) done <= '1;
    if (current_state != IDLE) begin
      if (m == '1) begin: add_then_shift
        add <= '1;
        sh <= '1;
      end
      else if (m == '0) begin: just_shift
        add <= '0;
        sh <= '1;
      end
    end

end
endmodule: mult_controler

module multiplier (
  input wire[3:0] x,
  input wire[3:0] y,
  input wire start,
  input wire clk_in,
  input wire rst_in,
  output logic[3:0] product,
  output logic ready
);

  typedef enum logic[3:0] {
    IDLE = 'b0,
    LOAD = 'b1,
    RUNNING = 'b10,
    DONE = 'b11
  } states_t;

  // States 
  states_t current_state;
  states_t next_state;

  // Internal Registers
  logic [3:0] tmpx;
  logic [3:0] tmpy;
  logic [3:0] tmpProduct;
  logic load;
  wire mdone;

  // Multiplier Controler
  logic m;
  logic adx;
  wire sh;
  wire add;
  
  mult_controler mu0 (
    .m(m),
    .adx(adx),
    .clk_in (clk_in),
    .rst_in (rst_in),
    .sh(sh),
    .add(add),
    .done(mdone)
  );

  // State Transition
  always @(posedge clk_in or negedge rst_in) begin
    if (!rst_in) begin
      tmpx <= 0;
      tmpy <= 0;
      tmpProduct <= 0;
      load <= 0;
      ready <= 0;
      adx = '0;
      current_state <= IDLE;
    end
    else begin
      current_state <= next_state;
      $display ("multiplier.sv:multiplier: next_state = %b", next_state);
    end
  end;

  // Next State Logic
  always_comb begin: next_state_logic
    case (current_state) 
      IDLE: 
        if (start) next_state = LOAD;
        else next_state = IDLE;
      LOAD:
        next_state = RUNNING;  
      RUNNING:
        if (mdone) next_state = DONE;
        else next_state = RUNNING;
      DONE:
        next_state = IDLE;
    endcase
  end;

  always @(posedge clk_in) begin: output_logic 
    
    case (current_state) 
      IDLE:
        $display ("IDLE STATE MULTIPLIR");
      LOAD: begin
        $display ("LOAD STATE MULTIPLIER");
        adx <= '1;
      end
      RUNNING: begin  
        $display ("RUNNING STATE MULTIPLIER");
        
        // tmpy = tmpy >> 1;
      end
      DONE: begin
        $display ("DONE STATE MULTIPLIER");
        // Copy out the outpus
        product <= tmpProduct;        
        ready <= 1;
      end
        //Do nothing
      
    endcase 
  end;

  // always_comb @(m) begin: get_msb

  // end

  // always_comb @(sh) begin: shift
  //   if (sh) begin
  //     tmpx = tmpx >> 1;
  //     tmpProduct = product >> 1;
  //   end
  // end

  // always_comb @(load) begin: load_registers
  //   if (load) begin
  //     tmpx = x;
  //     tmpy = y;
  //     tmpProduct = product;
  //   end
  // end

  
  // salways_ff @()

endmodule 