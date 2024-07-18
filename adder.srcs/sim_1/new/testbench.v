`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2024 10:50:33 AM
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module testbench;

reg [15:0] a, b;
reg cin;
wire [15:0] sum;
wire cout;

prefix_adder_16bit uut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin
    // Initialize inputs
    a = 16'h0;
    b = 16'h0;
    cin = 0;

    // Apply test vectors
    #10 a = 16'b1010101100111010; b = 16'b0101010011000111; cin = 0; // -21846 + 21845
    #10 a = 16'h1234; b = 16'h5678; cin = 0;
    #10 a = 16'hFFFF; b = 16'h0001; cin = 0;
    #10 a = 16'hAAAA; b = 16'h5555; cin = 1;
    // Add more test cases as needed

    // Finish simulation
    #10 $finish;
end

initial begin
    $monitor("At time %t, a = %d, b = %d, cin = %b : sum = %d, cout = %b",
             $time, a, b, cin, sum, cout);
end

endmodule




