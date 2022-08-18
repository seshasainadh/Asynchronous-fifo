
`timescale 1ns/ 1ps



////

module transmisson(write_pointer,data_out);

output [7:0] data_out;
input [7:0] write_pointer;
reg [7:0] input_ROM [127:0];
integer z;
initial begin

for(z=0;z<128;z=z+1)
input_ROM[z] = z*2;
end

assign data_out = input_ROM[write_pointer];

endmodule

module Asynchronous_FIFO(read_clk,write_clk,reset,data_out,r_empty,w_full);

//p-pointer , w-width

parameter p =4;
parameter w=8;
parameter depth= 1<< p;

input read_clk,write_clk;
input reset;
output w_full,r_empty;
output [w-1 : 0] data_out;

wire [w-1 :0] data_in;
wire [p:0] read_pointer_grey, write_pointer_grey;
wire [p:0] read_pointer_bin, write_pointer_bin;

reg [p:0] read_pointer,read_s1,read_s2;
reg [p:0] write_pointer,write_s1,write_s2;
reg [w-1:0] memory[depth-1:0];
reg [7:0] transmitter_ptr;
reg full,empty;

always @(posedge reset or posedge write_clk)
begin
	if (reset) begin
		write_pointer <=0;
		transmitter_ptr <=0;
	end
	else if (full == 1'b0) begin
		write_pointer <= write_pointer+1;
		transmitter_ptr<= transmitter_ptr+1;
		memory[write_pointer[p-1:0]]<= data_in;
	end
end

transmisson t(transmitter_ptr,data_in);


always @(posedge write_clk) begin
	read_s1 <= read_pointer_grey;
	read_s2 <= read_s1;
end


always @(posedge reset or posedge read_clk) 
begin
	if (reset) begin
		read_pointer <=0;
	end
	else if(empty ==1'b0) begin
		read_pointer <= read_pointer +1;
	end
end

always @ (posedge read_clk) begin
	write_s1 <= write_pointer_grey;
	write_s2 <= write_s1;
end



always @(*)
begin	
	if(write_pointer_bin==read_pointer)
		empty=1;
	else
		empty=0;
end

always @(*)
begin
	if({~write_pointer[p],write_pointer[p-1:0]}==read_pointer_bin)
		full = 1;
	else
		full = 0;
end
	
	assign data_out = memory[read_pointer[p-1 : 0]];
	assign w_full = full;
	assign r_empty=empty;
	
	
	assign write_pointer_grey = write_pointer ^ (write_pointer >> 1);
    assign read_pointer_grey = read_pointer ^ (read_pointer >> 1);
	
	
	
	assign write_pointer_bin[4]=write_s2[4];
	assign write_pointer_bin[3]=write_s2[3] ^ write_pointer_bin[4];
	assign write_pointer_bin[2]=write_s2[2] ^ write_pointer_bin[3];
	assign write_pointer_bin[1]=write_s2[1] ^ write_pointer_bin[2];
	assign write_pointer_bin[0]=write_s2[0] ^ write_pointer_bin[1];
	
	assign read_pointer_bin[4]=read_s2[4];
	assign read_pointer_bin[3]=read_s2[3] ^ read_pointer_bin[4];
	assign read_pointer_bin[2]=read_s2[2] ^ read_pointer_bin[3];
	assign read_pointer_bin[1]=read_s2[1] ^ read_pointer_bin[2];
	assign read_pointer_bin[0]=read_s2[0] ^ read_pointer_bin[1];

endmodule
	

	

	

	
	
	