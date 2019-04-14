//*****************************************************************************
// (c) Copyright 2008-2010 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//
//*****************************************************************************
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor: Xilinx
// \   \   \/     Version: %version
//  \   \         Application: MEMC
//  /   /         Filename: memc_traffic_gen.v
// /___/   /\     Date Last Modified: $Date:
// \   \  /  \    Date Created:
//  \___\/\___\
//
//Device: Spartan6/Virtex6
//Design Name: memc_traffic_gen
//Purpose: This is top level module of memory traffic generator which can
//         generate different CMD_PATTERN and DATA_PATTERN to Spartan 6
//         hard memory controller core.
//Reference:
//Revision History:     1.1    Brought out internal signals cmp_data and cmp_error as outputs.
//                      1.2    7/1/2009  Added EYE_TEST parameter for signal SI probing.
//                      1.3    10/1/2009 Added dq_error_bytelane_cmp,cumlative_dq_lane_error signals for V6.
//                                       Any comparison error on user read data bus are mapped back to 
//                                       dq bus.  The cumulative_dq_lane_error accumulate any errors on
//                                       DQ bus. And the dq_error_bytelane_cmp shows error during current 
//                                       command cycle. The error can be cleared by input signal "manual_clear_error".
//                      1.4    7/29/10  Support virtex Back-to-back commands over user interface.
//                  
//                             1/4/2012  Added vio_percent_write (instr_mode == 4) to
//                                       let user specify percentage of write commands out of mix
//                                       write/read commands. 

//*****************************************************************************
`timescale 1ps/1ps

module mig_7series_v4_0_memc_traffic_gen #
  (
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 29
  )
 (
input clk_i;
 input rst_n ;

 output reg gen_wdata_en ;
 output reg [ ADDR_WIDTH-1:0]  gen_waddr;
output reg [ DATA_WIDTH-1:0]gen_wdata ;
  input  gen_wdata_rdy ;//写指令和数据通道准备就绪

output reg gen_rdata_en ;
 output reg [ ADDR_WIDTH-1:0] gen_raddr ;
input [ DATA_WIDTH-1:0] gen_rdata  ;
 input gen_rdata_vld ;
 input  gen_rdata_rdy;
 );

reg [ (8-1):0] cnt0  ;
wire add_cnt0 ;
 wire end_cnt0 ;
 reg [ (2-1):0]cnt1 ;
wire add_cnt1 ;
wire end_cnt1 ;
reg [ DATA_WIDTH-1:0] gen_rdata_r  ;
reg gen_rdata_vld_r ;
 reg    com_flag     ;

 wire wri_state;
 wire rd_state;
 wire com_change_t;
 
 //操作周期计数器，计数值为欲操作用户地址段长度+1（需要一个时钟周期空闲）
always @(posedge clk_i or negedge rst_n) begin 
   if (rst_n==0) begin
       cnt0 <= 0; 
   end
   else if(add_cnt0) begin
       if(end_cnt0)
            cnt0 <= 0; 
      else
    cnt0 <= cnt0+1 ;
  end
end
assign add_cnt0 = (com_flag == www.chushiyl.cn 0 && gen_wdata_rdy) || (com_flag == 1 && gen_rdata_rdy);
 assign end_cnt0 = add_cnt0  && cnt0 == (30)-1 ;

 //指令标志位 先是0--写 再是1--读
always @(posedge clk_i or negedge rst_n )begin 
  if(rst_n==0) begin
        com_flag <= (0)  ;
   end
     else if(com_change_t)begin
      com_flag <= (!com_flag)  ;
   end 
 end

 assign com_change_t = add_cnt0 && cnt0 == 10 - 1;

 //写操作---------------------------------------------
 always @(posedge clk_i or negedge rst_n )begin 
  if(rst_n==0) begin
         gen_wdata_en <= (0)  ;
   end
    else if(wri_state)begin
        gen_wdata_en <= (1'b1)  ;
    end 
    else begin
        gen_wdata_en <= (0)  ;
     end 
 end

 assign wri_state = add_cnt0 && cnt0 <=www.caitianxia178.com 10-1 && com_flag == 0;
assign rd_state  = add_cnt0 && cnt0 <= 10-1 && com_flag == 1;

 always @(posedge clk_i or negedge rst_n )begin 
    if(rst_n==0) begin
         gen_wdata <= (0)  ;
     end
     else begin
        gen_wdata <= (cnt0)  ;
    end 
 end
 always@(posedge clk_i or negedge www.boshenyl.cn rst_n)begin
    if(rst_n == 0)
       gen_waddr <= 0;
    else if(wri_state)
         gen_waddr <= gen_waddr + 29'd8;
   else 
         gen_waddr <= 0;
 end
 //读操作----------------------------------------------
always @(posedge clk_i or negedge rst_n )begin 
    if(rst_n==0) begin
        gen_rdata_en <= (0)  ;
   end
   else if(rd_state)begin
         gen_rdata_en <= (1'b1)  ;
    end 
    else begin
        gen_rdata_en <= (0)  ;
    end 
 end
 
always@(posedge clk_i or negedge rst_n)begin
     if(rst_n == 0)
         gen_raddr <= 0;
   else if(rd_state)
        gen_raddr <= gen_raddr + 29'd8;
    else 
        gen_raddr <= 0;
 end

always @(posedge clk_i or negedge rst_n )begin 
    if(rst_n==0) begin
        gen_rdata_r <= (0)  ;
    end
     else begin
         gen_rdata_r <= (gen_rdata)  ;
    end 
 end

 always @(posedge clk_i or negedge rst_n )begin 
    if(rst_n==0) begin
        gen_rdata_vld_r <= (0)  ;
   end
   else if(gen_rdata_vld)begin
        gen_rdata_vld_r <= (1'b1)  ;
    end 
    else begin
        gen_rdata_vld_r <= (0)  ;
     end 
 end
 endmodule
  
  
  
// ****  for debug
// this part of logic is to check there are no commands been duplicated or dropped
// in the cmd_flow_control logic
generate
if (SIMULATION == "TRUE") 
begin: cmd_check
wire fifo_error;
wire [31:0] xfer_addr;
wire [BL_WIDTH-1:0] xfer_cmd_bl;
wire cmd_fifo_rd;

assign cmd_fifo_wr =  flow2cmd_rdy & cmd2flow_valid;

assign fifo_error = ( xfer_addr != memc_cmd_addr_o) ? 1'b1: 1'b0;


wire cmd_fifo_empty;
//assign cmd_fifo_rd = memc_cmd_en_o & ~memc_cmd_full_i & ~cmd_fifo_empty;
assign cmd_fifo_rd = memc_cmd_en_o  & ~cmd_fifo_empty;


  mig_7series_v4_0_afifo #
   (.TCQ           (TCQ),
    .DSIZE         (32+BL_WIDTH),
    .FIFO_DEPTH    (16),
    .ASIZE         (4),
    .SYNC          (1)  // set the SYNC to 1 because rd_clk = wr_clk to reduce latency


   )
   cmd_fifo
   (
    .wr_clk        (clk_i),
    .rst           (rst_ra[0]),
    .wr_en         (cmd_fifo_wr),
    .wr_data       ({cmd2flow_bl,cmd2flow_addr}),
    .rd_en         (cmd_fifo_rd),
    .rd_clk        (clk_i),
    .rd_data       ({xfer_cmd_bl,xfer_addr}),
    .full          (cmd_fifo_full),
    .almost_full   (),
    .empty         (cmd_fifo_empty)

   );


end
else
begin
  assign fifo_error = 1'b0;
end

endgenerate

reg [31:0] end_addr_r;
 always @ (posedge clk_i)
    end_addr_r <= end_addr_i;


   mig_7series_v4_0_cmd_gen
     #(
       .TCQ                 (TCQ),
       .FAMILY              (FAMILY)     ,
       .MEM_TYPE           (MEM_TYPE),
       
       .BL_WIDTH            (BL_WIDTH),
       .nCK_PER_CLK       (nCK_PER_CLK),
       
       .MEM_BURST_LEN       (MEM_BURST_LEN),
       .PORT_MODE           (PORT_MODE),
       .BANK_WIDTH          (BANK_WIDTH),
       .NUM_DQ_PINS         (NUM_DQ_PINS),
       .DATA_PATTERN        (DATA_PATTERN),
       .CMD_PATTERN         (CMD_PATTERN),
       .ADDR_WIDTH          (ADDR_WIDTH),
       .DWIDTH              (DWIDTH),
       .MEM_COL_WIDTH       (MEM_COL_WIDTH),
       .PRBS_EADDR_MASK_POS (PRBS_EADDR_MASK_POS ),
       .PRBS_SADDR_MASK_POS (PRBS_SADDR_MASK_POS  ),
       .PRBS_EADDR          (PRBS_EADDR),
       .PRBS_SADDR          (PRBS_SADDR )

       )
   u_c_gen
     (
      .clk_i              (clk_i),
      .rst_i               (rst_ra),
      .reading_rd_data_i (memc_rd_en_o),
      .vio_instr_mode_value          (vio_instr_mode_value),
      .vio_percent_write             (vio_percent_write),
      .single_operation (single_operation),
      .run_traffic_i    (run_traffic_reg),
      .mem_pattern_init_done_i   (mem_pattern_init_done_i),
      .start_addr_i     (start_addr_i),
      .end_addr_i       (end_addr_r),
      .cmd_seed_i       (cmd_seed_i),
      .load_seed_i      (load_seed_i),
      .addr_mode_i      (addr_mode_i),
      .data_mode_i        (data_mode_r_a),

      .instr_mode_i     (instr_mode_i),
      .bl_mode_i        (bl_mode_i),
      .mode_load_i      (mode_load_i),
   // fixed pattern inputs interface
      .fixed_bl_i       (fixed_bl_i),
      .fixed_addr_i     (fixed_addr_i),
      .fixed_instr_i    (fixed_instr_i),
   // BRAM FIFO input :  Holist vector inputs

      .bram_addr_i      (bram_addr_i),
      .bram_instr_i     (bram_instr_i ),
      .bram_bl_i        (bram_bl_i ),
      .bram_valid_i     (bram_valid_i ),
      .bram_rdy_o       (bram_rdy_o   ),

      .rdy_i            (flow2cmd_rdy),
      .instr_o          (cmd2flow_cmd),
      .addr_o           (cmd2flow_addr),
      .bl_o             (cmd2flow_bl),
//      .m_addr_o         (m_addr),
      .cmd_o_vld        (cmd2flow_valid),
      .mem_init_done_o  (mem_init_done)

      );

assign memc_cmd_addr_o = addr_o;


assign qdr_wr_cmd_o = memc_wr_en_r;

assign cmd_full = memc_cmd_full_i;
   mig_7series_v4_0_memc_flow_vcontrol #
     (
       .TCQ           (TCQ),
       .nCK_PER_CLK       (nCK_PER_CLK),
       
       .BL_WIDTH          (BL_WIDTH),
       .MEM_BURST_LEN     (MEM_BURST_LEN),
       .NUM_DQ_PINS          (NUM_DQ_PINS),       
       .FAMILY  (FAMILY),
       .MEM_TYPE           (MEM_TYPE)
       
     )
   memc_control
     (
      .clk_i                   (clk_i),
      .rst_i                   (rst_ra),
      .data_mode_i             (data_mode_r_b),
      .cmds_gap_delay_value    (cmds_gap_delay_value),
      .mcb_wr_full_i           (memc_wr_full_i),
      .cmd_rdy_o               (flow2cmd_rdy),
      .cmd_valid_i             (cmd2flow_valid),
      .cmd_i                   (cmd2flow_cmd),
      

      .mem_pattern_init_done_i (mem_pattern_init_done_i),
      
      .addr_i                  (cmd2flow_addr),
      .bl_i                    (cmd2flow_bl),
      // interface to memc_cmd port
      .mcb_cmd_full            (cmd_full),
      .cmd_o                   (memc_cmd_instr_o),
      .addr_o                  (addr_o),
      .bl_o                    (memc_bl_o),
      .cmd_en_o                (memc_cmd_en_o),
      .qdr_rd_cmd_o            (qdr_rd_cmd_o), 
   // interface to write data path module
   
      .mcb_wr_en_i             (memc_wr_en),
      .last_word_wr_i          (last_word_wr),
      .wdp_rdy_i               (wr_rdy),//(wr_rdy),
      .wdp_valid_o             (wr_valid),
      .wdp_validB_o            (wr_validB),
      .wdp_validC_o            (wr_validC),

      .wr_addr_o               (wr_addr),
      .wr_bl_o                 (wr_bl),
   // interface to read data path module

      .rdp_rdy_i               (rd_rdy),// (rd_rdy),
      .rdp_valid_o             (rd_valid),
      .rd_addr_o               (rd_addr),
      .rd_bl_o                 (rd_bl)

      );


  /* afifo #
   (
   
    .TCQ           (TCQ),
    .DSIZE         (DWIDTH),
    .FIFO_DEPTH    (32),
    .ASIZE         (5),
    .SYNC          (1)  // set the SYNC to 1 because rd_clk = wr_clk to reduce latency 
   
   
   )
   rd_mdata_fifo
   (
    .wr_clk        (clk_i),
    .rst           (rst_rb[0]),
    .wr_en         (!memc_rd_empty_i),
    .wr_data       (memc_rd_data_i),
    .rd_en         (memc_rd_en_o),
    .rd_clk        (clk_i),
    .rd_data       (rd_v6_mdata),
    .full          (),
    .almost_full   (rd_mdata_fifo_afull),
    .empty         (rd_mdata_fifo_empty)
   
   );
*/

wire cmd_rd_en;

assign cmd_rd_en =  memc_cmd_en_o;




assign rdpath_data_valid_i =!memc_rd_empty_i ;
assign rdpath_rd_data_i = memc_rd_data_i ;


generate
if (PORT_MODE == "RD_MODE" || PORT_MODE == "BI_MODE") 
begin : RD_PATH
   mig_7series_v4_0_read_data_path
     #(
       .TCQ           (TCQ),
       .FAMILY            (FAMILY)  ,
       .MEM_TYPE           (MEM_TYPE),
       .BL_WIDTH          (BL_WIDTH),
       .nCK_PER_CLK       (nCK_PER_CLK),
       
       .MEM_BURST_LEN     (MEM_BURST_LEN),
       .START_ADDR        (PRBS_SADDR),
       .CMP_DATA_PIPE_STAGES (CMP_DATA_PIPE_STAGES),
       .ADDR_WIDTH        (ADDR_WIDTH),
       .SEL_VICTIM_LINE   (SEL_VICTIM_LINE),
       .DATA_PATTERN      (DATA_PATTERN),
       .DWIDTH            (DWIDTH),
       .NUM_DQ_PINS       (NUM_DQ_PINS),
       .MEM_COL_WIDTH     (MEM_COL_WIDTH),
       .SIMULATION        (SIMULATION)

       )
   read_data_path
     (
      .clk_i              (clk_i),
      .rst_i              (rst_rb),
      .manual_clear_error (manual_clear_error),
      .cmd_rdy_o          (rd_rdy),
      .cmd_valid_i        (rd_valid),
      .memc_cmd_full_i    (memc_cmd_full_i),
      .prbs_fseed_i         (data_seed_i),
      .cmd_sent                 (memc_cmd_instr_o),
      .bl_sent                  (memc_bl_o[5:0]),
      .cmd_en_i              (cmd_rd_en),
      .vio_instr_mode_value  (vio_instr_mode_value),

      .data_mode_i        (data_mode_r_b),
      .fixed_data_i         (fixed_data_i),
      .simple_data0       (simple_data0),
      .simple_data1       (simple_data1),
      .simple_data2       (simple_data2),
      .simple_data3       (simple_data3),
      .simple_data4       (simple_data4),
      .simple_data5       (simple_data5),
      .simple_data6       (simple_data6),
      .simple_data7       (simple_data7),
      
      .mode_load_i        (mode_load_i),

      .addr_i                 (rd_addr),
      .bl_i                   (rd_bl),
      .data_rdy_o             (memc_rd_en_o),
      
      .data_valid_i           (rdpath_data_valid_i),
      .data_i                 (rdpath_rd_data_i), 
      
      
      .data_error_o           (cmp_error),
      .cmp_data_valid         (cmp_data_valid),
      .cmp_data_o             (cmp_data),
      .rd_mdata_o             (mem_rd_data ),
      .cmp_addr_o             (cmp_addr),
      .cmp_bl_o               (cmp_bl),
      .dq_error_bytelane_cmp     (dq_error_bytelane_cmp),
      
      //****************************************************
      .cumlative_dq_lane_error_r   (cumlative_dq_lane_error),
      .cumlative_dq_r0_bit_error_r  (cumlative_dq_r0_bit_error),
      .cumlative_dq_f0_bit_error_r  (cumlative_dq_f0_bit_error),
      .cumlative_dq_r1_bit_error_r  (cumlative_dq_r1_bit_error),
      .cumlative_dq_f1_bit_error_r  (cumlative_dq_f1_bit_error),
      .dq_r0_bit_error_r               (dq_r0_bit_error_r),
      .dq_f0_bit_error_r               (dq_f0_bit_error_r),
      .dq_r1_bit_error_r               (dq_r1_bit_error_r),
      .dq_f1_bit_error_r               (dq_f1_bit_error_r),
      
      .dq_r0_read_bit_r              (dq_r0_read_bit),   
      .dq_f0_read_bit_r              (dq_f0_read_bit),   
      .dq_r1_read_bit_r              (dq_r1_read_bit),   
      .dq_f1_read_bit_r              (dq_f1_read_bit),   
      .dq_r0_expect_bit_r           (dq_r0_expect_bit),   
      .dq_f0_expect_bit_r           (dq_f0_expect_bit ),  
      .dq_r1_expect_bit_r           (dq_r1_expect_bit),   
      .dq_f1_expect_bit_r           (dq_f1_expect_bit ),
      .error_addr_o                 (error_addr)
      
      
      
      

      );

end
else
begin
  assign cmp_error  = 1'b0;
  assign cmp_data_valid = 1'b0;
  assign cmp_data ='b0;

end

endgenerate



assign wr_path_data_rdy_i = !(memc_wr_full_i ) ;//& (~memc_cmd_full_i);

generate
if (PORT_MODE == "WR_MODE" || PORT_MODE == "BI_MODE") 
begin : WR_PATH

   mig_7series_v4_0_write_data_path
     #(
     
       .TCQ           (TCQ),
       .FAMILY  (FAMILY),
       .nCK_PER_CLK       (nCK_PER_CLK),
       .MEM_TYPE           (MEM_TYPE),
       
       .START_ADDR        (PRBS_SADDR),
       .BL_WIDTH          (BL_WIDTH),
       .MEM_BURST_LEN     (MEM_BURST_LEN),
       .ADDR_WIDTH        (ADDR_WIDTH),
       .DATA_PATTERN      (DATA_PATTERN),
       .DWIDTH            (DWIDTH),
       .NUM_DQ_PINS       (NUM_DQ_PINS),
       .SEL_VICTIM_LINE   (SEL_VICTIM_LINE),
       .MEM_COL_WIDTH     (MEM_COL_WIDTH),
       .EYE_TEST          (EYE_TEST)

       )
   write_data_path
     (
      .clk_i(clk_i),
      .rst_i                (rst_rb),
      .cmd_rdy_o            (wr_rdy),
      .cmd_valid_i          (wr_valid),
      .cmd_validB_i         (wr_validB),
      .cmd_validC_i         (wr_validC),
      .prbs_fseed_i         (data_seed_i),
      .mode_load_i          (mode_load_i),
      .wr_data_mask_gen_i    (wr_data_mask_gen_i),
      .mem_init_done_i      (mem_init_done),
      
  
      .data_mode_i          (data_mode_r_c),
      .last_word_wr_o       (last_word_wr),
      .fixed_data_i         (fixed_data_i),
      .simple_data0       (simple_data0),
      .simple_data1       (simple_data1),
      .simple_data2       (simple_data2),
      .simple_data3       (simple_data3),
      .simple_data4       (simple_data4),
      .simple_data5       (simple_data5),
      .simple_data6       (simple_data6),
      .simple_data7       (simple_data7),
      
      
      .addr_i               (wr_addr),
      .bl_i                 (wr_bl),
      .memc_cmd_full_i      (memc_cmd_full_i),
      .data_rdy_i           (wr_path_data_rdy_i),
      .data_valid_o         (memc_wr_en),
      .data_o               (memc_wr_data),
      .data_mask_o          (memc_wr_mask_o),
      .data_wr_end_o        (memc_wr_data_end)
      );

end
else 
begin
   assign memc_wr_en       = 1'b0;
   assign memc_wr_data     = 'b0;
   assign memc_wr_mask_o   = 'b0;

end

endgenerate

generate
if (MEM_TYPE != "QDR2PLUS" && (FAMILY == "VIRTEX6" || FAMILY == "SPARTAN6" )) 
  begin: nonQDR_WR 
    assign  memc_wr_en_o       = memc_wr_en;
    assign  memc_wr_data_o     = memc_wr_data    ;
    assign  memc_wr_data_end_o = (nCK_PER_CLK == 4) ? memc_wr_data_end: memc_wr_data_end;
  end                                                                                                
// QDR 
else
  begin: QDR_WR 
                          
    always @ (posedge clk_i)
      memc_wr_data_r <= memc_wr_data;
                         
    assign  memc_wr_en_o       = memc_wr_en;
    assign  memc_wr_data_o     = memc_wr_data_r    ;

    assign  memc_wr_data_end_o = memc_wr_data_end;
  end
endgenerate

//QDR
always @ (posedge clk_i)
begin

if (memc_wr_full_i) 
   begin
   memc_wr_en_r       <= 1'b0;
   end
else 
   begin
   memc_wr_en_r       <= memc_wr_en;
   end

end

   mig_7series_v4_0_tg_status
     #(
     
       .TCQ           (TCQ),
       .DWIDTH            (DWIDTH)
       )
   tg_status
     (
      .clk_i              (clk_i),
      .rst_i              (rst_ra[2]),
      .manual_clear_error (manual_clear_error),
      .data_error_i       (cmp_error),
      .cmp_data_i         (cmp_data),
      .rd_data_i          (mem_rd_data ),
      .cmp_addr_i         (cmp_addr),
      .cmp_bl_i           (cmp_bl),
      .mcb_cmd_full_i     (memc_cmd_full_i),
      .mcb_wr_full_i      (memc_wr_full_i),          
      .mcb_rd_empty_i     (memc_rd_empty_i),
      .error_status       (error_status),
      .error              (error)
      );


endmodule // memc_traffic_gen
