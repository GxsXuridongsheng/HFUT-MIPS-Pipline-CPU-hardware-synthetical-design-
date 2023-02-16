`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/16 21:56:20
// Design Name: 
// Module Name: mips
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


module mips(
    input clk, 
    input rst, 
    output [7:0] seg, seg1, an
    );
    
    wire [31:0] pc, next_pc, pc_plus4;
    wire [31:0] instruction;
    wire [31:0] writedata;
    wire [31:0] data_addr;
    wire [31:0] mem_data;
    wire memwrite, EX_memwrite, MEM_memwrite, WB_memwrite;
    wire [4:0] write_data_reg_addr;
    wire [31:0] write_data_in;
    wire [31:0] aluop1, aluop2;
//    wire [31:0] dataaddr;
    wire [4:0] readdata1_addr;
    wire [4:0] readdata2_addr;
    wire [4:0] sa;
    wire [31:0] readdata1;
    wire [31:0] readdata2;
    wire [4:0] rt_addr;
    wire [4:0] rd_addr;
    wire [31:0] alu_result;
    wire [27:0] j_addr_after_sl2;
    wire [31:0] j_addr;
    wire [31:0] branch_addr_after_se_sl2;
    wire branch;
    wire [31:0] pc_pcplus4_branch;
    wire [31:0] branch_addr;
    wire [31:0] imm_after_se;
    wire [31:0] imm_after_ue;
    wire [31:0] imm_to_alu;
    wire [31:0] imm_after_se_sl2;
    wire overflow;
    wire zero;
    wire equal;
    wire jump, EX_jump, MEM_jump, WB_jump;
    wire branch_e, branch_ne, EX_branch_e, EX_branch_ne, MEM_branch_e, MEM_branch_ne, WB_branch_e, WB_branch_ne;
    wire regdest, EX_regdest, MEM_regdest, WB_regdest;
    wire memread, EX_memread, MEM_memread, WB_memread;
    wire memtoreg, EX_memtoreg, MEM_memtoreg, WB_memtoreg;
    wire alusrc, EX_alusrc, MEM_alusrc, WB_alusrc;
    wire regwrite, EX_regwrite, MEM_regwrite, WB_regwrite;
    wire [3:0] aluop, EX_aluop, MEM_aluop, WB_aluop;
    wire is_sign, EX_is_sign, MEM_is_sign, WB_is_sign;
    wire zero_extern, EX_zero_extern, MEM_zero_extern, WB_zero_extern;
    wire use_sa, EX_use_sa, MEM_use_sa, WB_use_sa;
    wire alu_sign_reset, EX_alu_sign_reset, MEM_alu_sign_reset, WB_alu_sign_reset;
    wire stall;
    
    wire [31:0] IF_ID_pc_plus4_in;
    wire [31:0] IF_ID_instruction_in;
    wire [31:0] IF_ID_pc_plus4_out;
    wire [31:0] IF_ID_instruction_out;
    
    wire [31:0] ID_EX_pc_plus4_in;
    wire [31:0] ID_EX_read_data1_in;
    wire [31:0] ID_EX_read_data2_in;
    wire [31:0] ID_EX_imm_after_se_in;
    wire [31:0] ID_EX_imm_after_ue_in;
    wire [4:0] ID_EX_rt_in;
    wire [4:0] ID_EX_rd_in;
    wire [4:0] ID_EX_sa_in;
    wire [31:0] ID_EX_pc_plus4_out;
    wire [31:0] ID_EX_read_data1_out;
    wire [31:0] ID_EX_read_data2_out;
    wire [31:0] ID_EX_imm_after_se_out;
    wire [31:0] ID_EX_imm_after_ue_out;
    wire [4:0] ID_EX_rt_out;
    wire [4:0] ID_EX_rd_out;
    wire [4:0] ID_EX_sa_out;
    
    wire [31:0] EX_MEM_pc_branch_in;
    wire [31:0] EX_MEM_alu_zero_in;
    wire [31:0] EX_MEM_alu_result_in;
    wire [31:0] EX_MEM_read_data2_in;
    wire [4:0] EX_MEM_reg_dest_in;
    wire [31:0] EX_MEM_pc_branch_out;
    wire EX_MEM_alu_zero_out;
    wire [31:0] EX_MEM_alu_result_out;
    wire [31:0] EX_MEM_read_data2_out;
    wire [4:0] EX_MEM_reg_dest_out;
    
    wire [31:0] MEM_WB_mem_data_in;
    wire [31:0] MEM_WB_alu_result_in;
    wire [4:0] MEM_WB_reg_dest_in;
    wire [31:0] MEM_WB_mem_data_out;
    wire [31:0] MEM_WB_alu_result_out;
    wire [4:0] MEM_WB_reg_dest_out;
    
    wire forward1_EX, forward1_MEM, forward2_EX, forward2_MEM;
    
    reg [31:0] count = 0;
    reg div_clk = 0;
    always @(posedge clk) begin
//        if(count >= 7500000) begin
        if(count >= 750000) begin
            div_clk = ~div_clk;
            count = 0;
        end
        else begin
            count = count + 1;
        end
    end
    
    inst_mem  inst_mem (
        .clka(~div_clk),
        .addra(pc),
        .douta(instruction)
    );
    
    assign data_addr = EX_MEM_alu_result_out;
    assign writedata = EX_MEM_read_data2_out;
    data_mem datamem (
        .clka(~div_clk),
        .wea(MEM_memwrite),
        .addra(data_addr),
        .dina(writedata),
        .douta(mem_data)
    );
    
    dup_mux mem_or_alu(
        .a(MEM_WB_alu_result_out), 
        .b(MEM_WB_mem_data_out), 
        .s(WB_memtoreg), 
        .out(write_data_in)
    );
    
     seg7 seg7(
       .clk(clk),
       .rst(~rst),
       .writedata(writedata),
       .dataadr(data_addr),
       .memwrite(MEM_memwrite),
       .seg(seg),
       .seg1(seg1),
       .an(an)
	);
    
    pc_reg pc_reg(
        .clk(div_clk), 
        .rst(~rst), 
        .en(~stall), 
        .pc_in(next_pc), 
        .pc_out(pc)
    );
    
    adder pcplus4(
        .a(pc), 
        .b(4), 
        .result(pc_plus4)
    );
    
    assign IF_ID_pc_plus4_in = pc_plus4;
    assign IF_ID_instruction_in = instruction;
    IF_ID IF_ID(
        .clk(div_clk), 
        .rst(~rst || jump || branch), //清零信号为真或者当前译码的指令是jump指令或者访存阶段发现需要分支，需要清空IF_ID阶段间寄存器
        .en(~stall), 
        .pc_plus4_in(IF_ID_pc_plus4_in), 
        .instruction_in(IF_ID_instruction_in), 
        .pc_plus4_out(IF_ID_pc_plus4_out), 
        .instruction_out(IF_ID_instruction_out)
    );

    assign ID_EX_pc_plus4_in = IF_ID_pc_plus4_out;
    assign ID_EX_read_data1_in = forward1_EX ? alu_result : forward1_MEM ? (MEM_memread ? mem_data : EX_MEM_alu_result_out) : readdata1;
    assign ID_EX_read_data2_in = forward2_EX ? alu_result : forward2_MEM ? (MEM_memread ? mem_data : EX_MEM_alu_result_out) : readdata2;
    assign ID_EX_imm_after_se_in = imm_after_se;
    assign ID_EX_imm_after_ue_in = imm_after_ue;
    assign ID_EX_rt_in = IF_ID_instruction_out[20:16];
    assign ID_EX_rd_in = IF_ID_instruction_out[15:11];
    assign ID_EX_sa_in = IF_ID_instruction_out[10:6];
    ID_EX ID_EX(
        .clk(div_clk), 
        .rst(~rst ||stall || branch),//在清零信号为真或者需要stall时，清空ID_EX阶段间寄存器 
        .pc_plus4_in(ID_EX_pc_plus4_in), 
        .read_data1_in(ID_EX_read_data1_in), 
        .read_data2_in(ID_EX_read_data2_in), 
        .imm_after_se_in(ID_EX_imm_after_se_in), 
        .imm_after_ue_in(ID_EX_imm_after_ue_in), 
        .rt_in(ID_EX_rt_in), 
        .rd_in(ID_EX_rd_in), 
        .sa_in(ID_EX_sa_in), 
        .pc_plus4_out(ID_EX_pc_plus4_out), 
        .read_data1_out(ID_EX_read_data1_out), 
        .read_data2_out(ID_EX_read_data2_out), 
        .imm_after_se_out(ID_EX_imm_after_se_out), 
        .imm_after_ue_out(ID_EX_imm_after_ue_out), 
        .rt_out(ID_EX_rt_out), 
        .rd_out(ID_EX_rd_out), 
        .sa_out(ID_EX_sa_out)
    );
    
    sl2_jump_addr sl2_jump_addr(
        .in(IF_ID_instruction_out[25:0]), 
        .out(j_addr_after_sl2)
    );
    
    assign j_addr = {IF_ID_pc_plus4_out[31:28], j_addr_after_sl2};
    
    controller controller(
        .clk(div_clk), 
        .rst(~rst), 
        .instruction(IF_ID_instruction_out), 
        .jump(jump), 
        .branch_e(branch_e), 
        .branch_ne(branch_ne), 
        .regdest(regdest), 
        .memread(memread), 
        .memwrite(memwrite), 
        .memtoreg(memtoreg), 
        .alusrc(alusrc), 
        .regwrite(regwrite), 
        .aluop(aluop), 
        .is_sign(is_sign), 
        .zero_extern(zero_extern), 
        .use_sa(use_sa), 
        .alu_sign_reset(alu_sign_reset)
    );

    delay_reg EX_controls(
        .clk(div_clk), 
        .rst(~rst || stall || branch), //当清零信号为真或者需要stall时，清空执行阶段（及其后续阶段）的控制信号；这里使用的stall方式为清零stall，也可以给delay_reg添加一个使能信号并用stall控制以实现保持状态stall
        .jump_in(jump), 
        .branch_e_in(branch_e), 
        .branch_ne_in(branch_ne), 
        .regdest_in(regdest), 
        .memread_in(memread), 
        .memwrite_in(memwrite), 
        .memtoreg_in(memtoreg), 
        .alusrc_in(alusrc), 
        .regwrite_in(regwrite), 
        .aluop_in(aluop), 
        .is_sign_in(is_sign), 
        .zero_extern_in(zero_extern), 
        .use_sa_in(use_sa), 
        .alu_sign_reset_in(alu_sign_reset), 
        .jump_out(EX_jump), 
        .branch_e_out(EX_branch_e), 
        .branch_ne_out(EX_branch_ne), 
        .regdest_out(EX_regdest), 
        .memread_out(EX_memread), 
        .memwrite_out(EX_memwrite), 
        .memtoreg_out(EX_memtoreg), 
        .alusrc_out(EX_alusrc), 
        .regwrite_out(EX_regwrite), 
        .aluop_out(EX_aluop), 
        .is_sign_out(EX_is_sign), 
        .zero_extern_out(EX_zero_extern), 
        .use_sa_out(EX_use_sa), 
        .alu_sign_reset_out(EX_alu_sign_reset)
    );

    delay_reg MEM_controls(
        .clk(div_clk), 
        .rst(~rst || branch), 
        .jump_in(EX_jump), 
        .branch_e_in(EX_branch_e), 
        .branch_ne_in(EX_branch_ne), 
        .regdest_in(EX_regdest), 
        .memread_in(EX_memread), 
        .memwrite_in(EX_memwrite), 
        .memtoreg_in(EX_memtoreg), 
        .alusrc_in(EX_alusrc), 
        .regwrite_in(EX_regwrite), 
        .aluop_in(EX_aluop), 
        .is_sign_in(EX_is_sign), 
        .zero_extern_in(EX_zero_extern), 
        .use_sa_in(EX_use_sa), 
        .alu_sign_reset_in(EX_alu_sign_reset), 
        .jump_out(MEM_jump), 
        .branch_e_out(MEM_branch_e), 
        .branch_ne_out(MEM_branch_ne), 
        .regdest_out(MEM_regdest), 
        .memread_out(MEM_memread), 
        .memwrite_out(MEM_memwrite), 
        .memtoreg_out(MEM_memtoreg), 
        .alusrc_out(MEM_alusrc), 
        .regwrite_out(MEM_regwrite), 
        .aluop_out(MEM_aluop), 
        .is_sign_out(MEM_is_sign), 
        .zero_extern_out(MEM_zero_extern), 
        .use_sa_out(MEM_use_sa), 
        .alu_sign_reset_out(MEM_alu_sign_reset)
    );
    
    delay_reg WB_controls(
        .clk(div_clk), 
        .rst(~rst || branch), 
        .jump_in(MEM_jump), 
        .branch_e_in(MEM_branch_e), 
        .branch_ne_in(MEM_branch_ne), 
        .regdest_in(MEM_regdest), 
        .memread_in(MEM_memread), 
        .memwrite_in(MEM_memwrite), 
        .memtoreg_in(MEM_memtoreg), 
        .alusrc_in(MEM_alusrc), 
        .regwrite_in(MEM_regwrite), 
        .aluop_in(MEM_aluop), 
        .is_sign_in(MEM_is_sign), 
        .zero_extern_in(MEM_zero_extern), 
        .use_sa_in(MEM_use_sa), 
        .alu_sign_reset_in(MEM_alu_sign_reset), 
        .jump_out(WB_jump), 
        .branch_e_out(WB_branch_e), 
        .branch_ne_out(WB_branch_ne), 
        .regdest_out(WB_regdest), 
        .memread_out(WB_memread), 
        .memwrite_out(WB_memwrite), 
        .memtoreg_out(WB_memtoreg), 
        .alusrc_out(WB_alusrc), 
        .regwrite_out(WB_regwrite), 
        .aluop_out(WB_aluop), 
        .is_sign_out(WB_is_sign), 
        .zero_extern_out(WB_zero_extern), 
        .use_sa_out(WB_use_sa), 
        .alu_sign_reset_out(WB_alu_sign_reset)
    );

    assign rt_addr = ID_EX_rt_out;
    assign rd_addr = ID_EX_rd_out;
    dup_mux write_regiter_addr(
        .a(rt_addr), 
        .b(rd_addr), 
        .s(EX_regdest), 
        .out(write_data_reg_addr)
    );
    
    assign readdata1_addr = IF_ID_instruction_out[25:21];
    assign readdata2_addr = regdest ? IF_ID_instruction_out[20:16] : 0;
    regfile regfile(
        .clk(div_clk), 
        .write_en(WB_regwrite), 
        .regaddr1(readdata1_addr), 
        .regaddr2(readdata2_addr), 
        .data_out1(readdata1), 
        .data_out2(readdata2),  
        .data_addr(MEM_WB_reg_dest_out), 
        .data_in(write_data_in)
    );
    
    hazard hazard(
        .reg_dest(regdest), 
        .EX_memread(EX_memread), 
        .read_reg1_addr(readdata1_addr), 
        .read_reg2_addr(readdata2_addr), 
        .EX_write_reg_addr(write_data_reg_addr), 
        .MEM_write_reg_addr(EX_MEM_reg_dest_out), 
        .stall(stall), 
        .forward1_EX(forward1_EX), 
        .forward2_EX(forward2_EX), 
        .forward1_MEM(forward1_MEM), 
        .forward2_MEM(forward2_MEM)
    );
    
    dup_mux se_or_ue_imm_to_alu(
        .a(ID_EX_imm_after_se_out), 
        .b(ID_EX_imm_after_ue_out), 
        .s(EX_zero_extern), 
        .out(imm_to_alu)
    );
    
    dup_mux alu_op2(
        .a(ID_EX_read_data2_out), 
        .b(imm_to_alu), 
        .s(EX_alusrc), 
        .out(aluop2)
    );
    assign sa = ID_EX_sa_out;
    assign aluop1 = EX_use_sa ? {27'b0, sa} : ID_EX_read_data1_out;
    
    alu alu(
        .a(aluop1), 
        .b(aluop2), 
        .op(EX_aluop), 
        .sign_rst(EX_alu_sign_reset), 
        .is_sign(EX_is_sign), 
        .result(alu_result), 
        .overflow(overflow), 
        .zero(zero)
    );
    assign equal = zero;

    assign EX_MEM_pc_branch_in = branch_addr;
    assign EX_MEM_alu_zero_in = zero;
    assign EX_MEM_alu_result_in = alu_result;
    assign EX_MEM_read_data2_in = ID_EX_read_data2_out;
    assign EX_MEM_reg_dest_in = write_data_reg_addr;
    EX_MEM EX_MEM(
        .clk(div_clk), 
        .rst(~rst || branch), 
        .pc_branch_in(EX_MEM_pc_branch_in), 
        .alu_zero_in(EX_MEM_alu_zero_in), 
        .alu_result_in(EX_MEM_alu_result_in), 
        .read_data2_in(EX_MEM_read_data2_in), 
        .reg_dest_in(EX_MEM_reg_dest_in), 
        .pc_branch_out(EX_MEM_pc_branch_out), 
        .alu_zero_out(EX_MEM_alu_zero_out), 
        .alu_result_out(EX_MEM_alu_result_out), 
        .read_data2_out(EX_MEM_read_data2_out), 
        .reg_dest_out(EX_MEM_reg_dest_out)
    );

    assign MEM_WB_mem_data_in = mem_data;
    assign MEM_WB_alu_result_in = EX_MEM_alu_result_out;
    assign MEM_WB_reg_dest_in = EX_MEM_reg_dest_out;
    MEM_WB MEM_WB(
        .clk(div_clk), 
        .rst(~rst), 
        .mem_data_in(MEM_WB_mem_data_in), 
        .alu_result_in(MEM_WB_alu_result_in), 
        .reg_dest_in(MEM_WB_reg_dest_in), 
        .mem_data_out(MEM_WB_mem_data_out), 
        .alu_result_out(MEM_WB_alu_result_out), 
        .reg_dest_out(MEM_WB_reg_dest_out)
    );
    
    se se(
        .in(IF_ID_instruction_out[15:0]), 
        .out(imm_after_se)
    );
    
    ue ue(
        .in(IF_ID_instruction_out[15:0]), 
        .out(imm_after_ue)
    );
    
    sl2_branch_addr sl2_branch_addr(
        .in(ID_EX_imm_after_se_out), 
        .out(imm_after_se_sl2)
    );
    
    assign branch_addr_after_se_sl2 = imm_after_se_sl2;
    adder branch_addr_adder(
        .a(ID_EX_pc_plus4_out), 
        .b(branch_addr_after_se_sl2), 
        .result(branch_addr)
    );
    
    assign branch = (MEM_branch_e && EX_MEM_alu_zero_out) || (MEM_branch_ne && ~EX_MEM_alu_zero_out);
    dup_mux branch_or_pcplus4(
        .a(pc_plus4), 
        .b(EX_MEM_pc_branch_out), 
        .s(branch), 
        .out(pc_pcplus4_branch)
    );
    
    dup_mux jump_or_other(
        .a(pc_pcplus4_branch), 
        .b(j_addr), 
        .s(jump), 
        .out(next_pc)
    );
endmodule
