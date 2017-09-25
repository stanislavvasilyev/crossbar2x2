`ifndef _TRANSACTION_
`define _TRANSACTION_

class transaction;

  static int errors = 0;
  static bit stop = 0;
  int log;

  rand bit        slave;
  rand bit [30:0] address;
  rand bit [31:0] data;

  bit             receive_slave;
  bit [30:0]      receive_address;
  bit [31:0]      receive_data;

  constraint c_data {
    data    inside { 4'b1010, 4'b1011, 4'b1100, 4'b1101, 4'b1110, 4'b1111 }; // 'a', 'b', 'c', 'd', 'e', 'f'
  }
  
  constraint c_address {
    address inside { 8'b10101010, 8'b10111011, 8'b11001100, 8'b11011101,
                     8'b11101110, 8'b11111111 };                             // 'aa', 'bb', 'cc', 'dd', 'ee', 'ff'
  }
  
  virtual function void display_transaction();
    log = $fopen("log.txt");
    $display("Transaction is: Slave %b, address = %h, data = %h",
                              slave,    address,      data);
    $fwrite(log, $time, " ns               Transaction is: Slave = %b, address = %h, data = %h\n",
                              slave,    address,      data);
  endfunction : display_transaction
  
  virtual function void display_inputs();
    $display(" Transaction inputs: slave = %b, address = %h, data = %h",
                                   slave,      address,      data);
  endfunction : display_inputs
 
  virtual function string display_outputs();
    $swrite(display_outputs, "Receive: slave = %b, address = %h, data = %h",
                              receive_slave <= slave, receive_address <= address, receive_data <= data);
  endfunction : display_outputs
 
  virtual function bit compare(transaction trans);
    compare = 1;
 
    if (trans == null) begin
      $display(" ** ERROR ** Transaction : received a null object ");
      compare = 0;
    end else begin
      if(trans.receive_slave !== this.receive_slave) begin
        $display(" ** ERROR ** Transaction : slave did not match");
        compare = 0;
      end
      if(trans.receive_address !== this.receive_address) begin
        $display(" ** ERROR ** Transaction : address did not match");
        compare = 0;
      end
      if(trans.receive_data !== this.receive_data) begin
        $display(" ** ERROR ** Transaction : data did not match");
        compare = 0;
      end
    end
  endfunction : compare

endclass: transaction

`endif
