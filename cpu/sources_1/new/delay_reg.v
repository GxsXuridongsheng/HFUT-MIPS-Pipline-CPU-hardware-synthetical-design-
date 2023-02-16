`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/28 22:17:08
// Design Name: 
// Module Name: delay_reg
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


module delay_reg(
    input wire clk, 
    input wire rst, 
    input wire jump_in, 
    input wire branch_e_in, 
    input wire branch_ne_in, 
    input wire regdest_in, 
    input wire memread_in, 
    input wire memwrite_in, 
    input wire memtoreg_in, 
    input wire alusrc_in, 
    input wire regwrite_in, 
    input wire [3:0] aluop_in, 
    input wire is_sign_in, 
    input wire zero_extern_in, 
    input wire use_sa_in, 
    input wire alu_sign_reset_in, 
    output reg jump_out = 0, 
    output reg branch_e_out = 0,
    output reg branch_ne_out = 0,  
    output reg regdest_out = 0, 
    output reg memread_out = 0, 
    output reg memwrite_out = 0, 
    output reg memtoreg_out = 0, 
    output reg alusrc_out = 0, 
    output reg regwrite_out = 0, 
    output reg [3:0] aluop_out = 4'b0000, 
    output reg is_sign_out = 1, 
    output reg zero_extern_out = 0, 
    output reg use_sa_out = 0, 
    output reg alu_sign_reset_out = 1
    );

    always @(posedge clk) begin
        if(rst) begin
            jump_out <= 0;// 不跳�?
            branch_e_out <= 0;// 不是beq
            branch_ne_out <= 0;// 不是bne
            regdest_out <= 0;// 控制要写的目标寄存器 或�?? 要不要读rt寄存器； 这里是要写的寄存器是rt或�?�不读rt寄存�?
            memread_out <= 0;// 不读内存
            memtoreg_out <= 0;// 不加载内存到寄存�?
            memwrite_out <= 0;// 不写内存
            alusrc_out <= 0;// alu第二个操作数来源为寄存器
            regwrite_out <= 0;// 不写寄存�?
            aluop_out <= 4'b0000;// �?
            is_sign_out <= 1;// 有符�?
            zero_extern_out <= 0;// 不用0拓展立即�?
            use_sa_out <= 0;// 不使用shift amount
            alu_sign_reset_out <= 1;// 清零时将alu的标志位清零
        end
        else begin
            jump_out <= jump_in;
            branch_e_out <= branch_e_in;
            branch_ne_out <= branch_ne_in;
            regdest_out <= regdest_in;
            memread_out <= memread_in;
            memtoreg_out <= memtoreg_in;
            memwrite_out <= memwrite_in;
            alusrc_out <= alusrc_in;
            regwrite_out <= regwrite_in;
            aluop_out <= aluop_in;
            is_sign_out <= is_sign_in;
            zero_extern_out <= zero_extern_in;
            use_sa_out <= use_sa_in;
            alu_sign_reset_out <= alu_sign_reset_in;
        end
    end
endmodule
