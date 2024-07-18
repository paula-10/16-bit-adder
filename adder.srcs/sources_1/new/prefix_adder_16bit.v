`timescale 1ns / 1ps // 1 nanosecunda pentru unitate de timp
                    // precizie de 1 piccosecunda
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/27/2024 10:53:47 AM
// Design Name: 
// Module Name: prefix_adder_16bit
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


module prefix_adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input cin,      // carry initial
    output [15:0] sum,
    output cout     // carry final
);

wire [15:0] G, P; // vectori de 16 biti folositi pentru semnalele de generare si propagare
wire [15:0] C;    // vectorul de purtatori

// Generate and Propagate
assign G = a & b; // G[i] = a[i] & b[i]: bitul i din G este 1 dacă ambii biți corespondenți din a și b sunt 1
assign P = a ^ b; // P[i] = a[i] ^ b[i]: bitul i din P este 1 dacă unul dintre biți este 1, dar nu amândoi

// Prefix computation (Brent-Kung stages)
wire [15:0] G1, P1, G2, P2, G3, P3; // semnale intermediare

// Stage 1
// initializam primii biti din vectorii de semnale intermediare cu valorile din G si P
assign G1[0] = G[0];
assign P1[0] = P[0];
generate
    genvar i;
    // calculam G1[i] si P1[i] folosind valorile din G si P ale bitului curent si bitului precedent
    for (i = 1; i < 16; i = i + 1) begin
        assign G1[i] = G[i] | (P[i] & G[i-1]);
        assign P1[i] = P[i] & P[i-1];
    end
endgenerate

// Stage 2
// copiem primii doi biți din G1 și P1 în G2 și P2.
assign G2[1:0] = G1[1:0];
assign P2[1:0] = P1[1:0];
generate
    // calculăm G2 și P2 pentru fiecare al doilea bit, folosind valorile corespunzătoare din G1 și P1
    for (i = 2; i < 16; i = i + 2) begin
        assign G2[i] = G1[i] | (P1[i] & G1[i-2]);
        assign P2[i] = P1[i] & P1[i-2];
        assign G2[i+1] = G1[i+1];
        assign P2[i+1] = P1[i+1];
    end
endgenerate

// Stage 3
// copiem primii patru biți din G2 și P2 în G3 și P3
assign G3[3:0] = G2[3:0];
assign P3[3:0] = P2[3:0];
generate
    for (i = 4; i < 16; i = i + 4) begin
        assign G3[i] = G2[i] | (P2[i] & G2[i-4]);
        assign P3[i] = P2[i] & P2[i-4];
        assign G3[i+1] = G2[i+1];
        assign P3[i+1] = P2[i+1];
        assign G3[i+2] = G2[i+2];
        assign P3[i+2] = P2[i+2];
        assign G3[i+3] = G2[i+3];
        assign P3[i+3] = P2[i+3];
    end
endgenerate

// Final carry computation
assign C[0] = cin;
generate
    // calculăm fiecare purtător C[i] folosind valorile din G3, P3 și purtătorul anterior C[i-1]
    for (i = 1; i < 16; i = i + 1) begin
        assign C[i] = G3[i-1] | (P3[i-1] & C[i-1]);
    end
endgenerate
assign cout = G3[15] | (P3[15] & C[15]);

// suma este calculata folosind operatia XOR intre P si C
assign sum = P ^ C;

endmodule
