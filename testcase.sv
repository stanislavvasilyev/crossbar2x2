`include "environment.sv"
`include "globals.sv"

program automatic testcase(
    input_inter.input_ports   iface[`NUM_OF_DUTS],
    output_inter.output_ports oface[`NUM_OF_DUTS]
);
 
  environment env;
  
  int log;
  
  initial begin
    log = $fopen("log.txt");
    $fwrite(log, "                                                *** START TESTBENCH ***\n\n");
    $display(" Start of program block testcase");
    env = new(iface, oface);
    env.run();
    $display(" End of program block testcase");
    $finish;
  end
endprogram
