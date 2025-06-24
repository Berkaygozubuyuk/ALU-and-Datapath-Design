// Testbench for Datapath: verifies
// 1) R0 <- R1 + R2
// 2) R1 <- R2 AND R3
// 3) R3 <- R2 XOR R0
// 4) R2 <- R1 - R3

`timescale 1ns/1ps
module tb;
    reg        clk;
    reg        rst;
    reg        wr;
    reg  [2:0] ALUControl;
    reg  [1:0] addr1, addr2, addr3;
    wire       Zero;

    // Instantiate the datapath
    Datapath D (
        .clk(clk),
        .rst(rst),
        .wr(wr),
        .ALUControl(ALUControl),
        .addr1(addr1),
        .addr2(addr2),
        .addr3(addr3),
        .Zero(Zero)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Enable waveform dump
        $dumpfile("datapath_tb.vcd");
        $dumpvars(0, tb);

        // Initialize signals
        rst = 0;
        wr  = 0;

        // 1) R0 <- R1 + R2
        #10;
        addr1      = 2'd1; // R1
        addr2      = 2'd2; // R2
        addr3      = 2'd0; // R0
        ALUControl = 3'b000; // ADD
        wr         = 1;
        #10; wr = 0;
        #2;
        $display("After ADD: R0 = %h", D.rf.register[0]);

        // 2) R1 <- R2 AND R3
        #10;
        addr1      = 2'd2; // R2
        addr2      = 2'd3; // R3
        addr3      = 2'd1; // R1
        ALUControl = 3'b010; // AND
        wr         = 1;
        #10; wr = 0;
        #2;
        $display("After AND: R1 = %h", D.rf.register[1]);

        // 3) R3 <- R2 XOR R0
        #10;
        addr1      = 2'd2; // R2
        addr2      = 2'd0; // R0
        addr3      = 2'd3; // R3
        ALUControl = 3'b011; // XOR
        wr         = 1;
        #10; wr = 0;
        #2;
        $display("After XOR: R3 = %h", D.rf.register[3]);

        // 4) R2 <- R1 - R3
        #10;
        addr1      = 2'd1; // R1
        addr2      = 2'd3; // R3
        addr3      = 2'd2; // R2
        ALUControl = 3'b001; // SUB
        wr         = 1;
        #10; wr = 0;
        #2;
        $display("After SUB: R2 = %h", D.rf.register[2]);

        $finish;
    end
endmodule
