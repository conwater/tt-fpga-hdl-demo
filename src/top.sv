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
   tt_um_template tt(.*);

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
   
   // create clock signals
   clkdiv4 (.clk(clk), .reset(reset), .clk_out(clk_disp));

endmodule

module clkdiv4 (
   input logic clk,
   input logic reset,
   output logic clk_out,
);
   logic clk_int;

   always_ff @ (posedge clk, posedge reset) begin
      if (reset) begin
         clk_int <= 0;
      end
      else begin
         clk_int <= ~clk_int;
      end
   end

   always_ff @ (posedge clk_int, posedge reset) begin
      if (reset) begin
         clk_out <= 0;
      end
      else begin
         clk_out <= ~clk_out;
      end
   end

endmodule
   
