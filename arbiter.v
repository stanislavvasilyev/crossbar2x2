module arbiter(
  input             clock,
  input             reset,
  
  input [1:0]       request,
  input [1:0]       acknowledge,
  
  output reg [1:0]  grant
);

reg       R_rr;                       // Change bit for 'round-robin'
reg [1:0] R_grant_temp;               // Temporary register for grant access
reg [1:0] R_shift_req, R_shift_grant; // Operational registers for change priority

always @(posedge clock)
begin
  case(R_rr)
    1'b0: R_shift_req = request;
    1'b1: R_shift_req = {request[0], request[1]};
  endcase
end

always @(posedge clock)
begin
  R_shift_grant[1:0]  = 2'b0;
  if (R_shift_req[0])
    R_shift_grant[0]  = 1'b1;
  else if (R_shift_req[1])
    R_shift_grant[1]  = 1'b1;
end

always @(posedge clock)
begin
  case(R_rr)
    1'b0: R_grant_temp[1:0] = R_shift_grant[1:0];
    1'b1: R_grant_temp[1:0] = {R_shift_grant[0], R_shift_grant[1]};
  endcase
end

always @(posedge clock or posedge reset)
begin
  if (reset)
    begin
      grant <=  2'b0;
      R_rr  <=  1'b0;
      R_grant_temp <= 2'b0;
      R_shift_req <= 2'b0;
      R_shift_grant <= 2'b0;
    end
  else
    begin
      grant[1:0]  <=  R_grant_temp[1:0] & ~grant[1:0];
      
      if ((grant & request) && !(grant & acknowledge))
        grant  <=  grant;
      else
        begin
          case(1'b1)
            grant[0]: R_rr  <=  1'b1;
            grant[1]: R_rr  <=  1'b0;
          endcase
        end
    end
end

endmodule
