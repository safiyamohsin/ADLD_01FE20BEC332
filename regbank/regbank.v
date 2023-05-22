// Code your design here
// 32 x 32 register file with reset facility
module regbank_v4 (rdData1, rdData2, wrData, sr1, sr2, dr, write, reset, clk);
input clk, write, reset;
input [4:0] sr1, sr2, dr; // Source and destination registers
input [31:0] wrData;
output [31:0] rdData1, rdData2;
integer k;
reg [31:0] regfile[0:31];
assign rdData1 = regfile [sr1];
assign rdData2 = regfile [sr2];
  
  always @(posedge clk)
begin
if (reset) begin
for (k=0; k<32; k=k+1) begin
regfile[k] <= 0;
end
end
else begin
if (write)
regfile[dr] <= wrData;
end
end
endmodule
