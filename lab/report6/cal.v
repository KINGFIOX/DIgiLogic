`timescale 1ns / 1ps


module cal #(
    parameter CNT_THRESHOLD = 100000 - 1
) (
    output wire [15:0] out1,  // 左边
    output reg [15:0] out2,  // 右边
    output wire [3:0] col,  // 列扫描
    input wire [3:0] row,  // 行输入
    input wire rst,  // rst是s1
    input wire s2,  // 等号
    input wire s3,  // s3 上 翻页
    input wire s4,  // 手动保存
    input wire s5,  // s3 下 翻页
    input clk
);

  wire rst_n = ~rst;
  wire [3:0] num;
  wire en;

  // 键盘
  keyboard #(CNT_THRESHOLD) k (
      .col(col),
      .num(num),
      .en (en),
      .rst(rst),
      .clk(clk),
      .row(row)
  );


  // 声明状态
  parameter IDLE = 6'b111111;
  parameter S0 = 6'b111110;
  parameter S1 = 6'b111101;
  parameter S2 = 6'b111011;
  parameter S3 = 6'b110111;
  parameter S4 = 6'b101111;
  parameter S5 = 6'b011111;

  reg [5:0] current_state, next_state;


  // wire cnt_end;

  // kb_cnt #(CNT_THRESHOLD, 24) cnt (
  //     .clk(clk),
  //     .reset(rst),
  //     .cnt_inc(1),
  //     .cnt_end(cnt_end)
  // );

  wire [3:0] M;
  wire check;


  // 确定 是否有按下 +-*/
  en_check ec (
      .check(check),
      .method(M),
      .num(num)
  );


  // 状态转移
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) current_state <= IDLE;
    else begin
      current_state <= next_state;
    end
  end


  // 状态转移表
  always @(*) begin
    case (current_state)

      IDLE: begin
        if (s2) begin
          next_state <= IDLE;
        end else if (check) begin
          next_state <= IDLE;
        end else if (en) begin
          next_state <= S0;
        end else begin
          next_state <= IDLE;
        end
      end

      S0: begin
        if (s2) begin
          next_state <= S5;
        end else if (check) begin
          next_state <= S2;
        end else if (en) begin
          next_state <= S1;
        end else begin
          next_state <= S0;
        end
      end

      S1: begin
        if (s2) begin
          next_state <= S5;
        end else if (check) begin
          next_state <= S2;
        end else if (en) begin
          // 防御
        end else begin
          next_state <= S1;
        end
      end

      S2: begin
        if (s2) begin
          next_state <= IDLE;
          // 防御
        end else if (check) begin
          // 防御
        end else if (en) begin
          next_state <= S3;
        end else begin
          next_state <= S2;
        end
      end

      S3: begin
        if (s2) begin
          next_state <= S5;
        end else if (check) begin
          // 连加，防御
        end else if (en) begin
          next_state <= S4;
        end else begin
          next_state <= S3;
        end
      end

      S4: begin
        if (s2) begin
          next_state <= S5;
        end else if (check) begin
          // 连加，防御
        end else if (en) begin
          // 移位，防御
        end else begin
          next_state <= S4;
        end
      end

      S5: begin
        if (s2) begin
          // 防御
        end else if (check) begin
          next_state <= S2;
        end else if (en) begin
          next_state <= S0;
        end else begin
          next_state <= S5;
        end
      end

    endcase
  end


  reg [7:0] a, b;
  reg [3:0] method;
  reg is_method;
  // 计算结果
  wire [15:0] cu_out;
  // 使用 四则运算
  cal_util cu (
      .ans(cu_out),
      .method(method),
      .a(a),
      .b(b)
  );

  // 状态机的 输出
  // a, b, cu_out, b_out, is_method
  // is_method可能会用不到，这里先保留
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      a <= 0;
      b <= 0;
      method <= 4'b1111;
      is_method <= 0;
    end else begin

      case (current_state)

        IDLE: begin
          if (s2) begin
            // next_state <= IDLE;
            a <= 0;
            b <= 0;
            method <= 4'b1111;
            is_method <= 0;
          end else if (check) begin
            // next_state <= IDLE;
            a <= 0;
            b <= 0;
            method <= 4'b1111;
          end else if (en) begin
            // next_state <= S0;
            a <= num;
            b <= 0;
            method <= 4'b1111;
            is_method <= 0;
          end
        end

        S0: begin
          if (s2) begin
            // next_state <= S5;
            a <= a;
            b <= 0;
            method <= 4'b1111;
            is_method <= 0;
          end else if (check) begin
            // next_state <= S2;
            a <= a;
            b <= 0;
            method <= M;  // TODO 显示运算符号
            is_method <= 1;
          end else if (en) begin
            // next_state <= S1;
            a <= a * 10 + num;
            b <= 0;
            method <= 4'b1111;
            is_method <= 0;
          end
        end

        S1: begin
          if (s2) begin
            // next_state <= S5;
            a <= a;
            b <= 0;
            method <= 4'b1111;
            is_method <= 0;
          end else if (check) begin
            // next_state <= S2;
            a <= a;
            b <= 0;
            method <= M;  // TODO 显示运算符号
            is_method <= 1;
          end else if (en) begin
            // 防御
            a <= a;
            b <= b;
            method <= method;
            is_method <= 0;
          end
        end

        S2: begin
          if (s2) begin
            // 防御
            // next_state <= IDLE;
            a <= 0;
            b <= 0;
            method <= 4'b1111;
            is_method <= 0;
          end else if (check) begin
            // 防御
            a <= a;
            b <= b;
            method <= method;
            is_method <= 1;
          end else if (en) begin
            // next_state <= S3;
            a <= a;
            b <= num;
            method <= method;
            is_method <= 0;
          end
        end

        S3: begin
          if (s2) begin
            // next_state <= S5;
            a <= cu_out % 100;  // 只保留两位
            b <= 0;
            method <= 4'b1111;
            is_method <= 0;
          end else if (check) begin
            // 连加，防御  // TODO 连加
            a <= a;
            b <= b;
            method <= method;
            is_method <= 0;
          end else if (en) begin
            // next_state <= S4;
            a <= a;
            b <= b * 10 + num;
            method <= method;
            is_method <= 0;
          end
        end

        S4: begin
          if (s2) begin
            // next_state <= S5;
            a <= cu_out % 100;  // 只保留两位
            b <= 0;
            method <= 4'b1111;
            is_method <= 0;
          end else if (check) begin
            // 连加，防御
            a <= a;
            b <= b;
            method <= method;
            is_method <= 0;
          end else if (en) begin
            // 移位，防御
            a <= a;
            b <= b;
            method <= method;
            is_method <= 0;
          end
        end

        S5: begin
          if (s2) begin
            // 防御
            a <= a;
            b <= b;
            method <= method;
            is_method <= 0;
          end else if (check) begin
            // next_state <= S2;
            a <= a;
            b <= b;
            method <= M;  // TODO 显示运算符号
            is_method <= 1;
          end else if (en) begin
            // next_state = S0  // 重新开始
            a <= num;
            b <= 0;
            method <= 4'b1111;
            is_method <= 0;
          end
        end

      endcase

    end
  end

  /* 上面是 状态机 */

  /* 下面是控制输出 */


  wire [1:0] rsel;  // 读出的时候的页码，
  reg writable;  // 是否写入
  reg [1:0] wsel;  // 写入的页码，这个是随着s2的按下自增的
  reg [15:0] in_d;  // 寄存器的输入
  wire [15:0] rem_out;

  // 寄存器堆
  dff4 d4 (
      .q(rem_out),  // 输出
      .clk(clk),
      .rst(rst),
      .en(writable),  // 写入开关
      .d(in_d),  // 写入啥数据
      .wsel(wsel),
      .rsel(rsel)
  );


  reg  [15:0] d2b_in2;
  wire [15:0] d2b_out2;

  dec2bcd d2b2 (
      .bcd(d2b_out2),
      .decimal(d2b_in2)
  );

  // 显示输出， out2
  always @(*) begin
    d2b_in2 = rem_out;
    out2 = d2b_out2;
  end

  // 寄存器输出模块，主要是产生rsel
  s3s5_control s3s5c (
      .rsel(rsel),
      .s3  (s3),
      .s5  (s5),
      .clk (clk),
      .rst (rst)
  );


  /* 寄存器堆输入 */
  reg s4_sig_r0, s4_sig_r1;
  wire s4_eco;
  btn_stable bs4 (
      .key_out(s4_eco),
      .key_in(s4),
      .clk(clk),
      .rst(rst)
  );
  defparam bs4.F = CNT_THRESHOLD;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      s4_sig_r0 <= 1'b0;
    end else begin
      s4_sig_r0 <= s4_eco;  // signal
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      s4_sig_r1 <= 1'b0;
    end else begin
      s4_sig_r1 <= s4_sig_r0;
    end
  end
  wire s4_pos = ~s4_sig_r1 & s4_sig_r0;


  // 控制 wsel, writable, in_d
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      wsel <= 0;
      writable <= 0;
      in_d <= 0;
    end else begin
      case (current_state)
        S3: begin
          if (s2) begin
            writable <= 0;
            wsel <= wsel;
            in_d <= cu_out;
          end else begin
            writable <= 0;
            wsel <= wsel;
            in_d <= in_d;
          end
        end
        S4: begin
          if (s2) begin
            writable <= 0;
            in_d <= cu_out;
            wsel <= wsel;
          end else begin
            writable <= 0;
            wsel <= wsel;
            in_d <= in_d;
          end
        end
        S5: begin
          if (s4_pos) begin
            writable <= 1;
            in_d <= in_d;
            if (wsel == 2'b11) begin
              wsel <= 2'b00;
            end else begin
              wsel <= wsel + 1;
            end
          end else begin
            wsel <= wsel;
            in_d <= in_d;
            writable <= 0;
          end
        end
        default: begin
          wsel <= wsel;
          writable <= 0;
          in_d <= 0;
        end
      endcase
    end
  end



  reg [15:0] seq;
  // 输出显示 
  // seq
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      seq <= 0;
    end else begin

      case (current_state)

        IDLE: begin
          if (s2) begin
            seq <= 0;
          end else if (check) begin
            // next_state <= IDLE;
            seq <= 0;
          end else if (en) begin
            seq <= num;
          end
        end

        S0: begin
          if (s2) begin
            seq <= seq;
          end else if (check) begin  // 符号
            case (M)
              4'b1110: begin
                seq <= {seq[11:0], 4'ha};
              end
              4'b1101: begin
                seq <= {seq[11:0], 4'hb};
              end
              4'b1011: begin
                seq <= {seq[11:0], 4'hc};
              end
              4'b0111: begin
                seq <= {seq[11:0], 4'hd};
              end
              default: begin
                seq <= seq;
              end
            endcase
          end else if (en) begin
            seq <= {seq[11:0], num};
          end
        end

        S1: begin
          if (s2) begin
            seq <= seq;
          end else if (check) begin  // 符号
            // next_state <= S2;
            case (M)
              4'b1110: begin
                seq <= {seq[11:0], 4'ha};
              end
              4'b1101: begin
                seq <= {seq[11:0], 4'hb};
              end
              4'b1011: begin
                seq <= {seq[11:0], 4'hc};
              end
              4'b0111: begin
                seq <= {seq[11:0], 4'hd};
              end
              default: begin
                seq <= seq;
              end
            endcase
          end else if (en) begin
            // 防御
            seq <= seq;
          end
        end

        S2: begin
          if (s2) begin
            // 防御
            // next_state <= IDLE;
            seq <= 0;
          end else if (check) begin
            // 防御
            seq <= seq;
          end else if (en) begin
            // next_state <= S3;
            seq <= {seq[11:0], num};
          end
        end

        S3: begin
          if (s2) begin
            seq[15:12] <= cu_out / 1000;
            seq[11:8]  <= (cu_out / 100) % 10;
            seq[7:4]   <= (cu_out / 10) % 10;
            seq[3:0]   <= cu_out % 10;
          end else if (check) begin
            // 连加，防御  // TODO 连加
            seq <= seq;
          end else if (en) begin
            // next_state <= S4;
            seq <= {seq[11:0], num};
          end
        end

        S4: begin
          if (s2) begin
            // next_state <= S5;
            seq[15:12] <= cu_out / 1000;
            seq[11:8]  <= (cu_out / 100) % 10;
            seq[7:4]   <= (cu_out / 10) % 10;
            seq[3:0]   <= cu_out % 10;
          end else if (check) begin
            seq <= seq;
          end else if (en) begin
            // 移位，防御
            seq <= seq;
          end
        end

        S5: begin
          if (s2) begin
            // 防御
            seq <= seq;
          end else if (check) begin  // 符号
            // next_state <= S2;
            case (M)
              4'b1110: begin
                seq <= {seq[11:0], 4'ha};
              end
              4'b1101: begin
                seq <= {seq[11:0], 4'hb};
              end
              4'b1011: begin
                seq <= {seq[11:0], 4'hc};
              end
              4'b0111: begin
                seq <= {seq[11:0], 4'hd};
              end
              default: begin
                seq <= seq;
              end
            endcase
          end else if (en) begin
            // next_state = S0  // 重新开始
            seq <= num;
          end
        end

      endcase

    end
  end

  assign out1 = seq;


endmodule


// 是否按下 operator
module en_check (
    output reg check,
    output reg [3:0] method,
    input [3:0] num
);

  // 用来判断+-*/的
  always @(*) begin
    case (num)
      4'ha: begin  // +
        check  = 1'b1;
        method = 4'b1110;
      end
      4'hb: begin  // -
        check  = 1'b1;
        method = 4'b1101;
      end
      4'hc: begin  // *
        check  = 1'b1;
        method = 4'b1011;
      end
      4'hd: begin  // /
        check  = 1'b1;
        method = 4'b0111;
      end

      default: begin
        check  = 1'b0;
        method = 4'b1111;
      end
    endcase
  end

endmodule

// 计算
module cal_util (
    output reg [15:0] ans,
    input [3:0] method,
    input [7:0] a,
    input [7:0] b
);

  // 计算
  always @(*) begin
    case (method)
      4'b1110: begin
        ans = a + b;
      end
      4'b1101: begin
        ans = a - b;
      end
      4'b1011: begin
        ans = a * b;
      end
      4'b0111: begin
        ans = a / b;
      end
      default: begin
        ans = 0;
      end
    endcase
  end

endmodule


// 这是将 十进制 转化为 bcd码
module dec2bcd (
    output reg  [15:0] bcd,
    input  wire [15:0] decimal
);

  // 转化为bcd码
  always @(*) begin
    bcd[15:12] = (decimal / 1000) % 10;  // 千
    bcd[11:8]  = (decimal / 100) % 10;  // 百
    bcd[7:4]   = (decimal / 10) % 10;  // 十
    bcd[3:0]   = decimal % 10;  // 个
  end

endmodule


// 这是控制 s3 和 s5 的
module s3s5_control #(
    parameter F = 15000 - 1
) (
    output reg [1:0] rsel,
    input wire s3,
    input wire s5,
    input wire clk,
    input wire rst
);

  wire rst_n = ~rst;

  /* 检测s3按下，上升沿 */

  reg s3_sig_r0, s3_sig_r1;

  wire s3_eco;

  btn_stable bs3 (
      .key_out(s3_eco),
      .key_in(s3),
      .clk(clk),
      .rst(rst)
  );
  defparam bs3.F = F;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      s3_sig_r0 <= 1'b0;
    end else begin
      s3_sig_r0 <= s3_eco;  // signal
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      s3_sig_r1 <= 1'b0;
    end else begin
      s3_sig_r1 <= s3_sig_r0;
    end
  end

  wire s3_pos = ~s3_sig_r1 & s3_sig_r0;

  /* 检测s5按下，上升沿 */

  reg s5_sig_r0, s5_sig_r1;

  wire s5_eco;

  btn_stable bs5 (
      .key_out(s5_eco),
      .key_in(s5),
      .clk(clk),
      .rst(rst)
  );
  defparam bs5.F = F;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      s5_sig_r0 <= 1'b0;
    end else begin
      s5_sig_r0 <= s5_eco;
    end
  end

  always @(posedge clk) begin
    if (rst) begin
      s5_sig_r1 <= 1'b0;
    end else begin
      s5_sig_r1 <= s5_sig_r0;
    end
  end

  wire s5_pos = ~s5_sig_r1 & s5_sig_r0;

  /* 寄存器堆输出 */

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      rsel <= 0;
    end else begin
      case ({
        s3_pos, s5_pos
      })
        2'b00: begin
          rsel <= rsel;
        end
        2'b11: begin
          rsel <= rsel;
        end
        2'b01: begin  // 下翻页，++
          if (rsel == 2'b11) rsel <= 2'b00;
          else rsel <= rsel + 1;
        end
        2'b10: begin  // 上翻页，--
          if (rsel == 2'b00) rsel <= 2'b11;
          else rsel <= rsel - 1;
        end
        default: begin
          rsel <= rsel;
        end
      endcase
    end
  end
endmodule

// 被s2s3_control依赖 
module btn_stable #(
    parameter F = 15000 - 1
) (
    output reg key_out,
    input key_in,
    input clk,
    input rst
);
  wire rst_n = ~rst;
  reg [19:0] cnt;
  reg key_cnt;

  // collect the result
  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) key_out <= 1'b0;
    else if (cnt == F - 1) key_out <= key_in;
  end

  // 只会控制cnt的自增
  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) cnt <= 20'h0;
    // 如果没有发生进位，那么就自增
    else if (key_cnt) cnt <= cnt + 20'h1;
    else cnt <= 20'h0;
  end

  // 只会控制key_cnt，key_cnt是计数的开关
  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) key_cnt <= 0;
    else if (key_cnt == 1'b0 && key_in != key_out) key_cnt <= 1'b1;
    else if (cnt == F - 1) key_cnt <= 1'b0;
  end

endmodule
