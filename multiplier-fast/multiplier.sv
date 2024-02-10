h/*
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

logic [7:0] cntr;

typedef enum logic[4:0] {
  IDLE = 'b0000,
  RUNNING = 'b00001,
  DONE = 'b00010
} mc_states_t;

mc_states_t current_state;
mc_states_t next_state;

always_ff @(posedge clk_in or negedge rst_in) begin
  if (!rst_in) begin
    current_state <= IDLE;
    cntr <= 4'd3;
    done <= '0;
  end
  else begin
    current_state <= next_state;  
    if (current_state == RUNNING) cntr <= cntr - 1;
    $display ("multiplier.mult_controller: current_state=", next_state);
  end
  
end

always_comb begin: next_state_logic
  case (current_state)
    IDLE: begin
      if (adx) next_state = RUNNING;
      else next_state = IDLE;
      
    end
    RUNNING:
      if (cntr <= '0) next_state = DONE;
    DONE:
      next_state = IDLE;
  endcase
end

// always @(posedge clk_in) begin: output_logic
  always_comb begin: output_logic
    case (current_state)
      IDLE: begin
        $display ("mult_ctlr: IDLE STATE");
        done = '0;
      end
      
      RUNNING: begin
      $display ("mult_ctlr: RUNNING STATE:m=%b", m);

      if (m == '1) begin: add_then_shift
        add = '1;
        sh = '1;
      end
      else if (m == '0) begin: just_shift
        add = '0;
        sh = '1;
      end
      end

      DONE: begin
        $display ("mult_ctlr: DONE STATE");  
        add = '0;
        sh = '0;
        done = '1;
      end
    endcase
    end

endmodule: mult_controler

module multiplier (
  input wire[3:0] x,
  input wire[3:0] y,
  input wire start,
  input wire clk_in,
  input wire rst_in,
  output logic[7:0] product,
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
  logic [7:0] accP;
  logic load;
  wire mdone;

  // Multiplier Controler
  logic m;
  logic adx;
  logic sh;
  logic add;
  
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
      accP <= 0;
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

  // always @(posedge clk_in) begin: output_logic 
  
  always_comb begin: output_logic
    case (current_state) 
      IDLE: begin
        $display ("IDLE STATE MULTIPLIR");
      end
      
      LOAD: begin
        $display ("LOAD STATE MULTIPLIER");
        // tmpx = x;
        accP[3:0] = x;
        accP[7:4] = 0;
        tmpy = y;
        adx = '1;
        
      end
      RUNNING: begin  
        $display ("RUNNING STATE MULTIPLIER");
      end
      DONE: begin
        $display ("DONE STATE MULTIPLIER");
        // Copy out the outputs
        product = accP;
        ready = 1;
        adx = '0;
      end
        //Do nothing
      
    endcase 
  end;

  // Set the M input for the controler
  always_ff @(posedge clk_in) begin: set_msb
    // This needed to be clocked so that prevent oversampling in mult_controler
    // Output logic
    m <= accP[0];
    
     $display ("m=%b\tsh=%b\tad=%b", accP, sh, add); 
  end
  
  // Shift, Needs to be clocked to ensure non-changes in 'SH' get executed
  // Negede since posedge causes a race condition with retrieving the msb m
  always_ff @(negedge clk_in) begin: shift
    if (add) begin
      accP[7:4] = accP[7:4] + tmpy;
    end
    
    if (sh) begin
      accP = accP >> 1;
      
    end
    $display ("multiplier.sv:tmpproduct=%b", tmpy);
  end
  


  
  // salways_ff @()

endmodule 