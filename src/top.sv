module top (
   input logic        clk, 
   input logic        reset, 
   input logic [31:0] cyc_cnt, 
   output logic       passed, 
   output logic       failed
);
   // Tiny Tapeout I/O signals
   logic [7:0] ui_in, uo_out;
   logic [31:0] r;  // a random value
   always @(posedge clk) r <= 0;
   assign ui_in = r[7:0];
   logic ena = 1'b0;
   logic rst_n = !reset;

   // instantiate the Tiny Tapeout module
   tt_um_template tt (.*);

   assign passed = top.cyc_cnt > 60;
   assign failed = 1'b0;
endmodule

module tt_um_template (
   input  wire [7:0] ui_in,    // inputs (switches)
   output wire [7:0] uo_out,   // outputs (seven-segment display)
   input  wire       ena,      // will go high when the design is enabled
   input  wire       clk,      // clock
   input  wire       rst_n     // reset (active low)
);
   wire reset = !rst_n; // reset (active high)
   wire btns = ui_in[7:4];
   wire dsws = ui_in[3:0];
   
   // create clock signals
   logic clk_disp;
   logic clk_tenths;

   clkdiv4 cd0 (.clk(clk), .reset(reset), .clk_out(clk_disp));
   clkdiv2M cd1 (.clk(clk), .reset(reset), .clk_out(clk_tenths));

   // dual seven-segment display driver
   logic [3:0] digit;
   logic [3:0] tens;
   logic [3:0] ones;

   assign digit = clk_disp ? tens : ones;
   assign uo_out = {clk_disp,
      digit == 4'h0 ? 7'b0111111 :
      digit == 4'h1 ? 7'b0000110 :
      digit == 4'h2 ? 7'b1011011 :
      digit == 4'h3 ? 7'b1001111 :
      digit == 4'h4 ? 7'b1100110 :
      digit == 4'h5 ? 7'b1101101 :
      digit == 4'h6 ? 7'b1111101 :
      digit == 4'h7 ? 7'b0000111 :
      digit == 4'h8 ? 7'b1111111 :
      digit == 4'h9 ? 7'b1101111 :
                      7'b0000000};

   // game logic
   logic [1:0] state;
   typedef enum logic [1:0] {START=0, READY=1, PLAY=2, FINISH=3} state_t;

   always_ff @ (posedge clk or posedge reset) begin
      if (reset) begin
         state <= START;
      end
      else begin
         case (state)
            START:   begin
                        // turns off display
                        tens <= 4'hf;
                        ones <= 4'hf;

                        if (ui_in[0])
                           state <= READY;
                     end
            READY:   begin
                        // test turn on displays
                        tens <= 4'h1;
                        ones <= 4'h1;
                     end
            PLAY:    begin
                     end
            FINISH:  begin
                     end
         endcase
      end
   end

endmodule

module clkdiv4 (
   input logic clk,
   input logic reset,
   output logic clk_out,
);
   logic clk_int; // intermediate clock signal between divisions

   always_ff @ (posedge clk, posedge reset) begin
      if (reset)
         clk_int <= 0;
      else
         clk_int <= ~clk_int;
   end

   always_ff @ (posedge clk_int, posedge reset) begin
      if (reset)
         clk_out <= 0;
      else
         clk_out <= ~clk_out;
   end

endmodule

module clkdiv2M (
    input logic clk,
    input logic reset,
    output logic clk_out,
);
   logic [20:0] counter;
   parameter MAX = 2_000_000;

   always_ff @ (posedge clk, posedge reset) begin
      if (reset)
         counter <= 0;
      else if (counter == MAX)
         counter <= 0;
      else
        counter <= counter + 1;
   end

assign clk_out = (counter == MAX);

endmodule
