`include "cmd_bram.v"
`include "param_bram.v"
`include "gba_bw_intro_b1ram.v"
`include "gba_bw_intro_b2ram.v"
`include "gba_bw_intro_b3ram.v"
`include "gba_bw_intro_b4ram.v"

module demo(
  input CLK,
  output RST,
  output SCL,
  output DC,
  output MOSI,
  output CS
 );

 // LCD Command names from Pulse View
 localparam SLPOUT  = 8'h11;
 localparam FRMCTR1 = 8'hB1;
 localparam FRMCTR2 = 8'hB2;
 localparam FRMCTR3 = 8'hB3;
 localparam INVCTR  = 8'hB4;
 localparam PWCTR1  = 8'hC0;
 localparam PWCTR2  = 8'hC1;
 localparam PWCTR3  = 8'hC2;
 localparam PWCTR4  = 8'hC3;
 localparam PWCTR5  = 8'hC4;
 localparam VMCTR1  = 8'hC5;
 localparam GMCTRP1 = 8'hE0;
 localparam GMCTRN1 = 8'hE1;
 localparam PWCTR6  = 8'hFC;
 localparam COLMOD  = 8'h3A;
 localparam MADCTL  = 8'h36;
 localparam INVON   = 8'h21;
 localparam DISPON  = 8'h29;
 localparam CASET   = 8'h2A;
 localparam RASET   = 8'h2B;
 localparam RAMWR   = 8'h2C;

 localparam init = 6'd0;
 localparam actRst = 6'd1;
 localparam drst = 6'd2;
 localparam ddrst = 6'd3;
 localparam lc = 6'd4;
 localparam ldc = 6'd5;
 localparam sm = 6'd6;
 localparam lcs = 6'd7;
 localparam slb = 6'd8;
 localparam rcs = 6'd9;
 localparam send = 6'd10;
 localparam rdc = 6'd11;
 localparam lp = 6'd12;
 localparam dsleep = 6'd13;

 localparam actRst_d = 16'd23817;
 localparam dactRst_d = 16'd20858;
 localparam sleep = 16'd20848;

 //********* FSM internal registers ********

 reg [5:0] state;
 reg [15:0] delay;

 //********* END FSM internal registers ****

 //********* SPI signals/buffers ***********

 reg rst, scl, dc, mosi, cs;

 reg [7:0] data;
 reg [2:0] bit_counter; 
 
 reg [15:0] pixel_data;
 reg [3:0] pixel_bit_counter;

 reg [2:0] bw_pxls_ptr;
 reg [7:0] byte_of_bw_pxls;

 //********* END SPI signals/buffers *******

 //********* CMD BRAM inputs ***************
 reg cb_rd_en;
 reg [4:0] cb_rd_addr;
 //********* END CMD BRAM inputs ***********
 
 //********* CMD BRAM outputs **************
 wire [7:0] cb_data_out;
 wire cb_valid; 
 //********* END CMD BRAM outputs **********

 //********* PARAM BRAM inputs *************
 reg pb_rd_en;
 reg [6:0] pb_rd_addr;
 //********* END PARAM BRAM inputs *********
 
 //********* PARAM BRAM outputs ************
 wire [7:0] pb_data_out;
 wire pb_valid;
 //********* END PARAM BRAM outputs ********

 //********* GBA_B1RAM BRAM inputs *********
 reg b1_rd_en;
 reg [8:0] b1_rd_addr;
 //********* END GBA_B1RAM BRAM inputs *****

 //********* GBA_B1RAM BRAM outputs ********
 wire [7:0] b1_data_out;
 wire b1_valid;
 //********* END GBA_B1RAM BRAM outputs ****

 //********* GBA_B2RAM BRAM inputs *********
 reg b2_rd_en;
 reg [8:0] b2_rd_addr;
 //********* END GBA_B2RAM BRAM inputs *****

 //********* GBA_B2RAM BRAM outputs ********
 wire [7:0] b2_data_out;
 wire b2_valid;
 //********* END GBA_B2RAM BRAM outputs ****

 //********* GBA_B3RAM BRAM inputs *********
 reg b3_rd_en;
 reg [8:0] b3_rd_addr;
 //********* END GBA_B3RAM BRAM inputs *****
                                            
 //********* GBA_B3RAM BRAM outputs ********
 wire [7:0] b3_data_out;
 wire b3_valid;
 //********* END GBA_B3RAM BRAM outputs ****

 //********* GBA_B4RAM BRAM inputs *********
 reg b4_rd_en;
 reg [5:0] b4_rd_addr;
 //********* END GBA_B4RAM BRAM inputs *****
                                            
 //********* GBA_B4RAM BRAM outputs ********
 wire [7:0] b4_data_out;
 wire b4_valid;
 //********* END GBA_B4RAM BRAM outputs ****

 //********* BRAM finish signals ***********
 reg b1_fin;
 reg b2_fin;
 reg b3_fin;
 reg b4_fin;
 //********* END BRAM finish signals *******

 // Keep track of how many parameters each lcd cmd has
 reg [13:0] params_left;

 //************ CMD BRAM instantiation *************
 cmd_bram cmd_bram_inst(
  .clk(CLK),
  .rd_en(cb_rd_en),
  .rd_addr(cb_rd_addr),
  .data_out(cb_data_out),
  .valid_out(cb_valid)
 );
 //************ END CMD BRAM instantiation *********

 //************ PARAM BRAM instantiation ***********
 param_bram param_bram_inst(
  .clk(CLK),
  .rd_en(pb_rd_en),
  .rd_addr(pb_rd_addr),
  .data_out(pb_data_out),
  .valid_out(pb_valid)
 );
 //************ END PARAM BRAM instantiation *******

 //************ GBA BW Intro B1RAM Inst. ***********
 gba_bw_intro_b1ram gba_bw_intro_b1ram_inst(
  .clk(CLK),
  .rd_en(b1_rd_en),
  .rd_addr(b1_rd_addr),
  .data_out(b1_data_out),
  .valid_out(b1_valid)
 ); 
 //************ END GBA BW Intro B1RAM Inst. *******

 //************ GBA BW Intro B2RAM Inst. ***********
 gba_bw_intro_b2ram gba_bw_intro_b2ram_inst(
  .clk(CLK),
  .rd_en(b2_rd_en),
  .rd_addr(b2_rd_addr),
  .data_out(b2_data_out),
  .valid_out(b2_valid)
 ); 
 //************ END GBA BW Intro B2RAM Inst. *******

 //************ GBA BW Intro B3RAM Inst. ***********
 gba_bw_intro_b3ram gba_bw_intro_b3ram_inst(
  .clk(CLK),
  .rd_en(b3_rd_en),
  .rd_addr(b3_rd_addr),
  .data_out(b3_data_out),
  .valid_out(b3_valid)
 ); 
 //************ END GBA BW Intro B3RAM Inst. *******

 //************ GBA BW Intro B4RAM Inst. ***********
 gba_bw_intro_b4ram gba_bw_intro_b4ram_inst(
  .clk(CLK),
  .rd_en(b4_rd_en),
  .rd_addr(b4_rd_addr),
  .data_out(b4_data_out),
  .valid_out(b4_valid)
 ); 
 //************ END GBA BW Intro B4RAM Inst. *******


 initial
 begin
  //******** Initialize FSM internal registers *******
  state = init;
  delay = 16'd0;
  //******** End Initialization of FSM internal reg. *

  //******** Initialize SPI signals/buffers **********
  rst = 1'b1;
  scl = 1'b1;
  dc = 1'b1;
  mosi = 1'b1;
  cs = 1'b1;

  data = 8'h00;
  bit_counter = 3'b111;
                               
  pixel_data = 16'h00_00;
  pixel_bit_counter = 4'b1111;

  bw_pxls_ptr = 3'b111;
  byte_of_bw_pxls = 8'b0000_1111;
  //******** End Initialization of SPI signals/buffers

  //******** Initialize cmd_bram internal ports ******
  cb_rd_en = 1'b0;
  cb_rd_addr = 5'd0;
  //******** End Initialization of cmd_bram ports ****

  //******** Initialize param_bram internal ports ****
  pb_rd_en = 1'b0;
  pb_rd_addr = 7'd0;
  //******** End initialization of param_bram ports **

  //******** Initialize gba_b1ram internal ports *****
  b1_rd_en = 1'b0;//4 simplicity
  b1_rd_addr = 9'd0;
  //******** End Initialization of gba_b1ram ports ***

  //******** Initialize gba_b2ram internal ports *****
  b2_rd_en = 1'b0;//4 simplicity
  b2_rd_addr = 9'd0;
  //******** End Initialization of gba_b2ram ports ***

  //******** Initialize gba_b3ram internal ports *****
  b3_rd_en = 1'b0;//4 simplicity
  b3_rd_addr = 9'd0;
  //******** End Initialization of gba_b3ram ports ***

  //******** Initialize gba_b4ram internal ports *****
  b4_rd_en = 1'b0;//4 simplicity
  b4_rd_addr = 6'd0;
  //******** End Initialization of gba_b4ram ports ***

  //******** Initialize bram finish signals **********
  b1_fin = 1'b0;
  b2_fin = 1'b0;
  b3_fin = 1'b0;
  b4_fin = 1'b0;
  //******** End Initialize bram finish signals ****** 


  // Initialize total remaining parameters to 0
  params_left = 14'd0;
 end

 /*
 * Always on positive edge of clock:
 	* toggle the serial clock signal
 */
 always@(posedge CLK)
 begin
  
  scl <= ~scl;

 end

 /*
 * Always on positive edge of clock:
	 * control LCD FSM
 */
 always@(posedge CLK)
 begin
  /*
  * LCD FSM
  */
  case(state)

   /*
   * init - Initializes all necessary internal signals & reg
   *  regardless of being in initial block or not
   * 
   * next state - unconditional actRst
   */
   init: 
   begin

    rst <= 1'b1;
    dc <= 1'b0;//initialize to low
    mosi <= 1'b0;//initialize to low
    cs <= 1'b1;
    state <= actRst;
    delay <= 16'd0;

   end

   /*
   * actRst - activates active low lcd reset signal
   *
   * next state - unconditional drst   
   */
   actRst: 
   begin

    rst <= 1'b0;
    state <= drst;

   end

   /*
   * drst - delays for actRst_d cycles, then deactivates reset
   *
   * next state - [delay less than or equal to actRst_d] drst
   * next state - [delay greater than actRst_d] ddrst
   */
   drst: 
   begin

    if(delay <= actRst_d)
    begin
     delay <= delay + 16'd1; 
    end
    else
    begin
     rst <= 1'b1;
     delay <= 16'd0;
     state <= ddrst;
    end

   end

   /*
   * ddrst - delays dactRst_d cycles,
	   * resets delay register,
	   * enables cmd_bram read signal
   * next state - [delay less than or equal to dactRst_d] ddrst
   * next state - [delay greater than dactRst_d] lc 
   */
   ddrst: 
   begin

    if(delay <= dactRst_d)
    begin
     delay <= delay + 16'd1;
    end
    else
    begin
     delay <= 16'd0;
     cb_rd_en <= 1'b1;// Set read enable line
     state <= lc;
    end

   end

   /*
   * lc - load command state,
	   *disable cmd bram read,
	   *set cmd to data buffer,
	   *point to next cmd in cmd_bram,
	   *set proper number of params based on cmd value
   * next state - [cmd is not valid] lc
   * next state - [cmd is valid and not NOP] ldc
   * next state - [cmd is valid and NOP] lc
   */
   lc: 
   begin
    // We should check for valid cmd data for cb_data_out
    if(cb_valid == 1'b0) //If cmd is not valid
    begin
     state <= lc;
    end
    else
    begin
     cb_rd_en <= 1'b0; // Disable cmd bram read
     data <= cb_data_out;
     cb_rd_addr <= cb_rd_addr + 5'd1;// point to next cmd
     state <= ldc;// lower dc line to signify cmd byte
     case(cb_data_out)// case switch for all cmd entries
      SLPOUT  : params_left <= 14'h00;
      FRMCTR1 : params_left <= 14'h03;
      FRMCTR2 : params_left <= 14'h03;
      FRMCTR3 : params_left <= 14'h06;
      INVCTR  : params_left <= 14'h01;
      PWCTR1  : params_left <= 14'h03;
      PWCTR2  : params_left <= 14'h01;
      PWCTR3  : params_left <= 14'h02;
      PWCTR4  : params_left <= 14'h02;
      PWCTR5  : params_left <= 14'h02;
      VMCTR1  : params_left <= 14'h01;
      GMCTRP1 : params_left <= 14'h10;
      GMCTRN1 : params_left <= 14'h10;
      PWCTR6  : params_left <= 14'h01;
      COLMOD  : params_left <= 14'h01;
      MADCTL  : params_left <= 14'h01;
      INVON   : params_left <= 14'h00;
      DISPON  : params_left <= 14'h00;
      CASET   : params_left <= 14'h04;
      RASET   : params_left <= 14'h04;
      RAMWR   : params_left <= 14'd12800;
      default : begin
       params_left <= 14'h00;
       state <= lc; // return to lc state on NOP
      end
     endcase                               
    end
 
   end

   /*
   * ldc - lower data command signal
   *
   * next state - unconditional sm 
   */
   ldc: 
   begin

    dc <= 1'b0;
    state <= sm;

   end

   /*
   * sm - set mosi bit,
	   * either a pixel bit,
	   * or standard cmd/param bit,
	   * decrement their respective bit pointers
   * next state - [param & RAMWR + first pixel bit] lcs
   * next state - [param & RAMWR + last pixel bit] slb
   * next state - [param & RAMWR] send
   * next state - [not param & RAMWR + first data bit] lcs
   * next state - [not param & RAMWR + last data bit] slb
   * next state - [not param & RAMWR] send
   */ 
   sm: 
   begin

    if(dc == 1'b1 && cb_data_out == RAMWR)
    begin
     if(pixel_bit_counter == 4'b1111)
     begin
      state <= lcs;
     end
     else if(pixel_bit_counter == 4'b0000)
     begin
      state <= slb;
      pixel_bit_counter <= 4'b1111;
     end
     else
     begin
      state <= send;
     end

     mosi <= pixel_data[pixel_bit_counter];
     pixel_bit_counter <= pixel_bit_counter - 4'b0001;
    end
    else
    begin
     if(bit_counter == 3'b111)
     begin
      state <= lcs;
     end
     else if(bit_counter == 3'b000)
     begin
      state <= slb;
      bit_counter <= 3'b111;
     end
     else
     begin
      state <= send;
     end

     mosi <= data[bit_counter];
     bit_counter <= bit_counter - 3'b001;
    end
 
   end

   /*
   * lcs - lower chip select on falling edge of scl
   *
   * next state - [scl is high] send
   * next state - [scl is low] lcs
   */
   lcs: 
   begin

    if(scl == 1'b1)
    begin
     cs <= 1'b0;
     state <= send;
    end
    else
    begin
     state <= lcs;
    end

   end

   /*
   * send - sends the current mosi bit through SPI (raise scl)
   *
   * next state - [scl is high] sm
   * next state - [scl is low] send 
   */
   send: 
   begin

    if(scl == 1'b1)
    begin
     state <= sm;
    end
    else
    begin
     state <= send;
    end

   end

   /*
   * slb - set last bit of SPI data
   *
   * next state - [scl is high] rcs
   * next state - [scl is low] slb
   */
   slb: 
   begin

    if(scl == 1'b1)
    begin
     state <= rcs;
    end
    else
    begin
     state <= slb;
    end

   end

   /*
   * rcs - raise chip select on completion of SPI transaction
   *
   * next state - [dc is low] rdc
   * next state - [dc is high] lp
   */
   rcs: 
   begin
   
    cs <= 1'b1;
    if(dc == 1'b0)
    begin
     if(cb_data_out == SLPOUT)
     begin
      state <= dsleep;
     end
     else
     begin
      state <= rdc;
     end
    end
    else
    begin
     pb_rd_en <= 1'b1;//Enable param_bram read
     if(cb_data_out == RAMWR)
     begin
      
      if(!b1_fin)
      begin
       b1_rd_en <= 1'b1;
      end
      else if(!b2_fin)
      begin
       b1_rd_en <= 1'b0;
       b2_rd_en <= 1'b1;
      end
      else if(!b3_fin)
      begin
       b1_rd_en <= 1'b0;
       b2_rd_en <= 1'b0;
       b3_rd_en <= 1'b1;
      end
      else if(!b4_fin)
      begin
       b1_rd_en <= 1'b0;
       b2_rd_en <= 1'b0;
       b3_rd_en <= 1'b0;
       b4_rd_en <= 1'b1;
      end
      //end
      //else
      //begin
      // b2_rd_en <= 1'b1;
      // b1_rd_en <= 1'b0;
      //end
     end
     state <= lp;
    end
   
   end

   /*
   * rdc - raises data command SPI line
   *
   * next state - unconditional lp
   */
   rdc: 
   begin

    dc <= 1'b1;
    pb_rd_en <= 1'b1; //Enable param_bram read
    if(cb_data_out == RAMWR)
    begin
    // if(b1_rd_addr != 9'd511)
    // begin
     if(!b1_fin)
     begin
      b1_rd_en <= 1'b1;
     end
     else if(!b2_fin)
     begin
      b1_rd_en <= 1'b0;
      b2_rd_en <= 1'b1;
     end
     else if(!b3_fin)
     begin
      b1_rd_en <= 1'b0;
      b2_rd_en <= 1'b0;
      b3_rd_en <= 1'b1;
     end
     else if(!b4_fin)
     begin
      b1_rd_en <= 1'b0;
      b2_rd_en <= 1'b0;
      b3_rd_en <= 1'b0;
      b4_rd_en <= 1'b1;
     end
    // end
    // else
    // begin
    //  b2_rd_en <= 1'b1;
    //  b1_rd_en <= 1'b0;
    // end
    end
    state <= lp;

   end

   /*
   * lp - load next command parameter,
	   * set both high and low bytes for RAMWR cmd,
	   * otherwise set param data to standard data buffer,
	   * disable param_bram read,
	   * increment param pointer,
	   * decrement remaining params
   * next state - [out of parameters to send] lc
   * next state - [parameters are left to send] sm 
   */
   lp: 
   begin

    if(!pb_valid && (cb_data_out != RAMWR))
    begin
     state <= lp; // Remain in lp until param is valid
    end
    else if(b1_rd_en && !b1_valid && (cb_data_out == RAMWR))
    begin
     state <= lp; // Remain in lp until bram is valid
    end
    else if(b2_rd_en && !b2_valid && (cb_data_out == RAMWR))
    begin
     state <= lp; // Remain in lp until bram is valid
    end
    else if(b3_rd_en && !b3_valid && (cb_data_out == RAMWR))
    begin
     state <= lp; // Remain in lp until bram is valid
    end
    else if(b4_rd_en && !b4_valid && (cb_data_out == RAMWR))
    begin
     state <= lp;
    end
    else
    begin

     if(params_left == 14'd0)
     begin
      cb_rd_en <= 1'b1; //Remember to enable cmd_bram read
      state <= lc;// need to provide delay
     end
     else
     begin
      pb_rd_en <= 1'b0; //Remember to disable param read
      //Remember to only increment the parameter pointer if it is not the
      //pixel color data for frame color write!
      if(pb_rd_addr < 7'd67)
      begin
       pb_rd_addr <= pb_rd_addr + 7'd1;// increment param pointer
      end
      params_left <= params_left - 14'd1;           
      state <= sm;
     end


     if(cb_data_out == RAMWR)
     begin
      if(b1_rd_en && !b1_fin) // b1_rd_en && !b1_fin
      begin
       pixel_data <= {16{b1_data_out[bw_pxls_ptr]}}; //Instead of byte_of_bw_pxls use b1_data_out
       b1_rd_en <= 1'b0;
       b2_rd_en <= 1'b0;
      end
      else if(b2_rd_en && !b2_fin)
      begin
       pixel_data <= {16{b2_data_out[bw_pxls_ptr]}};
       b1_rd_en <= 1'b0;
       b2_rd_en <= 1'b0;
      end
      else if(b3_rd_en && !b3_fin)
      begin
       pixel_data <= {16{b3_data_out[bw_pxls_ptr]}};
       b1_rd_en <= 1'b0;
       b2_rd_en <= 1'b0;
       b3_rd_en <= 1'b0;
      end
      else if(b4_rd_en && !b4_fin)
      begin
       pixel_data <= {16{b4_data_out[bw_pxls_ptr]}};
       b1_rd_en <= 1'b0;
       b2_rd_en <= 1'b0;
       b3_rd_en <= 1'b0;
       b4_rd_en <= 1'b0;
      end
      else
      begin
       pixel_data <= 16'h50_50;
       b1_rd_en <= 1'b0;
       b2_rd_en <= 1'b0;
       b3_rd_en <= 1'b0;
       b4_rd_en <= 1'b0;
      end
      //else if(b2_rd_en)
      //begin
      // pixel_data <= {16{b2_data_out[bw_pxls_ptr]}};
      // b2_rd_en <= 1'b0;
      //end
      if(bw_pxls_ptr == 3'b000)
      begin
       bw_pxls_ptr <= 3'b111;

       if(b1_fin == 1'b0)
       begin
        if(b1_rd_addr == 9'd511)
        begin
         b1_fin <= 1'b1;
        end
        else
        begin
         b1_rd_addr <= b1_rd_addr + 9'd1;
        end
       end
       else if(b2_fin == 1'b0)
       begin
        if(b2_rd_addr == 9'd511)
        begin
	 b2_fin <= 1'b1;
        end
        else
        begin
         b2_rd_addr <= b2_rd_addr + 9'd1; //Reset to 0
        end                                           
       end                                               
       else if(b3_fin == 1'b0)                             
       begin
        if(b3_rd_addr == 9'd511)
        begin
         b3_fin <= 1'b1;
        end
        else
        begin
         b3_rd_addr <= b3_rd_addr + 9'd1; //Reset to 0
        end                                           
       end 
       else if(b4_fin == 1'b0)                                 
       begin
        if(b4_rd_addr == 6'd63)
        begin
         b4_fin <= 1'b1;
        end
        else
        begin
         b4_rd_addr <= b4_rd_addr + 6'd1; //Reset to 0
        end                                           
       end                                               

      end
      else
      begin
       bw_pxls_ptr <= bw_pxls_ptr - 3'b1;
      end
     end

     data <= pb_data_out; 

    end

   end

   dsleep:
   begin

    if(delay < sleep)
    begin
     delay <= delay + 16'd1;
    end
    else
    begin
     state <= rdc;
     delay <= 16'd0;
    end

   end

  endcase
 end

 assign RST = rst;
 assign SCL = scl;
 assign DC = dc;
 assign MOSI = mosi;
 assign CS = cs;

endmodule
