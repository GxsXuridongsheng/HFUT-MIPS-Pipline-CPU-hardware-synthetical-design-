`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/28 21:38:44
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
    input wire clk, 
    input wire rst, 
    input wire [31:0] pc_plus4_in,  
    input wire [31:0] read_data1_in, 
    input wire [31:0] read_data2_in, 
    input wire [31:0] imm_after_se_in, 
    input wire [31:0] imm_after_ue_in, 
    input wire [4:0] rt_in, 
    input wire [4:0] rd_in, 
    input wire [4:0] sa_in, 
    output reg [31:0] pc_plus4_out,
    output reg [31:0] read_data1_out, 
    output reg [31:0] read_data2_out, 
    output reg [31:0] imm_after_se_out, 
    output reg [31:0] imm_after_ue_out, 
    output reg [4:0] rt_out, 
    output reg [4:0] rd_out, 
    output reg [4:0] sa_out
    );
    
    always @(posedge clk) begin
        if(rst) begin
            pc_plus4_out <= 0;
            read_data1_out <= 0;
            read_data2_out <= 0;
            imm_after_se_out <= 0;
            imm_after_ue_out <= 0;
            rt_out <= 0;
            rd_out <= 0;
            sa_out <= 0;
        end
        else begin
            pc_plus4_out <= pc_plus4_in;
            read_data1_out <= read_data1_in;
            read_data2_out <= read_data2_in;
            imm_after_se_out <= imm_after_se_in;
            imm_after_ue_out <= imm_after_ue_in;
            rt_out <= rt_in;
            rd_out <= rd_in;
            sa_out <= sa_in;
        end
    end
endmodule
