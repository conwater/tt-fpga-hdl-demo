`line 2 "top.tlv" 0
`line 42 "top.tlv" 1

//_\SV
   // Include Tiny Tapeout Lab.
   // Included URL: "https://raw.githubusercontent.com/os-fpga/Virtual-FPGA-Lab/35e36bd144fddd75495d4cbc01c4fc50ac5bde6f/tlv_lib/tiny_tapeout_lib.tlv"// Included URL: "https://raw.githubusercontent.com/os-fpga/Virtual-FPGA-Lab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlv_lib/fpga_includes.tlv"
`line 63 "top.tlv" 1
//_\SV

// ================================================
// A simple Makerchip Verilog test bench driving random stimulus.
// Modify the module contents to your needs.
// ================================================

module top(input logic clk, input logic reset, input logic [31:0] cyc_cnt, output logic passed, output logic failed);
   // Tiny tapeout I/O signals.
   logic [7:0] ui_in, uo_out;
   
   logic [31:0] r;  // a random value
   always @(posedge clk) r <= $urandom();
   assign ui_in = r[7:0];
   
   logic ena = 1'b0;
   logic rst_n = ! reset;

   /*
   // Or, to provide specific inputs at specific times (as for lab C-TB) ...
   // BE SURE TO COMMENT THE ASSIGNMENT OF INPUTS ABOVE.
   // BE SURE TO DRIVE THESE ON THE B-PHASE OF THE CLOCK (ODD STEPS).
   // Driving on the rising clock edge creates a race with the clock that has unpredictable simulation behavior.
   initial begin
      #1  // Drive inputs on the B-phase.
         ui_in = 8'h0;
      #10 // Step 5 cycles, past reset.
         ui_in = 8'hFF;
      // ...etc.
   end
   */

   // Instantiate the Tiny Tapeout module.
   tt_um_template tt(.*);

   assign passed = top.cyc_cnt > 60;
   assign failed = 1'b0;
endmodule

// Provide a wrapper module to debounce input signals if requested.

//_\SV

// =======================
// The Tiny Tapeout module
// =======================

module tt_um_template (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
    /*   // The FPGA is based on TinyTapeout 3 which has no bidirectional I/Os (vs. TT6 for the ASIC).
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    */
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
   wire reset = ! rst_n;

`include "top_gen.sv" //_\TLV
   /* verilator lint_off UNOPTFLAT */
   // Connect Tiny Tapeout I/Os to Virtual FPGA Lab.
   `line 77 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/35e36bd144fddd75495d4cbc01c4fc50ac5bde6f/tlvlib/tinytapeoutlib.tlv" 1
      assign L0_slideswitch_a0[7:0] = ui_in;
      assign L0_sseg_segment_n_a0[6:0] = ~ uo_out[6:0];
      assign L0_sseg_decimal_point_n_a0 = ~ uo_out[7];
      assign L0_sseg_digit_n_a0[7:0] = 8'b11111110;
   //_\end_source
   `line 128 "top.tlv" 2

   // Instantiate the Virtual FPGA Lab.
   `line 308 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
      
      `line 356 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
         //_/thanks
            /* Viz omitted here */























      //_\end_source
      `line 310 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
      
   
      // Board VIZ.
   
      // Board Image.
      /* Viz omitted here */



















      //_/fpga_pins
         /* Viz omitted here */


         //_/fpga
            `line 48 "top.tlv" 1
               assign FpgaPins_Fpga_reset_a0 = reset;
               assign FpgaPins_Fpga_btn_a0[3:0] = ui_in[3:0];
            
               // instantiate clocks
               assign FpgaPins_Fpga_clk_a0 = clk;
               assign FpgaPins_Fpga_ssd_clk_a0 = FpgaPins_Fpga_ssd_clk_a2 ? 1'b0 : 1'b1;
            
               assign FpgaPins_Fpga_tens_a0[6:0] = 7'b0000110;
               assign FpgaPins_Fpga_ones_a0[6:0] = 7'b1001111;
            
               assign uo_out[7:0] = FpgaPins_Fpga_ssd_clk_a0 ? {1'b1, FpgaPins_Fpga_tens_a0} : {1'b0, FpgaPins_Fpga_ones_a0};
            
               // Connect Tiny Tapeout outputs. Note that uio_ outputs are not available in the Tiny-Tapeout-3-based FPGA boards.
               
               
            //_\end_source
            `line 341 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
   
      // LEDs.
      
   
      // 7-Segment
      `line 396 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
         for (digit = 0; digit <= 0; digit++) begin : L1_Digit //_/digit
            /* Viz omitted here */



















            for (leds = 0; leds <= 7; leds++) begin : L2_Leds logic L2_viz_lit_a0; //_/leds
               assign L2_viz_lit_a0 = (! L0_sseg_digit_n_a0[digit]) && ! ((leds == 7) ? L0_sseg_decimal_point_n_a0 : L0_sseg_segment_n_a0[leds % 7]);
               /* Viz omitted here */
































               end end
      //_\end_source
      `line 347 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
   
      // slideswitches
      `line 455 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
         for (switch = 0; switch <= 7; switch++) begin : L1_Switch logic L1_viz_switch_a0; //_/switch
            assign L1_viz_switch_a0 = L0_slideswitch_a0[switch];
            /* Viz omitted here */










































            end
      //_\end_source
      `line 350 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
   
      // pushbuttons
      
   //_\end_source
   `line 131 "top.tlv" 2
   // Label the switch inputs [0..7] (1..8 on the physical switch panel) (top-to-bottom).
   `line 83 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/35e36bd144fddd75495d4cbc01c4fc50ac5bde6f/tlvlib/tinytapeoutlib.tlv" 1
      for (input_label = 0; input_label <= 7; input_label++) begin : L1_InputLabel //_/input_label
         /* Viz omitted here */















         end
   //_\end_source
   `line 133 "top.tlv" 2

//_\SV
endmodule


// Undefine macros defined by SandPiper (in "top_gen.sv").
`undef BOGUS_USE
