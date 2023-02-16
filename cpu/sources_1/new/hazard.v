`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/30 17:10:40
// Design Name: 
// Module Name: hazard
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


module hazard(
    input wire reg_dest, 
    input wire EX_memread, 
    input wire [4:0] read_reg1_addr, 
    input wire [4:0] read_reg2_addr, 
    input wire [4:0] EX_write_reg_addr, 
    input wire [4:0] MEM_write_reg_addr, 
    output reg stall = 0, 
    output reg forward1_EX = 0, forward2_EX = 0, forward1_MEM = 0, forward2_MEM = 0
    );

    always @(*) begin
        // stall = 0;
        forward1_EX = 0;
        forward2_EX = 0;
        forward1_MEM = 0;
        forward2_MEM = 0;
        stall = 0;
        if(reg_dest) begin
            if(EX_memread && (read_reg1_addr==EX_write_reg_addr || read_reg2_addr==EX_write_reg_addr) && EX_write_reg_addr!=0) begin
                stall = 1;
            end
            else begin
                if(read_reg1_addr==EX_write_reg_addr && EX_write_reg_addr!=0) begin
                    forward1_EX = 1;
                end
                if(read_reg1_addr==MEM_write_reg_addr && MEM_write_reg_addr!=0) begin
                    forward1_MEM = 1;
                end
                if(read_reg2_addr==EX_write_reg_addr && EX_write_reg_addr!=0) begin
                    forward2_EX = 1;
                end
                if(read_reg2_addr==MEM_write_reg_addr && MEM_write_reg_addr!=0) begin
                    forward2_MEM = 1;
                end
            end
        end
        else begin
            if(EX_memread && read_reg1_addr==EX_write_reg_addr && EX_write_reg_addr!=0) begin
                stall = 1;
            end
            else begin 
                if(read_reg1_addr==EX_write_reg_addr && EX_write_reg_addr!=0) begin
                    forward1_EX = 1;
                end
                if(read_reg1_addr==MEM_write_reg_addr && MEM_write_reg_addr!=0) begin
                    forward1_MEM = 1;
                end
            end
        end
    end
endmodule
