# ALU-and-Datapath-Design
Bu ödevde Verilog kullanarak bir ALU (Aritmetik Mantık Birimi) ve Datapath tasarımı yapılmıştır. Ödevin dosyalarında istenen adımlar daha detaylı bulunabilir.

## Ödev Kapsamı

### 1. 32-bit ALU Tasarımı
- ALU aşağıdaki fonksiyonları destekleyecek şekilde tasarlanmıştır:
  - `000` → Toplama (`Add`)
  - `001` → Çıkarma (`Subtract`)
  - `010` → Mantıksal AND
  - `011` → Mantıksal XOR
  - `101` → Küçüktür karşılaştırması (`SLT`)

- ALU bileşenleri modüler şekilde tasarlanmıştır:
  - `ZeroExtender.v`
  - `Adder.v`
  - `Mux.v`
  - `ALU.v` (üst seviye birleşik ALU)

- `ALU_tb.v`: ALU'nun tüm fonksiyonlarını test eden testbench dosyası.

- `alu_output.vcd`: Test sonuçlarını içeren simülasyon çıktısı (GtkWave ile incelenebilir).

---

### 2. Datapath Tasarımı
- `RegisterFile.v`: 32-bit genişliğinde, 4 yazmaçtan oluşan yazmaç dosyası.
- `Datapath.v`: ALU ve yazmaç dosyasının birleştirilmesiyle oluşturulan sistem.

- `Datapath_tb_a.v`: Aşağıdaki komutları test eden testbench:
  - `R0 ← R1 + R2`
  - `R1 ← R2 AND R3`
  - `R3 ← R2 XOR R0`
  - `R2 ← R1 - R3`

- `Datapath_tb_b.v`: Belirli kontrol sinyalleriyle aşağıdaki işlemleri test eden testbench:
  - `R1 ← 0` (reset sinyali olmadan)
  - `R0 ← -1`
  - `R2 ← R1 - 1`
  - `R3 ← R0 + 1`

- `datapath_output_a.vcd`, `datapath_output_b.vcd`: İlgili testbench’lerin GtkWave çıktıları.

---


