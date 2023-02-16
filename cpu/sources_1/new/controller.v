`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/01/15 21:02:40
// Design Name: 
// Module Name: controller
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


module controller(
    input wire clk, 
    input wire rst, 
    input wire [31:0] instruction, 
    output reg jump = 0, 
    output reg branch_e = 0,
    output reg branch_ne = 0,  
    output reg regdest = 0, 
    output reg memread = 0, 
    output reg memwrite = 0, 
    output reg memtoreg = 0, 
    output reg alusrc = 0, 
    output reg regwrite = 0, 
    output reg [3:0] aluop = 4'b0000, 
    output reg is_sign = 1, 
    output reg zero_extern = 0, 
    output reg use_sa = 0, 
    output reg alu_sign_reset = 1
    );
    
    always @(*) begin
        //*************************************************************************************
        //����
        if(rst) begin
            jump = 0;// ����ת
            branch_e = 0;// ����beq
            branch_ne = 0;// ����bne
            regdest = 0;// ����Ҫд��Ŀ��Ĵ��� ���� Ҫ��Ҫ��rt�Ĵ����� ������Ҫд�ļĴ�����rt���߲���rt�Ĵ���
            memread = 0;// �����ڴ�
            memtoreg = 0;// �������ڴ浽�Ĵ���
            memwrite = 0;// ��д�ڴ�
            alusrc = 0;// alu�ڶ�����������ԴΪ�Ĵ���
            regwrite = 0;// ��д�Ĵ���
            aluop = 4'b0000;// ��
            is_sign = 1;// �з���
            zero_extern = 0;// ����0��չ������
            use_sa = 0;// ��ʹ��shift amount
            alu_sign_reset = 1;// ����ʱ��alu�ı�־λ����
        end
        //*************************************************************************************
        // R ��ָ��
        else if(instruction[31:26] == 6'b0) begin
            regdest = 1;// Ŀ��Ĵ�����rd
            alusrc = 0;// �ڶ�����������Դ�ǼĴ���
            regwrite = 1;// Ҫд�Ĵ���
            memread = 0;// �����ڴ�
            memwrite = 0;// ��д�ڴ�
            branch_e = 0;// ����beqָ��
            branch_ne = 0;// ����bneָ��
            jump = 0;// ������������תָ��
            is_sign = 1;// �з���������
            zero_extern = 0;// ����0��չ������
            use_sa = 0;// ��ʹ��shift amount
            alu_sign_reset = 1;// ���alu�ı�־λ
            if(instruction[5:0] == 0) begin//sll
                use_sa = 1;// ʹ��shift amount
                aluop = 4'b0111;// Ҫ����sll
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 2) begin//srl
                use_sa = 1;// ʹ��shift amount
                aluop = 4'b1000;// Ҫ����srl
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 3) begin//sra
                use_sa = 1;// ʹ��shift amount
                aluop = 4'b1001;// Ҫ����sra
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 4) begin//sllv
                aluop = 4'b0111;// Ҫ����sllv
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 6) begin//srlv
                aluop = 4'b1000;// Ҫ����srlv
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 7) begin//srav
                aluop = 4'b1001;// Ҫ����srav
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 8) begin//jr
                
            end
            else if(instruction[5:0] == 9) begin//jalr
                
            end
            else if(instruction[5:0] == 10) begin//movz
                
            end
            else if(instruction[5:0] == 11) begin//movn
                
            end
            else if(instruction[5:0] == 12) begin//syscall
                
            end
            else if(instruction[5:0] == 13) begin//break
                
            end
            else if(instruction[5:0] == 15) begin//sync
                
            end
            else if(instruction[5:0] == 16) begin//mfhi
                
            end
            else if(instruction[5:0] == 17) begin//mthi
                
            end
            else if(instruction[5:0] == 18) begin//mflo
                
            end
            else if(instruction[5:0] == 19) begin//mtlo
                
            end
            else if(instruction[5:0] == 24) begin//mult
                
            end
            else if(instruction[5:0] == 25) begin//multu
                
            end
            else if(instruction[5:0] == 26) begin//div
                
            end
            else if(instruction[5:0] == 27) begin//divu
                
            end
            else if(instruction[5:0] == 32) begin//add
                aluop = 4'b0000;// Ҫ���м�
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 33) begin//addu
                aluop = 4'b0000;// Ҫ���м�
                is_sign = 0;// �޷�����
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 34) begin//sub
                aluop = 4'b0001;// Ҫ���м�
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 35) begin//subu
                aluop = 4'b0001;// Ҫ���м�
                is_sign = 0;// �޷�����
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 36) begin//and
                aluop = 4'b0010;// Ҫ������
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 37) begin//or
                aluop = 4'b0011;// Ҫ���л�
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 38) begin//xor
                aluop = 4'b0100;// Ҫ�������
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 39) begin//nor
                aluop = 4'b0101;// Ҫ���л��
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 42) begin//slt
                aluop = 4'b0110;// Ҫ����slt����
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[5:0] == 43) begin//sltu
                aluop = 4'b0110;// Ҫ����sltu
                alu_sign_reset = 0;// �����alu�ı�־λ
                is_sign = 0;// �޷�����
            end
            else if(instruction[5:0] == 48) begin//tge
                
            end
            else if(instruction[5:0] == 49) begin//tgeu
                
            end
            else if(instruction[5:0] == 50) begin//tlt
                
            end
            else if(instruction[5:0] == 51) begin//tltu
                
            end
            else if(instruction[5:0] == 52) begin//teq
                
            end
            else if(instruction[5:0] == 54) begin//tne
                
            end
            else begin//����
                
            end
        end
        //*************************************************************************************
        // J ��ָ��
        else if(instruction[31:26] >= 2 && instruction[31:26] <= 3) begin
            jump = 1;// ����������תָ��
            alu_sign_reset = 1;// ���alu�ı�־λ
            zero_extern = 0;// ����0��չ������
            use_sa = 0;// ��ʹ��shift amount
            if(instruction[31:26] == 2) begin//j
                branch_e = 0;// ����beq
                branch_ne = 0;// ����bne
                regdest = 0;// ����Ҫд��Ŀ��Ĵ��� ���� Ҫ��Ҫ��rt�Ĵ����� ������Ҫд�ļĴ�����rt���߲���rt�Ĵ���
                memread = 0;// �����ڴ�
                memwrite = 0;// ��д�ڴ�
                memtoreg = 0;// �������ڴ浽�Ĵ���
                alusrc = 0;// alu�ڶ�����������ԴΪ�Ĵ���
                regwrite = 0;// ��д�Ĵ���
                aluop = 4'b0000;// ��
                is_sign = 1;// �з���
            end
            else begin//jal
                
            end
        end
        //*************************************************************************************
        // I ��ָ��
        else begin
            regdest = 0;// Ŀ��Ĵ�����rt
            alusrc = 1;// �ڶ�����������Դ��������
            regwrite = 1;// Ҫд�Ĵ���
            memread = 0;// �����ڴ�
            memtoreg = 0;// �������ڴ浽�Ĵ���
            memwrite = 0;// ��д�ڴ�
            branch_e = 0;// ����beqָ��
            branch_ne = 0;// ����bneָ��
            jump = 0;// ������������תָ��
            is_sign = 1;// �з���������
            zero_extern = 0;// ����0��չ������
            use_sa = 0;// ��ʹ��shift amount
            alu_sign_reset = 1;// ���alu�ı�־λ
            if(instruction[31:26] == 4) begin//beq
                branch_e = 1;// beqָ��
                regdest = 1;// ֻ��regdestΪ1������£�rt�Ĵ�����������������ģ��������ȫ0
                alusrc = 0;// �ڶ������������ԼĴ���
                aluop = 4'b0001;// Ҫ���м�
                regwrite = 0;// ��д�Ĵ���
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[31:26] == 5) begin//bne
                branch_ne = 1;// bneָ��
                regdest = 1;// ֻ��regdestΪ1������£�rt�Ĵ�����������������ģ��������ȫ0
                alusrc = 0;// �ڶ������������ԼĴ���
                aluop = 4'b0001;// Ҫ���м�
                regwrite = 0;// ��д�Ĵ���
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[31:26] == 6) begin//blez
                
            end
            else if(instruction[31:26] == 7) begin//bgtz
                
            end
            else if(instruction[31:26] == 8) begin//addi
                aluop = 4'b0000;// Ҫ���м�
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[31:26] == 9) begin//addiu
                aluop = 4'b0000;// Ҫ���м�
                is_sign = 0;// �޷�����
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[31:26] == 10) begin//slti
                aluop = 4'b0110;// Ҫ����slti
                alu_sign_reset = 0;// �����alu�ı�־λ
            end
            else if(instruction[31:26] == 11) begin//sltiu
                aluop = 4'b0110;// Ҫ����sltiu
                alu_sign_reset = 0;// �����alu�ı�־λ
                is_sign = 0;// �޷�����
            end
            else if(instruction[31:26] == 12) begin//andi
                aluop = 4'b0010;// Ҫ������
                alu_sign_reset = 0;// �����alu�ı�־λ
                zero_extern = 1;// ��������0��չ
            end
            else if(instruction[31:26] == 13) begin//ori
                aluop = 4'b0011;// Ҫ������������
                alu_sign_reset = 0;// �����alu�ı�־λ
                zero_extern = 1;// ��������0��չ
            end
            else if(instruction[31:26] == 14) begin//xori
                aluop = 4'b0100;// Ҫ�������������
                alu_sign_reset = 0;// �����alu�ı�־λ
                zero_extern = 1;// ��������0��չ
            end
            else if(instruction[31:26] == 15) begin//lui
                
            end
            else if(instruction[31:26] == 32) begin//lb
                
            end
            else if(instruction[31:26] == 33) begin//lh
                
            end
            else if(instruction[31:26] == 34) begin//lwl
                
            end
            else if(instruction[31:26] == 35) begin//lw
                memread = 1;// Ҫ���ڴ�
                memtoreg = 1;// Ҫд�Ĵ���
                aluop = 4'b0000;// Ҫ���м�
            end
            else if(instruction[31:26] == 36) begin//lbu
                
            end
            else if(instruction[31:26] == 37) begin//lhu
                
            end
            else if(instruction[31:26] == 38) begin//lwr
                
            end
            else if(instruction[31:26] == 40) begin//sb
                
            end
            else if(instruction[31:26] == 41) begin//sh
                
            end
            else if(instruction[31:26] == 42) begin//swl
                
            end
            else if(instruction[31:26] == 43) begin//sw
                memwrite = 1;// swҪд�ڴ�
                aluop = 4'b0000;// swҪ���м�
                regwrite = 0;// sw��д�Ĵ���
                regdest = 1;//regdest����Ҫд�ĸ��Ĵ�����Ҳ�����Ƿ�Ҫ��rt�Ĵ������������Ҫ��rt�Ĵ���
            end
            else if(instruction[31:26] == 46) begin//swr
                
            end
            else if(instruction[31:26] == 47) begin//cache
                
            end
            else if(instruction[31:26] == 48) begin//ll
                
            end
            else if(instruction[31:26] == 49) begin//lwc1
                
            end
            else if(instruction[31:26] == 50) begin//lwc2
                
            end
            else if(instruction[31:26] == 51) begin//pref
                
            end
            else if(instruction[31:26] == 53) begin//ldc1
                
            end
            else if(instruction[31:26] == 54) begin//ldc2
                
            end
            else if(instruction[31:26] == 56) begin//sc
                
            end
            else if(instruction[31:26] == 57) begin//swc1
                
            end
            else if(instruction[31:26] == 58) begin//swc2
                
            end
            else if(instruction[31:26] == 61) begin//sdc1
                
            end
            else if(instruction[31:26] == 62) begin//sdc2
                
            end
            else begin//����
                
            end
        end
    end
endmodule
