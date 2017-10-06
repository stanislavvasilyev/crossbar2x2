module direct_test_arbiter;
  reg clock;
  reg reset;
  
  reg [1:0] tb_request;
  reg [1:0] tb_acknowledge;
  
  wire [1:0] tb_grant;
  
  arbiter dut(
    .clock(clock),
    .reset(reset),
    
    .request(tb_request),
    .acknowledge(tb_acknowledge),
    .grant(tb_grant)
  );
  
initial begin
 	clock = 0;
	reset = 0;

  #20 reset = 1;
  #20 reset = 0;
  
  repeat (1) @(posedge clock);
  tb_request  <=  2'b11;
  repeat (1) @(posedge clock);
  tb_request  <=  2'b00;

  repeat (1) @(posedge clock);
  tb_request  <=  2'b11;
  repeat (1) @(posedge clock);
  tb_request  <=  2'b00;
  
  repeat (1) @(posedge clock);
  tb_request  <=  2'b11;
  repeat (1) @(posedge clock);
  tb_request  <=  2'b00;

  repeat (1) @(posedge clock);
  tb_request  <=  2'b11;
  repeat (1) @(posedge clock);
  tb_request  <=  2'b00;
  
  repeat (4) @(posedge clock);
  #100 $finish;
end
  
  always #10 clock = ~clock;
  
endmodule
