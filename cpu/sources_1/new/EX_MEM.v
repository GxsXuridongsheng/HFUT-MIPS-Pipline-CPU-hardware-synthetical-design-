`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/28 21:39:10
// Design Name: 
// Module Name: EX_MEM
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


module EX_MEM(
    input wire clk, 
    input wire rst, 
    input wire [31:0] pc_branch_in, 
    input wire  alu_zero_in, 
    input wire [31:0] alu_result_in, 
    input wire [31:0] read_data2_in, 
    input wire [4:0] reg_dest_in, 
    output reg [31:0] pc_branch_out, 
    output reg  alu_zero_out, 
    output reg [31:0] alu_result_out, 
    output reg [31:0] read_data2_out, 
    output reg [4:0] reg_dest_out 
    );

    always @(posedge clk) begin
        if(rst) begin
            pc_branch_out <= 0;
            alu_result_out <= 0;
            alu_result_out <= 0;
            read_data2_out <= 0;
            reg_dest_out <= 0;
        end
        else begin
            pc_branch_out <= pc_branch_in;
            alu_zero_out <= alu_zero_in;
            alu_result_out <= alu_result_in;
            read_data2_out <= read_data2_in;
            reg_dest_out <= reg_dest_in;
        end
    end
endmodule
