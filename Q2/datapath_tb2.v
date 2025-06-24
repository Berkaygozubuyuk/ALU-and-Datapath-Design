`timescale 1ns/1ps
module tb2;
    // Signals
    reg        clk;
    reg        rst;
    reg        wr;
    reg  [2:0] ALUControl;
    reg  [1:0] addr1, addr2, addr3;
    wire       Zero;

    // Instantiate datapath
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

    // Clock: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Waveform dump
        $dumpfile("datapath_tb2.vcd");
        $dumpvars(0, tb2);

        // No reset usage for first operation
        rst = 0;
        wr  = 0;

        // 1) R1 <- 0 via R1 - R1
        #10;
        addr1      = 2'd1; // R1
        addr2      = 2'd1; // R1
        addr3      = 2'd1; // write back R1
        ALUControl = 3'b001; // SUB
        wr         = 1;
        #10; wr = 0;
        #2;
        $display("After 1) R1 = %h", D.rf.register[1]);

        // 2) R0 <- -1 via R2 + R1 (R2 init = -1, R1 = 0)
        #10;
        addr1      = 2'd2; // R2
        addr2      = 2'd1; // R1
        addr3      = 2'd0; // write back R0
        ALUControl = 3'b000; // ADD
        wr         = 1;
        #10; wr = 0;
        #2;
        $display("After 2) R0 = %h", D.rf.register[0]);

        // 3) R2 <- R1 - R3 (0 - 1 = -1)
        #10;
        addr1      = 2'd1; // R1
        addr2      = 2'd3; // R3 (init = 1)
        addr3      = 2'd2; // write back R2
        ALUControl = 3'b001; // SUB
        wr         = 1;
        #10; wr = 0;
        #2;
        $display("After 3) R2 = %h", D.rf.register[2]);

        // 4) R3 <- R0 + R3 (-1 + 1 = 0)
        #10;
        addr1      = 2'd0; // R0
        addr2      = 2'd3; // R3
        addr3      = 2'd3; // write back R3
        ALUControl = 3'b000; // ADD
        wr         = 1;
        #10; wr = 0;
        #2;
        $display("After 4) R3 = %h", D.rf.register[3]);

        $finish;
    end
endmodule
