
             //-----------------------------------------------------
   // This is my second Verilog Design
   // Design Name : first_counter
   // File Name : first_counter.v
   // Function : This is a 4 bit up-counter with
   // Synchronous active high reset and
   // with active high enable signal
   //-----------------------------------------------------
   module first_counter (
  clock , // Clock input of the design
  reset , // active high, synchronous Reset input
  enable , // Active high enable signal for counter
  counter_out,// 4 bit vector output of the counter
  clock_out

  ); // End of port list
  //-------------Input Ports-----------------------------
  input clock ;
  input reset ;
  input enable ;
  //-------------Output Ports----------------------------
  output [3:0] counter_out ;
  output clock_out;
  
  //-------------Input ports Data Type-------------------
  // By rule all the input ports should be wires
  wire clock ;
  wire reset ;
  wire enable ;
  //-------------Output Ports Data Type------------------
  // Output port can be a storage element (reg) or a wire
  reg [3:0] counter_out ;
  reg clock_out;
  //------------Code Starts Here-------------------------
  // Since this counter is a positive edge trigged one,
  // We trigger the below block with respect to positive
  // edge of the clock.
  always @ (posedge reset)
  begin
      counter_out <=  #1  4'b0000;
	  clock_out <= 1'b0;
  end
  
  always @ (posedge clock)
  begin : COUNTER // Block Name
    // At every rising edge of clock we check if reset is active
    // If enable is active, then we increment the counter
    if (enable == 1'b1) begin
  	 if(counter_out==4'b1111) begin
	  clock_out <= #1 1'b1;
	 end
	 else
	 begin
	  clock_out <= #1 1'b0;
	 end
	 counter_out <=  #1 counter_out + 1;
	 
    end
  end // End of Block COUNTER
endmodule
