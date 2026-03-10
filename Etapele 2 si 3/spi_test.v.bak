module spi_test #(
parameter WIDTH   = 'd48 
)(
input 		  clk	    ,
input 		  rst_n	 ,

output [47:0] seg7_pins ,
output        spi_cs_no ,
output        spi_clk_o ,
output        spi_data_o,
output [7:0]  LEDR,
inout         spi_data_i	  
);


spi_pll i_spi_pll(
.areset      (~rst_n	 				),
.inclk0      (clk	         		),
.c0	       (clk_pll				),
.c1	       (sclk					),
.locked      (locked 				)
);

req_ack_drv i_req_ack_drv(
.rst_n		 (rst_n					),
.clk_i		 (clk_pll			   ),
.addr_o	    (addr_o     	    	),
.req_o		 (req_o			  		),
.rw_no		 (rw_no					),
.ack_i		 (ack_i					),
.rd_data_i   (rd_data_i				),
.wr_data_o   (wr_data_o				),
.x_o		 	 (x_o						),
.y_o		    (y_o						)
);

ball	i_ball(
.x_i		   (x_o							),
.y_i			(y_o 							),
.column     (column						),
.row			(row							),
);


led_to_7seg #(
.WIDTH(WIDTH)
)i_led_to_7seg(
.clk_i		(clk_pll					),
.rst_n		(rst_n					),
.column_i	(column    				),
.row_i		(row     				),
.seg7_pins  (seg7_pins				)  
);

spi_phy i_spi_phy(
.req_i       (req_o			   	),
.rw_ni		 (rw_no					),
.addr_i		 (addr_o			      ),
.wr_data_i	 (wr_data_o				),
.ack_o		 (ack_i					),
.rd_data_o   (rd_data_i				),
.rst_n	    (rst_n		        	),
.clk_i	    (clk_pll 	 			),
.spi_clk_i   (sclk		 		   ),
.spi_clk_o   (spi_clk_o			   ),
.spi_data_o  (spi_data_o			),
.spi_data_i	 (spi_data_i 			),
.spi_cs_no   (spi_cs_no	   		),
.spi_oe_o	 (spi_oe_o				)
);

//=======================================================
//  Structural coding
//=======================================================
wire [7:0] rd_data_i;
wire [7:0] wr_data_o;
wire signed [3:0] column;
wire signed row;
wire signed [7:0] x_o;
wire signed [7:0] y_o;
wire [5:0] addr_o;


endmodule
