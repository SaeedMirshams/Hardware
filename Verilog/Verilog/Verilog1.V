`include "first_counter.v"
module first_counter_tb();
// Declare inputs as regs and outputs as wires
reg clock, reset, enable;
wire carry_out;
wire carry_out1;

wire [3:0] counter_out;
wire [3:0] counter_out1;

// Initialize all variables
initial begin
		$dumpfile("dump.vcd");
		$dumpvars;
  $display ("time\t clk reset enable counter");
  /*$monitor ("%g\t %b   %b     %b      %b",
      $time, clock, reset, enable, counter_out);*/
  clock = 1;       // initial value of clock
  reset = 0;       // initial value of reset
  enable = 0;      // initial value of enable
  #5 reset = 1;    // Assert the reset
  #10 reset = 0;   // De-assert the reset
  #10 enable = 1;  // Assert enable
  #4500 enable = 0; // De-assert enable
  #5 $finish;      // Terminate simulation
end

// Clock generator
always begin
  #5 clock = ~clock; // Toggle clock every 5 ticks
end

// Connect DUT to test bench
first_counter My_counter (
clock,
reset,
enable,
counter_out,
carry_out
);

first_counter U_counter (
carry_out,
reset,
enable,
counter_out1,
carry_out1
);

endmodule
