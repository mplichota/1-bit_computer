// verify ROM

`timescale 1ns / 1ns

module ROM_tb;

// inputs
reg clk_i;
reg [7:0] adr_i;

// outputs
wire [31:0] dat_o;

ROM uut (
  .clk_i(clk_i),
  .adr_i(adr_i),
  .dat_o(dat_o)
);

parameter PERIOD = 2;

always begin
  clk_i = 0;
  #(PERIOD / 2);
  clk_i = 1;
  #(PERIOD / 2);
end

initial begin
  $timeformat(-9, 0, " cp/2", 8);

  adr_i = 0;
  #PERIOD;
  adr_i = 1;
  #PERIOD;
  adr_i = 2;
  #PERIOD;
  adr_i = 3;
  #PERIOD;
  adr_i = 4;
  #PERIOD;
  adr_i = 5;
  #PERIOD;
  adr_i = 6;
  #PERIOD;
  adr_i = 7;
  #PERIOD;
  adr_i = 8;
  #PERIOD;
  adr_i = 9;
  #PERIOD;
  adr_i = 10;
  #PERIOD;
  adr_i = 11;
  #PERIOD;
  adr_i = 12;
  #PERIOD;
  adr_i = 13;
  #PERIOD;
  adr_i = 14;
  #PERIOD;
  adr_i = 15;
  #PERIOD;

  $display("end time is %d cp/2", $stime);
  $finish;

end

// Icarus Verilog text output
initial
  $monitor("t %t, adr_i = %h, dat_o = %h",
           $time,
           adr_i,
           dat_o
  );

endmodule
