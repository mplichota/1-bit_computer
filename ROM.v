// synchronous ROM, 256 cells of 32 bits

module ROM (
  input clk_i,
  input [7:0] adr_i,
  output [31:0] dat_o
);

reg [7:0] adr;
always @(posedge clk_i) begin
  adr <= adr_i;
end

reg [31:0] ROM_data [0:255];
initial begin
  $readmemh("ROM.hex", ROM_data);
end

assign dat_o = ROM_data[adr];

endmodule
