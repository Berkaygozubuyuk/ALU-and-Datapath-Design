`timescale 1ns/1ps
`define WORD_SIZE 32
// 32-bit 4-kayıtlı Yazmaç Dosyası (Register File) Modülü
module regfile(addr1, addr2, addr3, data1, data2, data3, clk, wr, rst);
    input clk, wr, rst;
    input [1:0] addr1, addr2, addr3;
    input [`WORD_SIZE-1:0] data3;
    output [`WORD_SIZE-1:0] data1, data2;
    
    // 4 adet 32-bit yazmaç tanımı
    reg [`WORD_SIZE-1:0] register[3:0];
    
    // Başlangıç değerleri (yalnızca simülasyon için)
    initial register[0] = 32'h12345678;
    initial register[1] = 32'h9ABCDEF0;
    initial register[2] = 32'hFFFFFFFF;
    initial register[3] = 32'h00000001;
    
    // Asenkron okuma portları
    assign data1 = register[addr1];
    assign data2 = register[addr2];
    
    // Senkron yazma (pozitif clock kenarında)
    always @(posedge clk) begin
        if(rst) begin
            register[0] <= 32'b0;
            register[1] <= 32'b0;
            register[2] <= 32'b0;
            register[3] <= 32'b0;
        end
        if(wr) begin
            register[addr3] <= data3;
        end
    end
endmodule
