`timescale 1ns/1ns

module mig_7series_v4_0_traffic_gen_top #
(
  parameter   DATA_WIDTH=64
)
(
   input                           clk, 
   output                          app_en, 
   input                           app_rdy, 
   input    [DATA_WIDTH-1:0]        app_wdf_rdy,
   output    [DATA_WIDTH-1:0]        app_rd_data, 
   output                          app_rd_data_valid,
   input                           reset,
   output    [2:0]                   app_cmd,
   output   [31:0]                  app_addr,
   input   [DATA_WIDTH/8-1:0]      app_wdf_mask,
   output   [DATA_WIDTH-1:0]       app_wdf_data,
   input                           app_wdf_wren,
   input                           app_wdf_end,
   output                          compare_error
);


reg                              app_addr;
reg                              app_wdf_data;
wire                              compare_error;
reg                              app_rd_data_valid;
reg          [31:0]               mem [15:0];
reg                               app_rd_data;


assign app_wdf_end=app_wdf_wren;

always @ (posedge clk or reset)
begin
 if(reset)
begin
   app_addr<=0;
   app_wdf_data<=0;
   app_rd_data_valid<=0;
  end
else if(app_cmd==3'b000)
 begin
if(app_rdy&&!app_wdf_mask&&app_wdf_rdy&&app_en)
  app_addr<=app_addr+8;
if(app_wdf_wren)
  app_wdf_data<= app_wdf_data+64;
end

else if(app_cmd==3'b001)
 begin
if(app_rdy&&app_en)
  app_addr<=app_addr+8;
if(app_rd_data_valid)
  app_wdf_data<= app_wdf_data+64;
end
 else
  begin
   app_addr<=0;
   app_wdf_data<=0;
   app_rd_data_valid<=0;
     end
end

always @ (app_addr)
begin
 if(app_cmd==3'b000)
mem[app_addr]<=app_wdf_data;
 else if(app_cmd==3'b001)
app_rd_data<=mem[app_addr];
end

assign compare_error=(app_rd_data==app_wdf_data)?0:1;

endmodule