`ifndef _PSEUDO_RANDOM_TEST_
`define _PSEUDO_RANDOM_TEST_

`include "interface.sv"
`include "globals.sv"

module pseudo_random_test;
  bit clock;
  initial forever #10 clock = ~clock;
  
  int i = 0;
  
  input_inter   iface[`NUM_OF_DUTS](clock);
  output_inter  oface[`NUM_OF_DUTS](clock);
  
  testcase TC (iface, oface);
  
  generate
    for(genvar i=0; i<`NUM_OF_DUTS; i++)
    begin : dut_connect
      crossbar2x2 dut(
        .clock          (clock),
        .reset          (iface[i].reset),
  
        .master_0_req   (iface[i].master_0_req),
        .master_1_req   (iface[i].master_1_req),
        .master_0_cmd   (iface[i].master_0_cmd),
        .master_1_cmd   (iface[i].master_1_cmd),
        .slave_0_ack    (iface[i].slave_0_ack),
        .slave_1_ack    (iface[i].slave_1_ack),
  
        .master_0_addr  (iface[i].master_0_addr),
        .master_1_addr  (iface[i].master_1_addr),
        .master_0_wdata (iface[i].master_0_wdata),
        .master_1_wdata (iface[i].master_1_wdata),
        .slave_0_rdata  (iface[i].slave_0_rdata),
        .slave_1_rdata  (iface[i].slave_1_rdata),
  
        .slave_0_req    (oface[i].slave_0_req),
        .slave_1_req    (oface[i].slave_1_req),
        .slave_0_cmd    (oface[i].slave_0_cmd),
        .slave_1_cmd    (oface[i].slave_1_cmd),
        .master_0_ack   (oface[i].master_0_ack),
        .master_1_ack   (oface[i].master_1_ack),
  
        .slave_0_addr   (oface[i].slave_0_addr),
        .slave_1_addr   (oface[i].slave_1_addr),
        .slave_0_wdata  (oface[i].slave_0_wdata),
        .slave_1_wdata  (oface[i].slave_1_wdata),
        .master_0_rdata (oface[i].master_0_rdata),
        .master_1_rdata (oface[i].master_1_rdata)
      );
    end
  endgenerate
endmodule: pseudo_random_test

`endif
