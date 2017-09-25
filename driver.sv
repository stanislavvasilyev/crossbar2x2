`ifndef _DRIVER_
`define _DRIVER_

`include "transaction.sv"
`include "globals.sv"

class driver;
  reg [1:0]   master_req  = '{default:'0};
  reg [1:0]   master_cmd  = '{default:'0};
  reg [1:0]   slave_ack   = '{default:'0};
  
  int log;
  
  virtual input_inter.input_ports iface;
  virtual output_inter.output_ports oface;
  
  mailbox #(transaction) drv2scb_0;
  mailbox #(transaction) drv2scb_1;
  
  transaction trans_0_temp;
  transaction trans_1_temp;
  
  function new(virtual input_inter.input_ports iface_new,
               virtual output_inter.output_ports oface_new,
               mailbox #(transaction) drv2scb_0,
               mailbox #(transaction) drv2scb_1);
    this.iface = iface_new;
    this.oface = oface_new;
    this.drv2scb_0 = drv2scb_0;
    this.drv2scb_1 = drv2scb_1;
    trans_0_temp = new();
    trans_1_temp = new();
  endfunction : new
  
  task reset;
    log = $fopen("log.txt");
    $fwrite(log, "\n");
    $fwrite(log, $time, " ns       Driver: Start resetting the DUT\n");
    $display(" %0d : Driver : Start resetting the DUT",$time);
    iface.cb.reset  <= 1'b0;
    repeat (1) @(iface.cb);
    iface.cb.reset  <= 1'b1;
    repeat (2) @(iface.cb);
    iface.cb.reset  <= 1'b0;
    $fwrite(log, $time, " ns       Driver: End of reset\n\n");
    $display(" %0d : Driver : End of reset",$time);
  endtask : reset
  
  task master_0_write(transaction trans);
    repeat (1) @(iface.cb);
    iface.cb.master_0_req   <=  1'b1;
    iface.cb.master_0_cmd   <=  1'b1;
    iface.cb.master_0_addr  <=  {trans.slave, trans.address};
    iface.cb.master_0_wdata <=  trans.data;
    repeat (1) @(iface.cb);
    if (trans.slave == 1'b0)
      iface.cb.slave_0_ack  <=  1'b1;
    else if (trans.slave == 1'b1)
      iface.cb.slave_1_ack  <=  1'b1;
    repeat (1) @(iface.cb);
    iface.cb.slave_0_ack    <=  1'b0;
    iface.cb.slave_1_ack    <=  1'b0;
    iface.cb.master_0_req   <=  1'b0;
    iface.cb.master_0_cmd   <=  1'b0;
    iface.cb.master_0_addr  <=  '0;
    iface.cb.master_0_wdata <=  '0;
    repeat (1) @(iface.cb);
  endtask: master_0_write

  task master_1_write(transaction trans);
    repeat (1) @(iface.cb);
    iface.cb.master_1_req   <=  1'b1;
    iface.cb.master_1_cmd   <=  1'b1;
    iface.cb.master_1_addr  <=  {trans.slave, trans.address};
    iface.cb.master_1_wdata <=  trans.data;
    repeat (1) @(iface.cb);
    if (trans.slave == 1'b0)
      iface.cb.slave_0_ack  <=  1'b1;
    else if (trans.slave == 1'b1)
      iface.cb.slave_1_ack  <=  1'b1;
    repeat (1) @(iface.cb);
    iface.cb.slave_0_ack    <=  1'b0;
    iface.cb.slave_1_ack    <=  1'b0;
    iface.cb.master_1_req   <=  1'b0;
    iface.cb.master_1_cmd   <=  1'b0;
    iface.cb.master_1_addr  <=  '0;
    iface.cb.master_1_wdata <=  '0;
    repeat (1) @(iface.cb);
  endtask: master_1_write

  task master_0_read(transaction trans);
    repeat (1) @(iface.cb);
    iface.cb.master_0_req   <=  1'b1;
    iface.cb.master_0_cmd   <=  1'b0;
    iface.cb.master_0_addr  <=  {trans.slave, trans.address};
    repeat (1) @(iface.cb);
    if (trans.slave == 1'b0) begin
      iface.cb.slave_0_ack  <=  1'b1;
      iface.cb.slave_0_rdata<=  trans.data;
    end
    else if (trans.slave == 1'b1) begin
      iface.cb.slave_1_ack  <=  1'b1;
      iface.cb.slave_1_rdata<=  trans.data;
    end
    repeat (1) @(iface.cb);
    iface.cb.slave_0_ack    <=  1'b0;
    iface.cb.slave_1_ack    <=  1'b0;
    iface.cb.master_0_req   <=  1'b0;
    iface.cb.master_0_addr  <=  '0;
    repeat (1) @(iface.cb);
  endtask: master_0_read
  
  task master_1_read(transaction trans);
    repeat (1) @(iface.cb);
    iface.cb.master_1_req   <=  1'b1;
    iface.cb.master_1_cmd   <=  1'b0;
    iface.cb.master_1_addr  <=  {trans.slave, trans.address};
    repeat (1) @(iface.cb);
    if (trans.slave == 1'b0) begin
      iface.cb.slave_0_ack  <=  1'b1;
      iface.cb.slave_0_rdata<=  trans.data;
    end
    else if (trans.slave == 1'b1) begin
      iface.cb.slave_1_ack  <=  1'b1;
      iface.cb.slave_1_rdata<=  trans.data;
    end
    repeat (1) @(iface.cb);
    iface.cb.slave_0_ack    <=  1'b0;
    iface.cb.slave_1_ack    <=  1'b0;
    iface.cb.master_1_req   <=  1'b0;
    iface.cb.master_1_addr  <=  '0;
    repeat (1) @(iface.cb);
  endtask: master_1_read
  
  task simultaneous_write(transaction trans_0,
                          transaction trans_1);
    repeat (1) @(iface.cb);
    iface.cb.master_0_req   <=  1'b1;
    iface.cb.master_1_req   <=  1'b1;
    iface.cb.master_0_cmd   <=  1'b1;
    iface.cb.master_1_cmd   <=  1'b1;
    iface.cb.master_0_addr  <=  {trans_0.slave, trans_0.address};
    iface.cb.master_1_addr  <=  {trans_1.slave, trans_1.address};
    iface.cb.master_0_wdata <=  trans_0.data;
    iface.cb.master_1_wdata <=  trans_1.data;
    repeat (1) @(iface.cb);
    if (trans_0.slave == 1'b0)
      iface.cb.slave_0_ack  <=  1'b1;
    else if (trans_0.slave == 1'b1)
      iface.cb.slave_1_ack  <=  1'b1;
    if (trans_1.slave == 1'b0)
      iface.cb.slave_0_ack  <=  1'b1;
    else if (trans_1.slave == 1'b1)
      iface.cb.slave_1_ack  <=  1'b1;
    repeat (1) @(iface.cb);
    iface.cb.slave_0_ack    <=  1'b0;
    iface.cb.slave_1_ack    <=  1'b0;
    iface.cb.master_0_req   <=  1'b0;
    iface.cb.master_1_req   <=  1'b0;
    iface.cb.master_0_cmd   <=  1'b0;
    iface.cb.master_1_cmd   <=  1'b0;
    iface.cb.master_0_addr  <=  '0;
    iface.cb.master_1_addr  <=  '0;
    iface.cb.master_0_wdata <=  '0;
    iface.cb.master_1_wdata <=  '0;
    repeat (1) @(iface.cb);
  endtask: simultaneous_write

  task simultaneous_read(transaction trans);
    repeat (1) @(iface.cb);
    iface.cb.master_0_req   <=  1'b1;
    iface.cb.master_1_req   <=  1'b1;
    iface.cb.master_0_cmd   <=  1'b0;
    iface.cb.master_1_cmd   <=  1'b0;
    iface.cb.master_0_addr  <=  {trans.slave, trans.address};
    iface.cb.master_1_addr  <=  {trans.slave, trans.address};
    repeat (1) @(iface.cb);
    if (trans.slave == 1'b0) begin
      iface.cb.slave_0_ack  <=  1'b1;
      iface.cb.slave_0_rdata<=  trans.data;
    end
    else if (trans.slave == 1'b1) begin
      iface.cb.slave_1_ack  <=  1'b1;
      iface.cb.slave_1_rdata<=  trans.data;
    end
    repeat (1) @(iface.cb);
    iface.cb.slave_0_ack    <=  1'b0;
    iface.cb.slave_1_ack    <=  1'b0;
    iface.cb.master_0_req   <=  1'b0;
    iface.cb.master_1_req   <=  1'b0;
    iface.cb.master_0_addr  <=  '0;
    iface.cb.master_1_addr  <=  '0;
    repeat (1) @(iface.cb);
  endtask: simultaneous_read

  task simultaneous_write_read(transaction trans_0,
                               transaction trans_1);
    repeat (1) @(iface.cb);
    iface.cb.master_0_req   <=  1'b1;
    iface.cb.master_1_req   <=  1'b1;
    iface.cb.master_0_cmd   <=  1'b1;
    iface.cb.master_1_cmd   <=  1'b0;
    iface.cb.master_0_addr  <=  {trans_0.slave, trans_0.address};
    iface.cb.master_1_addr  <=  {trans_1.slave, trans_1.address};
    iface.cb.master_0_wdata <=  trans_0.data;
    repeat (1) @(iface.cb);
    if (trans_0.slave == 1'b0)
      iface.cb.slave_0_ack  <=  1'b1;
    else if (trans_0.slave == 1'b1)
      iface.cb.slave_1_ack  <=  1'b1;
    if (trans_1.slave == 1'b0) begin
      iface.cb.slave_0_ack  <=  1'b1;
      iface.cb.slave_0_rdata<=  trans_1.data;
    end
    else if (trans_1.slave == 1'b1) begin
      iface.cb.slave_1_ack  <=  1'b1;
      iface.cb.slave_1_rdata<=  trans_1.data;
    end
    repeat (1) @(iface.cb);
    iface.cb.slave_0_ack    <=  1'b0;
    iface.cb.slave_1_ack    <=  1'b0;
    iface.cb.master_0_req   <=  1'b0;
    iface.cb.master_1_req   <=  1'b0;
    iface.cb.master_0_cmd   <=  1'b0;
    iface.cb.master_0_addr  <=  '0;
    iface.cb.master_1_addr  <=  '0;
    iface.cb.master_0_wdata <=  '0;
    repeat (1) @(iface.cb);
  endtask: simultaneous_write_read

  task simultaneous_read_write(transaction trans_0,
                               transaction trans_1);
    repeat (1) @(iface.cb);
    iface.cb.master_0_req   <=  1'b1;
    iface.cb.master_1_req   <=  1'b1;
    iface.cb.master_0_cmd   <=  1'b0;
    iface.cb.master_1_cmd   <=  1'b1;
    iface.cb.master_0_addr  <=  {trans_0.slave, trans_0.address};
    iface.cb.master_1_addr  <=  {trans_1.slave, trans_1.address};
    iface.cb.master_1_wdata <=  trans_1.data;
    repeat (1) @(iface.cb);
    if (trans_1.slave == 1'b0)
      iface.cb.slave_0_ack  <=  1'b1;
    else if (trans_1.slave == 1'b1)
      iface.cb.slave_1_ack  <=  1'b1;
    if (trans_0.slave == 1'b0) begin
      iface.cb.slave_0_ack  <=  1'b1;
      iface.cb.slave_0_rdata<=  trans_0.data;
    end
    else if (trans_0.slave == 1'b1) begin
      iface.cb.slave_1_ack  <=  1'b1;
      iface.cb.slave_1_rdata<=  trans_0.data;
    end
    repeat (1) @(iface.cb);
    iface.cb.slave_0_ack    <=  1'b0;
    iface.cb.slave_1_ack    <=  1'b0;
    iface.cb.master_0_req   <=  1'b0;
    iface.cb.master_1_req   <=  1'b0;
    iface.cb.master_1_cmd   <=  1'b0;
    iface.cb.master_0_addr  <=  '0;
    iface.cb.master_1_addr  <=  '0;
    iface.cb.master_1_wdata <=  '0;
    repeat (1) @(iface.cb);
  endtask: simultaneous_read_write

  task start();
    transaction trans_0 = new trans_0_temp;
    transaction trans_1 = new trans_1_temp;
    
    reset();
    $fwrite(log, $time, " ns               >>> Start checking single write mode for both Masters\n\n");
    repeat (`NUM_OF_TRANS) begin
      if (trans_0.randomize & trans_1.randomize) begin
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 0\n");
        drv2scb_0.put(trans_0);
        trans_0.display_transaction();
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 1\n");
        drv2scb_1.put(trans_1);
        trans_1.display_transaction();
        master_0_write(trans_0);
        master_1_write(trans_1);
        $fwrite(log, $time, " ns       Driver: Transactions successfully done\n");
        $fwrite(log, $time, " ns\n");
      end else begin
        $fwrite(log, $time, " ns       Driver: *ERROR* Transactions randomization failed\n");
        $display(" %0d Driver : **ERROR: Transactions randomization failed",$time);
        trans_0.errors++;
        trans_1.errors++;
      end
      trans_0.stop = 1;
      trans_1.stop = 1;
    end
    $fwrite(log, "\n");
    $fwrite(log, $time, " ns               >>> Checking single write mode for both Masters has been finished\n\n");
    repeat (8) @(iface.cb);
    
    reset();
    $fwrite(log, $time, " ns               >>> Start checking single read mode for both Masters\n\n");
    repeat (`NUM_OF_TRANS) begin
      if (trans_0.randomize & trans_1.randomize) begin
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 0\n");
        drv2scb_0.put(trans_0);
        trans_0.display_transaction();
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 1\n");
        drv2scb_1.put(trans_1);
        trans_1.display_transaction();
        master_0_read(trans_0);
        master_1_read(trans_1);
        $fwrite(log, $time, " ns       Driver: Transactions successfully done\n");
      end else begin
        $fwrite(log, $time, " ns       Driver: *ERROR* Transactions randomization failed\n");
        $display(" %0d Driver : **ERROR: Transactions randomization failed",$time);
        trans_0.errors++;
        trans_1.errors++;
      end
      trans_0.stop = 1;
      trans_1.stop = 1;
    end
    $fwrite(log, "\n");
    $fwrite(log, $time, " ns               >>> Checking single read mode for both Masters has been finished\n\n");
    repeat (8) @(iface.cb);
    
    reset();
    $fwrite(log, $time, " ns               >>> Start checking simultaneous write mode\n\n");
    repeat (`NUM_OF_TRANS) begin
      if (trans_0.randomize & trans_1.randomize) begin
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 0\n");
        drv2scb_0.put(trans_0);
        trans_0.display_transaction();
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 1\n");
        drv2scb_1.put(trans_1);
        trans_1.display_transaction();
        simultaneous_write(trans_0, trans_1);
        $fwrite(log, $time, " ns       Driver: Transactions successfully done\n");
      end else begin
        $fwrite(log, $time, " ns       Driver: *ERROR* Transactions randomization failed\n");
        $display(" %0d Driver : **ERROR: Transactions randomization failed",$time);
        trans_0.errors++;
        trans_1.errors++;
      end
      trans_0.stop = 1;
      trans_1.stop = 1;
    end
    $fwrite(log, "\n");
    $fwrite(log, $time, " ns               >>> Checking simultaneous write mode has been finished\n\n");
    repeat (8) @(iface.cb);

    reset();
    $fwrite(log, $time, " ns               >>> Start checking simultaneous read mode\n\n");
    repeat (`NUM_OF_TRANS) begin
      if (trans_0.randomize) begin
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 0\n");
        drv2scb_0.put(trans_0);
        trans_0.display_transaction();
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 1\n");
        drv2scb_1.put(trans_0);
        trans_0.display_transaction();
        simultaneous_read(trans_0);
        $fwrite(log, $time, " ns       Driver: Transactions successfully done\n");
      end else begin
        $fwrite(log, $time, " ns       Driver: *ERROR* Transactions randomization failed\n");
        $display(" %0d Driver : **ERROR: Transactions randomization failed",$time);
        trans_0.errors++;
      end
      trans_0.stop = 1;
    end
    $fwrite(log, "\n");
    $fwrite(log, $time, " ns               >>> Checking simultaneous read mode has been finished\n\n");
    repeat (8) @(iface.cb);
    
    reset();
    $fwrite(log, $time, " ns               >>> Start checking simultaneous write read mode\n\n");
    repeat (`NUM_OF_TRANS) begin
      if (trans_0.randomize & trans_1.randomize) begin
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 0\n");
        drv2scb_0.put(trans_0);
        trans_0.display_transaction();
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 1\n");
        drv2scb_1.put(trans_1);
        trans_1.display_transaction();
        simultaneous_write_read(trans_0, trans_1);
        $fwrite(log, $time, " ns       Driver: Transactions successfully done\n");
      end else begin
        $fwrite(log, $time, " ns       Driver: *ERROR* Transactions randomization failed\n");
        $display(" %0d Driver : **ERROR: Transactions randomization failed",$time);
        trans_0.errors++;
        trans_1.errors++;
      end
      trans_0.stop = 1;
      trans_1.stop = 1;
    end
    $fwrite(log, "\n");
    $fwrite(log, $time, " ns               >>> Checking simultaneous write read mode has been finished\n\n");
    repeat (8) @(iface.cb);
    
    reset();
    $fwrite(log, $time, " ns               >>> Start checking simultaneous read write mode\n\n");
    repeat (`NUM_OF_TRANS) begin
      if (trans_0.randomize & trans_1.randomize) begin
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 0\n");
        drv2scb_0.put(trans_0);
        trans_0.display_transaction();
        $fwrite(log, $time, " ns       Driver: Try to generate transaction for Master 1\n");
        drv2scb_1.put(trans_1);
        trans_1.display_transaction();
        simultaneous_read_write(trans_0, trans_1);
        $fwrite(log, $time, " ns       Driver: Transactions successfully done\n");
      end else begin
        $fwrite(log, $time, " ns       Driver: *ERROR* Transactions randomization failed\n");
        $display(" %0d Driver : **ERROR: Transactions randomization failed",$time);
        trans_0.errors++;
        trans_1.errors++;
      end
      trans_0.stop = 1;
      trans_1.stop = 1;
    end
    $fwrite(log, "\n");
    $fwrite(log, $time, " ns               >>> Checking simultaneous read write mode has been finished\n\n");
    repeat (8) @(iface.cb);

  endtask: start
endclass: driver

`endif
