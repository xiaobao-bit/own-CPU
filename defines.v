// ---------------------- Global Marcos ---------------------- 
`define RstEnable               1'b1          
`define RstDisable              1'b0
`define ZeroWord                32'h00000000
`define WriteEnable             1'b1
`define WriteDisable            1'b0
`define ReadEnable              1'b1
`define ReadDisable             1'b0
`define AluOpBus                7:0             // width of output during decode phase (width of aluop_o)
`define AluSelBus               2:0             // width of output during decode phase (width of alusel_o)
`define InstValid               1'b0            // instruction valid
`define InstInvalid             1'b1            // instruction invalid
`define Stop                    1'b1
`define NoStop                  1'b0
`define InDelaySlot             1'b1
`define NotInDelaySlot          1'b0
`define Branch                  1'b1
`define NotBranch               1'b0
`define InterruptAssert         1'b1
`define InterruptNotAssert      1'b0
`define TrapAssert              1'b1
`define TrapNotAssert           1'b0
`define True_v                  1'b1            // logic true
`define False_v                 1'b0            // logic false
`define ChipEnable              1'b1
`define ChipDisable             1'b0


// ---------------------- Instruction Marcos ---------------------- 
`define EXE_ORI                 6'b001101       // instruction code of 'ori' instruction

`define EXE_NOP                 6'b000000


//AluOp
`define EXE_OR_OP               8'b00100101
`define EXE_ORI_OP              8'b01011010


`define EXE_NOP_OP              8'b00000000

//AluSel
`define EXE_RES_LOGIC           3'b001

`define EXE_RES_NOP             3'b000


// ---------------------- ROM Marcos ---------------------- 
`define InstAddrBus             31:0            // width of ROM addr bus
`define InstBus                 31:0            // width of ROM data bus
`define InstMemNum              131071          // actual size of ROM is 128 KB
`define InstMemNumLog2          17              // actual used width of ROM addr bus


// ---------------------- Reg File Marcos ---------------------- 
`define RegAddrBus              4:0             // width of RF addr bus
`define RegBus                  31:0            // width of RF data bus
`define RegWidth                32
`define DoubleRegWidth          64
`define DoubleRegBus            63:0
`define RegNum                  32
`define RegNumLog2              5
`define NOPRegAddr              5'b00000