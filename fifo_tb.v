`timescale 1ns / 1ps


module fifo_tb;

	// Inputs
	reg read_clk;
	reg write_clk;
	reg reset;

	// Outputs
	wire [7:0] data_out;
	wire r_empty;
	wire w_full;

	// Instantiate the Unit Under Test (UUT)
	Asynchronous_FIFO uut (
		.read_clk(read_clk), 
		.write_clk(write_clk), 
		.reset(reset), 
		.data_out(data_out), 
		.r_empty(r_empty), 
		.w_full(w_full)
	);

	initial begin
		// Initialize Inputs
		read_clk = 0;
		write_clk = 0;
		reset = 1;
		#2 reset=0;
	end
		// Wait 100 ns for global reset to finish
		always begin
		#2.5 write_clk = ~write_clk;
		end
		always begin
		#25 read_clk = ~read_clk;
		end
        
		// Add stimulus here

      
endmodule

