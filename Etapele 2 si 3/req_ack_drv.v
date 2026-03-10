module req_ack_drv (
    input        clk_i,
    input        rst_n,
    input        ack_i,
    input  [7:0] rd_data_i,
	 
	 
	 output reg signed [7:0] x_o,
	 output reg signed [7:0] y_o,
    output reg   req_o,
    output reg   rw_no,
	 output reg   [7:0] wr_data_o,
    output reg   [5:0] addr_o,
	 output reg [7:0] LEDR
);

localparam IDLE = 3'd0;
localparam REQ_STARTUP = 3'd1;
localparam REQ_DATA_FORMAT = 3'd2;
localparam REQ_POWER_CTL = 3'd3;
localparam REQ_X = 3'd4;
localparam REQ_Y = 3'd5;
localparam BUFFER = 3'd6;

reg [2:0] stare;


reg signed [7:0] x_m;
reg signed [7:0] y_m;
wire signed [7:0] x_s;


always @(posedge clk_i or negedge rst_n)
  if (~rst_n)
    stare <= IDLE;
  else
	case(stare)
		IDLE:
		stare <= REQ_STARTUP;
		REQ_STARTUP: 
		if(ack_i)
		stare <= REQ_DATA_FORMAT;
		REQ_DATA_FORMAT: 
		if(ack_i)
		stare <= REQ_POWER_CTL;
		REQ_POWER_CTL: 
		if(ack_i)
		stare <= REQ_X;
		REQ_X: 
		if(ack_i)
		stare <= REQ_Y;
		REQ_Y: 
		if (ack_i)
		stare <= BUFFER;
		BUFFER: stare <= REQ_X;
		default: stare <= IDLE;
	endcase


always @(posedge clk_i or negedge rst_n)
    if (~rst_n)        
        req_o <= 1'b0;
    else if (ack_i) 
		  req_o <= 1'b0;
	 else
	 case(stare)
		 REQ_STARTUP: req_o <= 1'b1;
		 REQ_DATA_FORMAT: req_o <= 1'b1;
		 REQ_POWER_CTL: req_o <= 1'b1;
		 REQ_X: req_o <= 1'b1;
		 REQ_Y: req_o <= 1'b1;
		 default: req_o <= 1'b0;
	 endcase

		  
always @(posedge clk_i or negedge rst_n)
	if (~rst_n)
		addr_o <= 6'h0;
	else if (ack_i)
		addr_o <= 6'h0; 
	else
	case(stare)
		IDLE: addr_o <= 6'h0;
		REQ_STARTUP: addr_o <= 6'h2D;
		REQ_DATA_FORMAT: addr_o <= 6'h31;
		REQ_POWER_CTL: addr_o <= 6'h2D;
		REQ_X: addr_o <= 6'h33;
		REQ_Y: addr_o <= 6'h35;
		default: addr_o <= 6'h0;
	endcase


always @(posedge clk_i or negedge rst_n)
	if (~rst_n)
		rw_no <= 1'b0;
	else if (ack_i)
		rw_no <= 1'b0;
	else
	case(stare)
	   IDLE: rw_no <= 1'b0;
      REQ_STARTUP: rw_no <= 1'b0;
      REQ_DATA_FORMAT: rw_no <= 1'b0;
      REQ_POWER_CTL: rw_no <= 1'b0;
      REQ_X: rw_no <= 1'b1;
      REQ_Y: rw_no <= 1'b1;
	   default: rw_no <= 1'b0;
	endcase


always @(posedge clk_i or negedge rst_n)
	if(~rst_n)
		wr_data_o <= 8'b0;
	else if(ack_i)
		wr_data_o <= 8'b0;
	else
	case(stare)
		IDLE: wr_data_o <= 8'b0;
		REQ_STARTUP: wr_data_o <= 8'b0;
		REQ_DATA_FORMAT: wr_data_o <= 8'b01000101;
		REQ_POWER_CTL: wr_data_o <= 8'b00001000;
		REQ_X: wr_data_o <= 8'b0;
		REQ_Y: wr_data_o <= 8'b0;
		default: wr_data_o <= 8'b0;
	endcase


always @(posedge clk_i or negedge rst_n) 
if(~rst_n)
	x_o <= 8'b0;
else if(stare == BUFFER)
	x_o <= x_m;


always @(posedge clk_i or negedge rst_n)
if(~rst_n)
	y_o <= 8'b0;
else if(stare == BUFFER)
	y_o <= y_m;


always @(posedge clk_i or negedge rst_n) 
if(~rst_n)
	x_m <= 8'b0;
else if(stare == REQ_X)
		if(ack_i)
			x_m <= rd_data_i;


always @(posedge clk_i or negedge rst_n) 
if(~rst_n)
	y_m <= 8'b0;
else if(stare == REQ_Y)
			if(ack_i)
				y_m <= rd_data_i;

	
endmodule