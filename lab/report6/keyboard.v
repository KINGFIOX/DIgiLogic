`timescale 1ns / 1ps


module keyboard #(
    parameter CNT_THRESHOLD = 100000 - 1
) (
    output reg [3:0] col,
    output reg [3:0] num,
    output reg en,
    input rst,
    input clk,
    input [3:0] row
);


  wire rst_n = ~rst;


  /* generate the col signal */


  wire cnt_end;

  kb_cnt #(CNT_THRESHOLD, 24) cnt (
      .cnt_end(cnt_end),
      .clk(clk),
      .reset(rst),
      .cnt_inc(1'b1)
  );


  parameter IDLE = 4'b1111;
  parameter S0 = 4'b1110;
  parameter S1 = 4'b1101;
  parameter S2 = 4'b1011;
  parameter S3 = 4'b0111;

  reg [3:0] current_state;
  reg [3:0] next_state;

  // migrate current to next
  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end

  // condition
  wire idle_s0_con = current_state == IDLE && cnt_end;
  wire s0_s1_con = current_state == S0 && cnt_end;
  wire s1_s2_con = current_state == S1 && cnt_end;
  wire s2_s3_con = current_state == S2 && cnt_end;
  wire s3_s0_con = current_state == S3 && cnt_end;

  // state migrate table
  always @(*) begin
    case (current_state)
      IDLE: begin
        if (idle_s0_con) begin
          next_state = S0;
        end else begin
          next_state = IDLE;
        end
      end
      S0: begin
        if (s0_s1_con) begin
          next_state = S1;
        end else begin
          next_state = S0;
        end
      end
      S1: begin
        if (s1_s2_con) begin
          next_state = S2;
        end else begin
          next_state = S1;
        end
      end
      S2: begin
        if (s2_s3_con) begin
          next_state = S3;
        end else begin
          next_state = S2;
        end
      end
      S3: begin
        if (s3_s0_con) begin
          next_state = S0;
        end else begin
          next_state = S3;
        end
      end
      default: next_state = IDLE;
    endcase
  end


  // output
  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) col <= 4'b1111;
    else begin
      case (current_state)
        S0: col <= 4'b1110;
        S1: col <= 4'b1101;
        S2: col <= 4'b1011;
        S3: col <= 4'b0111;
        IDLE: col <= 4'b1111;
        default: col <= 4'b1111;
      endcase
    end
  end


  /* read the row signal */

  reg [15:0] key;
  reg [15:0] key_r;

  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) key <= 16'h0000;
    else if (cnt_end) begin
      if (col[0] == 0) begin
        key[3:0] <= ~row;
      end
      if (col[1] == 0) begin
        key[7:4] <= ~row;
      end
      if (col[2] == 0) begin
        key[11:8] <= ~row;
      end
      if (col[3] == 0) begin
        key[15:12] <= ~row;
      end
    end
  end

  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      key_r <= 0;
    end else begin
      key_r <= key;
    end
  end

  wire [15:0] key_posedge = (~key_r) & key;

  /* decode and led en*/

  /* check press */
  // if press en
  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      en <= 1'b0;
    end else begin
      if (key_posedge) begin
        en <= 1'b1;
      end else begin
        en <= 1'b0;
      end
    end
  end


  /* decode num */
  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) begin
      num <= 4'h0;
    end else if (key_posedge) begin
      if (key_posedge[0]) num <= 4'hd;
      else if (key_posedge[1]) num <= 4'hc;
      else if (key_posedge[2]) num <= 4'hb;
      else if (key_posedge[3]) num <= 4'ha;
      else if (key_posedge[4]) num <= 4'hf;
      else if (key_posedge[5]) num <= 4'h9;
      else if (key_posedge[6]) num <= 4'h6;
      else if (key_posedge[7]) num <= 4'h3;
      else if (key_posedge[8]) num <= 4'h0;
      else if (key_posedge[9]) num <= 4'h8;
      else if (key_posedge[10]) num <= 4'h5;
      else if (key_posedge[11]) num <= 4'h2;
      else if (key_posedge[12]) num <= 4'he;
      else if (key_posedge[13]) num <= 4'h7;
      else if (key_posedge[14]) num <= 4'h4;
      else if (key_posedge[15]) num <= 4'h1;
    end else begin
      num <= num;
    end
  end


  /* led en */



endmodule


module kb_cnt #(
    parameter END   = 15,
    parameter WIDTH = 4
) (
    output cnt_end,
    input  clk,
    input  reset,
    input  cnt_inc
);

  reg [WIDTH-1:0] cnt;
  assign cnt_end = (cnt == END);

  always @(posedge clk, posedge reset) begin
    if (reset) cnt <= 0;
    else if (cnt_end) cnt <= 0;
    else if (cnt_inc) cnt <= cnt + 1;
  end

endmodule


