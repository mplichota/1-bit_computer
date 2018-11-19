// verify onebc running vtb.1-bit program

`timescale 1 ns / 1 ns

module onebc_tb;

// inputs
reg arst_i;
reg clk_i;
reg [7:0] ins_i;

// outputs
wire [7:0] outs_o;

onebc uut (
  .arst_i(arst_i),
  .clk_i(clk_i),
  .ins_i(ins_i),
  .outs_o(outs_o)
);

parameter PERIOD = 8;

always begin
  clk_i = 0;
  #(PERIOD / 2);
  clk_i = 1;
  #(PERIOD / 2);
end

initial begin
  $timeformat(-9, 0, " cp/8", 8);

// asynchronous reset
  arst_i = 0;
  #(PERIOD / 8);
  arst_i = 1;
  #(7 * PERIOD / 8);
  #(PERIOD * 1);

// all inputs 0, expect all outputs 0
  arst_i = 0;
  ins_i = 8'h00;
  #(PERIOD * 2);

// pulse input 0, expect set output 0
  ins_i = 8'h01;
  #(PERIOD * 2);

// pulse input 1, expect set output 1
  ins_i = 8'h02;
  #(PERIOD * 2);

// pulse input 2, expect set output 2
  ins_i = 8'h04;
  #(PERIOD * 2);

// pulse input 3, expect set output 3
  ins_i = 8'h08;
  #(PERIOD * 2);

// pulse input 4, expect set output 4
  ins_i = 8'h10;
  #(PERIOD * 2);

// pulse input 5, expect set output 5
  ins_i = 8'h20;
  #(PERIOD * 2);

// pulse input 6, expect set output 6
  ins_i = 8'h40;
  #(PERIOD * 2);

// pulse input 7, expect set output 7
  ins_i = 8'h80;
  #(PERIOD * 2);

// all inputs 0, expect all outputs stable
  ins_i = 8'h00;
  #(PERIOD * 2);

  $display("end time is %d cp/8", $stime);
  $finish;

end

// Icarus Verilog text output
initial
  $monitor("t %t, arst_i:%b ins_i:%b outs_o:%b",
           $time,
           arst_i,
           ins_i,
           outs_o
  );

endmodule
