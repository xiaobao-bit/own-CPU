`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 01:09:35 PM
// Design Name: 
// Module Name: id
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

`include "defines.v"

module id(

    input   wire                    rst         ,

    input   wire [`InstAddrBus]     pc_i        ,
    input   wire [`InstBus]         inst_i      ,

    // read from RF
    input   wire [`RegBus]          reg1_data_i ,
    input   wire [`RegBus]          reg2_data_i ,
    
    // output to RF
    output  reg                     reg1_read_o ,   // read enable
    output  reg                     reg2_read_o ,
    output  reg  [`RegAddrBus]      reg1_addr_o ,   // read data addr
    output  reg  [`RegAddrBus]      reg2_addr_o ,   // read data addr

    // output to EX
    output  reg  [`AluOpBus]        aluop_o     ,   
	output  reg  [`AluSelBus]       alusel_o    ,
	output  reg  [`RegBus]          reg1_o      ,   // operands 1 during EXE
	output  reg  [`RegBus]          reg2_o      ,   // operands 1 during EXE
	output  reg  [`RegAddrBus]      wd_o        ,
	output  reg                     wreg_o

    );

    // instruction has 32-bit
    // to know if the op is 'ori' -> check 31-26 bit
    wire [5: 0]                     op  = inst_i[31: 26];   // ORI check
    wire [4: 0]                     op2 = inst_i[10: 6] ;
    wire [5: 0]                     op3 = inst_i[5: 0]  ;   // {op2,op3} -> immediate
    wire [20: 16]                   op4 = inst_i[20: 16];   // result

    // save the extended 32-bit imm
    reg  [`RegBus]                  imm                 ;

    // bool -> inst is valid?
    reg                             instvalid           ;


    // ---------------------- Decode the Inst ---------------------- 
    always @(* ) begin
        if (rst == `RstEnable) begin
            aluop_o     <= `EXE_NOP_OP;
			alusel_o    <= `EXE_RES_NOP;
			wd_o        <= `NOPRegAddr;
			wreg_o      <= `WriteDisable;
			instvalid   <= `InstValid;
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= `NOPRegAddr;
			reg2_addr_o <= `NOPRegAddr;
			imm         <= 32'h0;	
        end else begin
            aluop_o     <= `EXE_NOP_OP;
			alusel_o    <= `EXE_RES_NOP;
			wd_o        <= inst_i[15:11];
			wreg_o      <= `WriteDisable;
			instvalid   <= `InstInvalid;	   
			reg1_read_o <= 1'b0;
			reg2_read_o <= 1'b0;
			reg1_addr_o <= inst_i[25:21];
			reg2_addr_o <= inst_i[20:16];		
			imm         <= `ZeroWord;

            case (op)
                `EXE_ORI:   begin
                    reg1_read_o     <= 1'b1;                    // 1 operands of 'ori' is read from RF
                    reg2_read_o     <= 1'b0;                    // the other one is imm, no need to read from RF
                    wreg_o          <= `WriteEnable;            // write the result back to RF
                    aluop_o         <= `EXE_OR_OP;      
                    alusel_o        <= `EXE_RES_LOGIC;
                    imm             <= {16'h0, inst_i[15: 0]};  // get and extended the imm
                    wd_o            <= inst_i[20: 16];          // reg that to be written back
                    instvalid       <= `InstInvalid;            // if the inst is valid (valid here)
                end 
                default:    begin
                end
            endcase
        end
    end


    // ---------------------- Get Operand 1 ---------------------- 
    always @ (*) begin
		if(rst == `RstEnable) begin
			reg1_o <= `ZeroWord;
	    end else if(reg1_read_o == 1'b1) begin  // if enable -> read from reg
	  	    reg1_o <= reg1_data_i;
	    end else if(reg1_read_o == 1'b0) begin  // if not    -> an imm.
	  	    reg1_o <= imm;
	    end else begin
	        reg1_o <= `ZeroWord;
	  end
	end
	

    // ---------------------- Get Operand 2 ----------------------
	always @ (*) begin
		if(rst == `RstEnable) begin
			reg2_o <= `ZeroWord;
	    end else if(reg2_read_o == 1'b1) begin
	  	    reg2_o <= reg2_data_i;
	    end else if(reg2_read_o == 1'b0) begin
	  	    reg2_o <= imm;
	    end else begin
	        reg2_o <= `ZeroWord;
	    end
	end

endmodule
