module crossbar2x2(
  input           clock,
  input           reset,
  
  input           master_0_req,           //  Request from: Master 0
  input           master_1_req,           //                Master 1
  input           master_0_cmd,           //  Command from: Master 0
  input           master_1_cmd,           //                Master 1
  input           slave_0_ack,            //  Acknowledge from: Slave 0 
  input           slave_1_ack,            //                    Slave 1
  
  input   [31:0]  master_0_addr,          //  Requested address from: Master 0 // if (master_{n}_addr[31] == 0) to Slave 0
  input   [31:0]  master_1_addr,          //                          Master 1 // if (master_{n}_addr[31] == 1) to Slave 1
  input   [31:0]  master_0_wdata,         //  Write data from: Master 0
  input   [31:0]  master_1_wdata,         //                   Master 1
  input   [31:0]  slave_0_rdata,          //  Read data from: Slave 0
  input   [31:0]  slave_1_rdata,          //                  Slave 1
  
  output          slave_0_req,            //  Request to: Slave 0
  output          slave_1_req,            //              Slave 1
  output          slave_0_cmd,            //  Command to: Slave 0
  output          slave_1_cmd,            //              Slave 1
  output          master_0_ack,           //  Complete transaction to: Master 0
  output          master_1_ack,           //                           Master 1
  
  output  [30:0]  slave_0_addr,           //  Requested address to: Slave 0
  output  [30:0]  slave_1_addr,           //                        Slave 1
  output  [31:0]  slave_0_wdata,          //  Write data to: Slave 0
  output  [31:0]  slave_1_wdata,          //                 Slave 1
  output  [31:0]  master_0_rdata,         //  Read data to: Master 0
  output  [31:0]  master_1_rdata          //                Master 1
);

////////////////////////////////////////////
//                 Registers              //
//                 to slaves:             //
reg         R_slave_0_req = 1'b0;         //
reg         R_slave_0_cmd = 1'b0;         //
reg [30:0]  R_slave_0_addr = {31'b0};     //
reg [31:0]  R_slave_0_wdata = {32'b0};    //
reg         R_slave_1_req = 1'b0;         //
reg         R_slave_1_cmd = 1'b0;         //
reg [30:0]  R_slave_1_addr = {31'b0};     //
reg [31:0]  R_slave_1_wdata = {32'b0};    //
//                 to masters:            //
reg         R_master_0_ack = 1'b0;        //
reg [31:0]  R_master_0_rdata = {32'b0};   //
reg         R_master_1_ack = 1'b0;        //
reg [31:0]  R_master_1_rdata = {32'b0};   //
////////////////////////////////////////////

assign  slave_0_req = R_slave_0_req;
assign  slave_0_cmd = R_slave_0_cmd;
assign  slave_0_addr = R_slave_0_addr;
assign  slave_0_wdata = R_slave_0_wdata;

assign  slave_1_req = R_slave_1_req;
assign  slave_1_cmd = R_slave_1_cmd;
assign  slave_1_addr = R_slave_1_addr;
assign  slave_1_wdata = R_slave_1_wdata;

assign  master_0_ack = R_master_0_ack;
assign  master_0_rdata = R_master_0_rdata;

assign  master_1_ack = R_master_1_ack;
assign  master_1_rdata = R_master_1_rdata;

wire [1:0]  request_slave_0;
wire [1:0]  request_slave_1;
wire [1:0]  acknowledge_slave_0;
wire [1:0]  acknowledge_slave_1;
wire [1:0]  grant_0;
wire [1:0]  grant_1;

arbiter arbiter_0(
  .clock(clock),
  .reset(reset),
  .request(request_slave_0),
  .acknowledge(acknowledge_slave_0),
  .grant(grant_0)
);

arbiter arbiter_1(
  .clock(clock),
  .reset(reset),
  .request(request_slave_1),
  .acknowledge(acknowledge_slave_1),
  .grant(grant_1)
);

assign request_slave_0[0] = master_0_req & ~master_0_addr[31] & ~acknowledge_slave_0[0];
assign request_slave_0[1] = master_1_req & ~master_1_addr[31] & ~acknowledge_slave_0[1];
assign request_slave_1[0] = master_0_req & master_0_addr[31] & ~acknowledge_slave_0[0];
assign request_slave_1[1] = master_1_req & master_1_addr[31] & ~acknowledge_slave_0[1];

assign acknowledge_slave_0[0] = grant_0[0] & ~slave_0_ack;
assign acknowledge_slave_0[1] = grant_0[1] & ~slave_0_ack;
assign acknowledge_slave_1[0] = grant_1[0] & ~slave_1_ack;
assign acknowledge_slave_1[1] = grant_1[1] & ~slave_1_ack;

always @(posedge clock or posedge reset)
begin
  if (reset)
    begin
      R_master_0_ack  <= 1'b0;    R_master_1_ack  <= 1'b0;
      R_slave_0_req   <= 1'b0;    R_slave_1_req   <= 1'b0;
      R_slave_0_cmd   <= 1'b0;    R_slave_1_cmd   <= 1'b0;
    end
  else
    begin
      R_slave_0_req     <= 1'b0;
      R_slave_0_cmd     <= 1'b0;
      R_slave_0_addr    <= 31'b0;
      R_slave_0_wdata   <= 32'b0;
      R_slave_1_req     <= 1'b0;
      R_slave_1_cmd     <= 1'b0;
      R_slave_1_addr    <= 31'b0;
      R_slave_1_wdata   <= 32'b0;
      
      R_master_0_ack    <=  1'b0;
      R_master_1_ack    <=  1'b0;
      R_master_0_rdata  <=  32'b0;
      R_master_1_rdata  <=  32'b0;
      
      if (grant_0[0])
        begin
          R_slave_0_req   <=  master_0_req;
          R_slave_0_cmd   <=  master_0_cmd;
          R_master_0_ack  <=  slave_0_ack;
          R_slave_0_addr  <=  master_0_addr[30:0];
          if (master_0_cmd == 1'b1)
            R_slave_0_wdata <=  master_0_wdata;
          if (R_slave_0_cmd == 1'b0)
            if (R_master_0_ack == 1'b1)
              R_master_0_rdata  <=  slave_0_rdata;
        end
        
      if (grant_0[1])
        begin
          R_slave_0_req   <=  master_1_req;
          R_slave_0_cmd   <=  master_1_cmd;
          R_master_1_ack  <=  slave_0_ack;
          R_slave_0_addr  <=  master_1_addr[30:0];
          if (master_1_cmd == 1'b1)
            R_slave_0_wdata <=  master_1_wdata;
          if (R_slave_0_cmd == 1'b0)
            if (R_master_1_ack == 1'b1)
              R_master_1_rdata  <=  slave_0_rdata;
        end
        
      if (grant_1[0])
        begin
          R_slave_1_req   <=  master_0_req;
          R_slave_1_cmd   <=  master_0_cmd;
          R_master_0_ack  <=  slave_1_ack;
          R_slave_1_addr  <=  master_0_addr[30:0];
          if (master_0_cmd == 1'b1)
            R_slave_1_wdata <=  master_0_wdata;
          if (R_slave_1_cmd == 1'b0)
            if (R_master_0_ack == 1'b1)
              R_master_0_rdata  <=  slave_1_rdata;
        end
        
      if (grant_1[1])
        begin
          R_slave_1_req   <=  master_1_req;
          R_slave_1_cmd   <=  master_1_cmd;
          R_master_1_ack  <=  slave_1_ack;
          R_slave_1_addr  <=  master_1_addr[30:0];
          if (master_1_cmd == 1'b1)
            R_slave_1_wdata <=  master_1_wdata;
          if (R_slave_1_cmd == 1'b0)
            if (R_master_1_ack == 1'b1)
              R_master_1_rdata  <=  slave_1_rdata;
        end
        
    end
end

endmodule
