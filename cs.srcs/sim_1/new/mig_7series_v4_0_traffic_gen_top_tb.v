`timescale 1ns/1ns
`include "./mig_7series_v4_0_traffic_gen_top.v"
module mig_7series_v4_0_traffic_gen_top_tb #

   (
   reg                           clk,
   wire                          app_en,
   reg                           app_rdy,
   reg    [DATA_WIDTH-1:0]       app_wdf_rdy,
   reg   [DATA_WIDTH-1:0]        app_rd_data,
   wire                          app_rd_data_valid,
   reg                           reset,
   reg    [2:0]                  app_cmd,
   wire   [31:0]                 app_addr,
   reg   [DATA_WIDTH/8-1:0]      app_wdf_mask,
   wire   [DATA_WIDTH-1:0]       app_wdf_data,
   reg                           app_wdf_wren,
   reg                           app_wdf_end,
   wire                          compare_error
    )
 
 
initial
 begin
 DATA_WIDTH=64;
 clk=0;
 app_addr=0;
app_wdf_data=0;
reset=1
#50 reset=0;
#10 app_cmd=3'b000;
 app_rdy=1;
app_wdf_mask=0;
app_wdf_rdy=1;
app_en=1;
app_wdf_wren=1£»
#300 app_en=0;
app_wdf_wren=1£»
always #10 clk=~clk;
#500 $stop;
end

always #10 clk=~clk;

endmodule
