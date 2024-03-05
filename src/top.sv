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
   
   logic clk_disp;

   logic [3:0] digit;
   logic [3:0] tens;
   logic [3:0] ones;

   assign tens = 4'h2;
   assign ones = 4'h3;
   
   // create clock signals
   clkdiv2 cd (.clk(clk), .reset(reset), .clk_out(clk_disp));

   assign digit = clk_disp ? tens : ones;

   uo_out = {clk_disp,
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

endmodule

module clkdiv2 (
   input logic clk,
   input logic reset,
   output logic clk_out,
);

   always_ff @ (posedge clk, posedge reset) begin
      if (reset) begin
         clk_out <= 0;
      end
      else begin
         clk_out <= ~clk_out;
      end
   end

endmodule
   
