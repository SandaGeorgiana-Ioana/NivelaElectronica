module ball(
	 input signed [7:0] x_i,
	 input signed [7:0] y_i,
	 output signed [2:0] column,
	 output 	     row
);

wire signed [7:0] x_s;


assign x_s = (x_i >>> 3) + 'sd3;
assign column = (x_s > 'sd5) ? 'sd5 : ((x_s < 'sd0) ? 'sd0 : x_s);

assign row = y_i[7];

endmodule

