module direct_test;

reg clock;
reg reset;

reg         tb_master_0_req = 1'b0;
reg         tb_master_0_cmd = 1'b0;
reg [31:0]  tb_master_0_addr = {32'b0};
reg [31:0]  tb_master_0_wdata = {32'b0};

reg         tb_master_1_req = 1'b0;
reg         tb_master_1_cmd = 1'b0;
reg [31:0]  tb_master_1_addr = {32'b0};
reg [31:0]  tb_master_1_wdata = {32'b0};

reg         tb_slave_0_ack = 1'b0;
reg [31:0]  tb_slave_0_rdata = {32'b0};

reg         tb_slave_1_ack = 1'b0;
reg [31:0]  tb_slave_1_rdata = {32'b0};

wire         tb_slave_0_req;
wire         tb_slave_0_cmd;
wire [30:0]  tb_slave_0_addr;
wire [31:0]  tb_slave_0_wdata;

wire         tb_slave_1_req;
wire         tb_slave_1_cmd;
wire [30:0]  tb_slave_1_addr;
wire [31:0]  tb_slave_1_wdata;

wire         tb_master_0_ack;
wire [31:0]  tb_master_0_rdata;

wire         tb_master_1_ack;
wire [31:0]  tb_master_1_rdata;

crossbar2x2 dut(
  .clock(clock),
  .reset(reset),
  
  .master_0_req(tb_master_0_req),
  .master_1_req(tb_master_1_req),
  .master_0_cmd(tb_master_0_cmd),
  .master_1_cmd(tb_master_1_cmd),
  .slave_0_ack(tb_slave_0_ack),
  .slave_1_ack(tb_slave_1_ack),
  
  .master_0_addr(tb_master_0_addr),
  .master_1_addr(tb_master_1_addr),
  .master_0_wdata(tb_master_0_wdata),
  .master_1_wdata(tb_master_1_wdata),
  .slave_0_rdata(tb_slave_0_rdata),
  .slave_1_rdata(tb_slave_1_rdata),
  
  .slave_0_req(tb_slave_0_req),
  .slave_1_req(tb_slave_1_req),
  .slave_0_cmd(tb_slave_0_cmd),
  .slave_1_cmd(tb_slave_1_cmd),
  .master_0_ack(tb_master_0_ack),
  .master_1_ack(tb_master_1_ack),
  
  .slave_0_addr(tb_slave_0_addr),
  .slave_1_addr(tb_slave_1_addr),
  .slave_0_wdata(tb_slave_0_wdata),
  .slave_1_wdata(tb_slave_1_wdata),
  .master_0_rdata(tb_master_0_rdata),
  .master_1_rdata(tb_master_1_rdata)
);

initial begin
  
 	clock = 0;
	reset = 0;

  #20 reset = 1;
  #20 reset = 0;
  
  repeat (1) @ (posedge clock);
  tb_master_0_req   <=  1'b1;
  tb_master_1_req   <=  1'b1;
  tb_master_0_cmd   <=  1'b1;
  tb_master_1_cmd   <=  1'b1;
  tb_master_0_addr  <=  8'hA;
  tb_master_1_addr  <=  8'hB;
  tb_master_0_wdata <=  8'hA;
  tb_master_1_wdata <=  8'hB;

  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b1;
  
  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b0;
  tb_master_0_req   <=  0;
  tb_master_1_req   <=  0;
  tb_master_0_cmd   <=  0;
  tb_master_1_cmd   <=  0;
  tb_master_0_addr  <=  0;
  tb_master_1_addr  <=  0;
  tb_master_0_wdata <=  0;
  tb_master_1_wdata <=  0;
  
  repeat(1) @ (posedge clock);
// End 1 write transaction

  repeat(1) @ (posedge clock);
//  tb_master_0_req   <=  1'b1;
  tb_master_1_req   <=  1'b1;
//  tb_master_0_cmd   <=  1'b1;
  tb_master_1_cmd   <=  1'b1;
//  tb_master_0_addr  <=  8'hA;
  tb_master_1_addr  <=  8'hB;
//  tb_master_0_wdata <=  8'hA;
  tb_master_1_wdata <=  8'hB;
  
  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b1;

  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b0;
//  tb_master_0_req   <=  0;
  tb_master_1_req   <=  0;
//  tb_master_0_cmd   <=  0;
  tb_master_1_cmd   <=  0;
//  tb_master_0_addr  <=  0;
  tb_master_1_addr  <=  0;
//  tb_master_0_wdata <=  0;
  tb_master_1_wdata <=  0;
  
  repeat(1) @ (posedge clock);
// End 2 write transaction

  repeat(1) @ (posedge clock);  
  tb_master_0_req   <=  1'b1;
//  tb_master_1_req   <=  1'b1;
  tb_master_0_cmd   <=  1'b1;
//  tb_master_1_cmd   <=  1'b1;
  tb_master_0_addr  <=  8'hA;
//  tb_master_1_addr  <=  8'hB;
  tb_master_0_wdata <=  8'hA;
//  tb_master_1_wdata <=  8'hB;
  
  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b1;
  
  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b0;
  tb_master_0_req   <=  0;
//  tb_master_1_req   <=  0;
  tb_master_0_cmd   <=  0;
//  tb_master_1_cmd   <=  0;
  tb_master_0_addr  <=  0;
//  tb_master_1_addr  <=  0;
  tb_master_0_wdata <=  0;
//  tb_master_1_wdata <=  0;

  repeat(1) @ (posedge clock);
// End 3 write transaction

  repeat(1) @ (posedge clock);  
  tb_master_0_req   <=  1'b1;
  tb_master_1_req   <=  1'b1;
  tb_master_0_cmd   <=  1'b1;
  tb_master_1_cmd   <=  1'b1;
  tb_master_0_addr  <=  8'hA;
  tb_master_1_addr  <=  8'hB;
  tb_master_0_wdata <=  8'hA;
  tb_master_1_wdata <=  8'hB;

  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b1;
  
  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b0;
  tb_master_0_req   <=  0;
  tb_master_1_req   <=  0;
  tb_master_0_cmd   <=  0;
  tb_master_1_cmd   <=  0;
  tb_master_0_addr  <=  0;
  tb_master_1_addr  <=  0;
  tb_master_0_wdata <=  0;
  tb_master_1_wdata <=  0;
  
  repeat(4) @ (posedge clock);
// End 4 write transaction
  
  #20 reset = 1;
  #20 reset = 0;
  
 	tb_slave_0_rdata <= 8'hAA;
	tb_slave_1_rdata <= 8'hBB;
  
  repeat (1) @ (posedge clock);
  tb_master_0_req   <=  1'b1;
  tb_master_1_req   <=  1'b1;
  tb_master_0_cmd   <=  1'b0;
  tb_master_1_cmd   <=  1'b0;
  tb_master_0_addr  <=  8'hA;
  tb_master_1_addr  <=  8'hB;

  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b1;
  
  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b0;
  tb_master_0_req   <=  0;
  tb_master_1_req   <=  0;
  tb_master_0_cmd   <=  0;
  tb_master_1_cmd   <=  0;
  tb_master_0_addr  <=  0;
  tb_master_1_addr  <=  0;
  
  repeat(1) @ (posedge clock);
// End 1 read transaction

  repeat(1) @ (posedge clock);  
  tb_master_0_req   <=  1'b1;
  tb_master_1_req   <=  1'b1;
  tb_master_0_cmd   <=  1'b0;
  tb_master_1_cmd   <=  1'b0;
  tb_master_0_addr  <=  8'hA;
  tb_master_1_addr  <=  8'hB;

  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b1;
  
  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b0;
  tb_master_0_req   <=  0;
  tb_master_1_req   <=  0;
  tb_master_0_cmd   <=  0;
  tb_master_1_cmd   <=  0;
  tb_master_0_addr  <=  0;
  tb_master_1_addr  <=  0;
  
  repeat(4) @ (posedge clock);
// End 2 read transaction

  #20 reset = 1;
  #20 reset = 0;
  
  repeat(1) @ (posedge clock);
  tb_master_0_req   <=  1'b1;
  tb_master_1_req   <=  1'b1;
  tb_master_0_cmd   <=  1'b0;
  tb_master_1_cmd   <=  1'b0;
  tb_master_0_addr  <=  32'b10000000_00000000_00000000_00001010;
  tb_master_1_addr  <=  32'b10000000_00000000_00000000_00001011;
  
  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b1;
  tb_slave_1_ack    <=  1'b1;
  
  repeat (1) @ (posedge clock);
  tb_slave_0_ack    <=  1'b0;
  tb_slave_1_ack    <=  1'b0;
  tb_master_0_req   <=  0;
  tb_master_1_req   <=  0;
  tb_master_0_cmd   <=  0;
  tb_master_1_cmd   <=  0;
  tb_master_0_addr  <=  0;
  tb_master_1_addr  <=  0;
  
  repeat(4) @ (posedge clock);
// End 2x read transaction

  #100 $finish;
  
end

always #10 clock = ~clock;

endmodule
