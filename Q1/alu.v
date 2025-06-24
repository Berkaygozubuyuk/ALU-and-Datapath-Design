// Verilog modules for 32-bit ALU and Datapath (BLM2022 Ödev 1)
`define WORD_SIZE 32

// ZeroExtender: Extends a 1-bit input to 32 bits (for SLT result)
module ZeroExtender(
    input  wire       in,    // 1-bit input (Less indicator)
    output wire [31:0] out    // zero-extended 32-bit output
);
    assign out = {31'b0, in};
endmodule

// Adder: 32-bit addition
module Adder(
    input  wire [31:0] A,
    input  wire [31:0] B,
    output wire [31:0] Result
);
    assign Result = A + B;
endmodule

// Subtractor: 32-bit subtraction
module Subtractor(
    input  wire [31:0] A,
    input  wire [31:0] B,
    output wire [31:0] Result
);
    assign Result = A - B;
endmodule

// And32: bitwise AND
module And32(
    input  wire [31:0] A,
    input  wire [31:0] B,
    output wire [31:0] Result
);
    assign Result = A & B;
endmodule

// Xor32: bitwise XOR
module Xor32(
    input  wire [31:0] A,
    input  wire [31:0] B,
    output wire [31:0] Result
);
    assign Result = A ^ B;
endmodule

// SLT: set-on-less-than
module SLT(
    input  wire [31:0] A,
    input  wire [31:0] B,
    output wire [31:0] Result
);
    wire less_bit;
    assign less_bit = (A < B) ? 1'b1 : 1'b0;
    ZeroExtender ze(.in(less_bit), .out(Result));
endmodule

// Top-level ALU
module ALU(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire [2:0]  ALUControl,
    output reg  [31:0] Result,
    output wire        Zero
);
    wire [31:0] addRes, subRes, andRes, xorRes, sltRes;
    Adder       add(.A(A), .B(B),           .Result(addRes));
    Subtractor  sub(.A(A), .B(B),           .Result(subRes));
    And32       _and(.A(A), .B(B),          .Result(andRes));
    Xor32       _xor(.A(A), .B(B),          .Result(xorRes));
    SLT         slt(.A(A), .B(B),           .Result(sltRes));

    always @(*) begin
        case (ALUControl)
            3'b000: Result = addRes;
            3'b001: Result = subRes;
            3'b010: Result = andRes;
            3'b011: Result = xorRes;
            3'b101: Result = sltRes;
            default: Result = 32'b0;
        endcase
    end

    assign Zero = (Result == 32'b0);
endmodule

// Datapath: connects ALU and Register File
module Datapath(
    input  wire           clk,
    input  wire           rst,
    input  wire           wr,
    input  wire [2:0]     ALUControl,
    input  wire [1:0]     addr1,
    input  wire [1:0]     addr2,
    input  wire [1:0]     addr3,
    output wire           Zero
);
    wire [31:0] data1;
    wire [31:0] data2;
    wire [31:0] alu_result;

    // Register File instance
    regfile rf (
        .addr1(addr1),
        .addr2(addr2),
        .addr3(addr3),
        .data1(data1),
        .data2(data2),
        .data3(alu_result),
        .clk(clk),
        .wr(wr),
        .rst(rst)
    );

    // ALU instance
    ALU alu_unit (
        .A(data1),
        .B(data2),
        .ALUControl(ALUControl),
        .Result(alu_result),
        .Zero(Zero)
    );
endmodule