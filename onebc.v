// implement per 1-bit_computer.txt

module onebc (
  input arst_i, // asynchronous reset
  input clk_i,
  input [7:0] ins_i,
  output [7:0] outs_o
);
// direct register outputs
reg [7:0] outs_o;

// instruction fields
wire [31:0] instruction; // bits [31:23] are ignored
wire dato = instruction[22];
wire [2:0] osel = instruction[21:19];
wire [2:0] isel = instruction[18:16];
wire [7:0] tadr = instruction[15:8];
wire [7:0] fadr = instruction[7:0];

// next address logic
wire dati = ins_i[isel];
wire [7:0] adr = {8{~arst_i}} & (dati ? tadr : fadr);

// output registers
always @(arst_i, negedge clk_i) begin
  if (arst_i) outs_o <= 8'b0;
  else outs_o[osel] <= dato;
end

// object code
ROM u1 (
  .clk_i(clk_i),
  .adr_i(adr),
  .dat_o(instruction)
);

endmodule
