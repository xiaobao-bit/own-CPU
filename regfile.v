`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 11:52:19 AM
// Design Name: 
// Module Name: regfile
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

module regfile(

    input   wire                    clk     ,
    input   wire                    rst     ,

    // write port
    input   wire                    we      ,
    input   wire [`RegAddrBus]      waddr   ,
    input   wire [`RegBus]          wdata   ,

    // read port 1
    input   wire                    re1     ,
    input   wire [`RegAddrBus]      raddr1  ,
    output  reg  [`RegBus]          rdata1  ,

    // read port 2
    input   wire                    re2     ,
    input   wire [`RegAddrBus]      raddr2  ,
    output  reg  [`RegBus]          rdata2

    );

    // Define a 32 * 32-bit ROM
    reg  [`RegBus]                  regs [0: `RegNum - 1];

    // write ops
    always @(posedge clk ) begin
        if (rst == `ReadDisable) begin
            if ((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) begin
                regs[waddr] <= wdata;
            end
        end
    end

    // read ops port 1
    always @(posedge clk ) begin
        if (rst == `RstEnable) begin
            rdata1 <= `ZeroWord;
        end else if (raddr1 == `RegNumLog2'h0) begin
            rdata1 <= `ZeroWord;
        end else if ((raddr1 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin
            rdata1 <= wdata;
        end else if (re1 == `ReadEnable) begin
            rdata1 <= regs[raddr1];
        end else begin
            rdata1 <= `ZeroWord;
        end
    end

    // read ops port 2
    always @(posedge clk ) begin
        if (rst == `RstEnable) begin
            rdata2 <= `ZeroWord;
        end else if (raddr2 == `RegNumLog2'h0) begin
            rdata2 <= `ZeroWord;
        end else if ((raddr2 == waddr) && (we == `WriteEnable) && (re1 == `ReadEnable)) begin
            rdata2 <= wdata;
        end else if (re1 == `ReadEnable) begin
            rdata2 <= regs[raddr2];
        end else begin
            rdata2 <= `ZeroWord;
        end
    end


endmodule
