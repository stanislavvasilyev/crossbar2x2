`ifndef _INTERFACE_
`define _INTERFACE_

interface input_inter(input bit clock);
  wire          reset;
  
  wire          master_0_req;
  wire          master_0_cmd;
  wire          slave_0_ack;
  wire  [31:0]  master_0_addr;
  wire  [31:0]  master_0_wdata;
  wire  [31:0]  slave_0_rdata;
  
  wire          master_1_req;
  wire          master_1_cmd;
  wire          slave_1_ack;
  wire  [31:0]  master_1_addr;
  wire  [31:0]  master_1_wdata;
  wire  [31:0]  slave_1_rdata;
  
  clocking cb @(posedge clock);
    output      reset,
    
                master_0_req,
                master_0_cmd,
                slave_0_ack,
                master_0_addr,
                master_0_wdata,
                slave_0_rdata,
                
                master_1_req,
                master_1_cmd,
                slave_1_ack,
                master_1_addr,
                master_1_wdata,
                slave_1_rdata;
  endclocking: cb
  
  modport input_ports(clocking cb, input clock);
endinterface: input_inter

interface output_inter(input bit clock);
  wire         slave_0_req;
  wire         slave_0_cmd;
  wire [30:0]  slave_0_addr;
  wire [31:0]  slave_0_wdata;

  wire         slave_1_req;
  wire         slave_1_cmd;
  wire [30:0]  slave_1_addr;
  wire [31:0]  slave_1_wdata;

  wire         master_0_ack;
  wire [31:0]  master_0_rdata;

  wire         master_1_ack;
  wire [31:0]  master_1_rdata;

  clocking cb @(posedge clock);
    input slave_0_req,
          slave_0_cmd,
          slave_0_addr,
          slave_0_wdata,
          
          slave_1_req,
          slave_1_cmd,
          slave_1_addr,
          slave_1_wdata,
          
          master_0_ack,
          master_0_rdata,
          
          master_1_ack,
          master_1_rdata;
  endclocking: cb
  
  modport output_ports(clocking cb, input clock);
endinterface: output_inter

`endif
