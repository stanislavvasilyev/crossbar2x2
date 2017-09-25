`ifndef _ENVIRONMENT_
`define _ENVIRONMENT_

`include "globals.sv"
`include "transaction.sv"
`include "driver.sv"
`include "scoreboard.sv"

class environment;

  virtual input_inter.input_ports     iface[`NUM_OF_DUTS];
  virtual output_inter.output_ports   oface[`NUM_OF_DUTS];
  
  driver                  drv[`NUM_OF_DUTS];
  scoreboard              scb[`NUM_OF_DUTS];
  mailbox #(transaction)  drv2scb_0;
  mailbox #(transaction)  drv2scb_1;
  
  int log;
  
  function new(virtual input_inter  iface_new[`NUM_OF_DUTS],
               virtual output_inter oface_new[`NUM_OF_DUTS]);
    this.iface    = iface_new;
    this.oface    = oface_new;
    $display(" %0d : Environment : constructor created object",$time);
  endfunction : new
  
 task wait_for_end();
    $display(" %0d : Environment : start of wait_for_end() method",$time);
    foreach(iface[i])
      repeat (10) @(iface[i].clock);
    $display(" %0d : Environment : end of wait_for_end() method",$time);
  endtask : wait_for_end
  
  task build();
    $display(" %0d : Environment : start of build() method",$time);
    drv2scb_0 = new();
    drv2scb_1 = new();
    foreach(drv[i])
      drv[i] = new(iface[i], oface[i], drv2scb_0, drv2scb_1);
    foreach(scb[i])
      scb[i] = new(iface[i], oface[i], drv2scb_0, drv2scb_1);
  endtask: build
 
  task start();
    $display(" %0d : Environment : start of start() method",$time);
    foreach(drv[i]) begin
      fork
        drv[i].start();
        scb[i].start();
      join_any
      $display(" %0d : Environment : end of start() method",$time);
    end
  endtask : start
 
  task report();
    transaction trans;
    $display(" %0d : Environment : start of report() method",$time);
    $display("=====================================");
    if (trans.errors)
      begin
        $display(" Test completed with %d trans error", trans.errors);
        $fwrite(log, $time, " ns  Test completed with %d transaction errors\n\n", trans.errors);
      end
    else
      begin
        $display(" Test completed without errors");
        $fwrite(log, $time, " ns  Test completed without errors\n\n");
      end
    $display("=====================================");
    $display(" %0d : Environment : end of report() method",$time);
    $fwrite(log, "                                                 *** END TESTBENCH ***\n");
    $fclose("log.txt");
  endtask : report
 
  task run();
    log = $fopen("log.txt");
    $fwrite(log, $time, " ns  Environment: Start building environment for the DUT\n");
    $display(" %0d : Environment : start of run() method",$time);
    build();
    $fwrite(log, $time, " ns  Environment: Driver, Scoreboard and mailbox has been created\n");
    $fwrite(log, $time, " ns  Environment: Driver starting...\n");
    start();
    wait_for_end();
    $fwrite(log, $time, " ns  Environment: Preparing for the end of testbench\n");
    report();  
    $display(" %0d : Environment : end of run() method",$time);
  endtask : run

endclass: environment

`endif
