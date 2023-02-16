`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/28 21:39:33
// Design Name: 
// Module Name: MEM_WB
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


module MEM_WB(
    input wire clk, 
    input wire rst, 
    input wire [31:0] mem_data_in, 
    input wire [31:0] alu_result_in, 
    input wire [31:0] reg_dest_in, 
    output reg [31:0] mem_data_out, 
    output reg [31:0] alu_result_out, 
    output reg [31:0] reg_dest_out
    );

    always @(posedge clk) begin
        if(rst) begin
            mem_data_out <= 0;
            alu_result_out <= 0;
            reg_dest_out <= 0;
        end
        else begin
            mem_data_out <= mem_data_in;
            alu_result_out <= alu_result_in;
            reg_dest_out <= reg_dest_in;
        end
    end
endmodule
