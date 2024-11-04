`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2024 11:28:28 AM
// Design Name: 
// Module Name: pc_reg
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

module pc_reg(

    input   wire                    clk ,
    input   wire                    rst ,

    output  reg  [`InstAddrBus]     pc  ,     // 32-bit -> addr of the inst to be read
    output  reg                     ce        // 1-bit  -> enable sig of IR

    );

    always @(posedge clk ) begin
        if (rst == `ReadEnable) begin
            ce <= `ChipDisable;
        end else begin
            ce <= `ChipEnable;
        end
    end

    always @(posedge clk ) begin
        if (ce == `ChipDisable) begin
            pc <= `ZeroWord;
        end else begin
            pc <= pc + 4'h4;
        end
    end

endmodule
