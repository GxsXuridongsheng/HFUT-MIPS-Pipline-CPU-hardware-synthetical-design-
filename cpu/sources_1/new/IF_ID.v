`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/28 21:16:29
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
    input wire clk, 
    input wire rst, 
    input wire en, 
    input wire [31:0] pc_plus4_in, 
    input wire [31:0] instruction_in, 
    output reg [31:0] pc_plus4_out, 
    output reg [31:0] instruction_out
    );
    
    always @(posedge clk) begin
        if(rst) begin
            pc_plus4_out <= 0;
            instruction_out <= 0;
        end
        else if(en) begin
            pc_plus4_out <= pc_plus4_in;
            instruction_out <= instruction_in;
        end
    end
endmodule
