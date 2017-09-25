`ifndef _SCOREBOARD_
`define _SCOREBOARD_

`include "transaction.sv"
`include "globals.sv"

class scoreboard;
  virtual input_inter.input_ports iface;
  virtual output_inter.output_ports oface;
  
  mailbox #(transaction) drv2scb_0;
  mailbox #(transaction) drv2scb_1;
  
  int log;

  function new(virtual input_inter.input_ports iface_new,
               virtual output_inter.output_ports oface_new,
               mailbox #(transaction) drv2scb_0,
               mailbox #(transaction) drv2scb_1);
    this.iface = iface_new;
    this.oface = oface_new;
    this.drv2scb_0 = drv2scb_0;
    this.drv2scb_1 = drv2scb_1;
  endfunction : new
  
  task start();
    transaction trans[2];
    bit slave_0, slave_1;
    bit [30:0] address_0, address_1;
    bit [31:0] data_0, data_1;
    
    log = $fopen("log.txt");
    
    forever begin
        drv2scb_0.get(trans[0]);
        drv2scb_1.get(trans[1]);
        $fwrite(log, $time, " ns   Scoreboard: Get transactions from Driver\n");
        trans[0].display_transaction();
        trans[1].display_transaction();
        $display(" %0d : Scoreboard : Transactions received ",$time);
        $display(" %0d : Scoreboard : OLD scheme outputs: \n %s ", $time, trans[0].display_outputs());
        $display(" %0d : Scoreboard : OLD scheme outputs: \n %s ", $time, trans[1].display_outputs());
        if (trans[0].compare(trans[0])) begin
            $display(" %0d : Scoreboard : Valid outputs ",$time);
        end else begin
            $display(" %0d : Scoreboard : **ERROR: Unequal outputs ",$time);
            trans[0].errors++;
        end
        if (trans[1].compare(trans[1])) begin
            $display(" %0d : Scoreboard : Valid outputs ",$time);
        end else begin
            $display(" %0d : Scoreboard : **ERROR: Unequal outputs ",$time);
            trans[1].errors++;
        end
    end
 
  endtask : start
endclass: scoreboard

`endif
