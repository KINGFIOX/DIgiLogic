`timescale 1ns / 1ps


module top_module (
    output wire [7:0] out,
    output wire [7:0] led_en,
    output wire [3:0] col,
    input wire s2,
    input wire s3,
    input wire s4,
    input wire s5,
    input wire [3:0] row,
    input rst,
    input clk
);

  // 降频 的 clk
  clk_div u_clk_div (
      .clk_in1 (clk),
      .clk_out1(clk_g),
      .locked  (1'b1)
  );

  wire [15:0] num;  // 计算结果 --> out1
  wire [15:0] rem;  // 记忆  -> out2

  cal c (
      .out1(num),   // 乘法可能会有进位之类的
      .out2(rem),
      .col (col),   // 列扫描
      .row (row),   // 行输入
      .rst (rst),   // rst是s1
      .s2  (s2),    // 等号
      .s3  (s3),    // 上翻
      .s4  (s4),    // 保存按键
      .s5  (s5),    // 下翻
      .clk (clk_g)
  );

  display dp (
      .out(out),
      .led_en(led_en),
      .clk(clk_g),
      .rst(rst),
      .dk3(rem[15:12]),
      .dk2(rem[11:8]),
      .dk1(rem[7:4]),
      .dk0(rem[3:0]),
      .dk7(num[15:12]),
      .dk6(num[11:8]),
      .dk5(num[7:4]),
      .dk4(num[3:0])
  );
  defparam dp.F = 10000;

endmodule

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

  // inc cnt
  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) cnt <= 20'h0;
    else if (key_cnt) cnt <= cnt + 20'h1;
    else cnt <= 20'h0;
  end

  always @(posedge clk or negedge rst_n) begin
    if (rst_n == 1'b0) key_cnt <= 0;
    else if (key_cnt == 1'b0 && key_in != key_out) key_cnt <= 1'b1;
    else if (cnt == F - 1) key_cnt <= 1'b0;
  end

endmodule

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
      .clk(clk),
      .reset(rst),
      .cnt_inc(1),
      .cnt_end(cnt_end)
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
    input clk,
    input reset,
    input cnt_inc,
    output cnt_end,
    output reg [WIDTH-1:0] cnt
);

  assign cnt_end = (cnt == END);

  always @(posedge clk, posedge reset) begin
    if (reset) cnt <= 0;
    else if (cnt_end) cnt <= 0;
    else if (cnt_inc) cnt <= cnt + 1;
  end

endmodule

module display #(
    parameter F = 10000
) (
    output reg [7:0] out,
    output reg [7:0] led_en,
    input [3:0] dk7,
    dk6,
    dk5,
    dk4,
    dk3,
    dk2,
    dk1,
    dk0,
    input clk,
    input rst
);

  wire [2:0] sel;
  dp_cnt cnt (
      .sel(sel),
      .clk(clk),
      .rst(rst),
      .en (1'b1)
  );
  defparam cnt.F = F;

  wire [7:0] mid_out, mid_en;
  dp_mux mux (
      .out(mid_out),
      .led_en(mid_en),
      .sel(sel),
      .dk7(dk7),
      .dk6(dk6),
      .dk5(dk5),
      .dk4(dk4),
      .dk3(dk3),
      .dk2(dk2),
      .dk1(dk1),
      .dk0(dk0)
  );

  always @(*) begin
    out = mid_out;
    led_en = mid_en;
  end
endmodule


// this is select led
module dp_cnt #(
    parameter F = 10000
)  // log2(1500000) = 20.51
(
    output reg [2:0] sel,
    input clk,
    input rst,
    input en  // en default to 1
);
  reg [20:0] cnt;
  reg cnt_inc;
  wire rst_n = ~rst;
  wire cnt_end = cnt_inc & (cnt == F);

  // clk enable count
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      cnt_inc <= 1'b0;
    end else if (en) begin
      cnt_inc <= 1'b1;
    end else if (cnt_end) begin
      cnt_inc <= 1'b0;
    end
  end

  // clk count increase
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      cnt <= 21'h0;
    end else if (cnt_end) begin
      cnt <= 21'h0;
    end else if (cnt_inc) begin
      cnt <= cnt + 21'h1;
    end
  end

  // digital select
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      sel <= 3'b000;
    end  // else if (sel == 3'b111) begin sel <= 3'b000; end
         // else if (cnt_end) begin sel <= sel + 3'b001; end
    else if (cnt_end) begin
      case (sel)
        3'b000: sel <= 3'b001;
        3'b001: sel <= 3'b010;
        3'b010: sel <= 3'b011;
        3'b011: sel <= 3'b100;

        3'b100: sel <= 3'b101;
        3'b101: sel <= 3'b110;
        3'b110: sel <= 3'b111;
        3'b111: sel <= 3'b000;
      endcase
    end
  end
endmodule

module dp_mux (
    output reg  [7:0] out,     // 数字显示输出
    output reg  [7:0] led_en,  // LED 使能信号
    input  wire [2:0] sel,     // 选择输入
    input  wire [3:0] dk7,
    dk6,
    dk5,
    dk4,
    dk3,
    dk2,
    dk1,
    dk0  // 输入信号
);

  // mux
  reg [3:0] mid;

  // Multiplexer logic
  always @(*) begin
    case (sel)
      3'b000: begin
        mid = dk0;
        led_en = 8'b11111110;
      end
      3'b001: begin
        mid = dk1;
        led_en = 8'b11111101;
      end
      3'b010: begin
        mid = dk2;
        led_en = 8'b11111011;
      end
      3'b011: begin
        mid = dk3;
        led_en = 8'b11110111;
      end
      3'b100: begin
        mid = dk4;
        led_en = 8'b11101111;
      end
      3'b101: begin
        mid = dk5;
        led_en = 8'b11011111;
      end
      3'b110: begin
        mid = dk6;
        led_en = 8'b10111111;
      end
      3'b111: begin
        mid = dk7;
        led_en = 8'b01111111;
      end
    endcase
  end

  // Decoder logic
  always @(*) begin
    case (mid)
      4'h0: out = 8'b10000001;
      4'h1: out = 8'b11110011;
      4'h2: out = 8'b01001001;
      4'h3: out = 8'b01100001;
      4'h4: out = 8'b00110011;
      4'h5: out = 8'b00100101;
      4'h6: out = 8'b00000101;
      4'h7: out = 8'b11110001;
      4'h8: out = 8'b00000001;
      4'h9: out = 8'b00110001;
      4'ha: out = 8'b00010001;
      4'hb: out = 8'b00000111;
      4'hc: out = 8'b01001111;
      4'hd: out = 8'b01000011;
      default: out = 8'b11111111;
    endcase
  end

endmodule


module dff4 (
    output wire [15:0] q,
    input wire clk,
    input wire rst,
    input wire en,  // 写入开关
    input wire [15:0] d,
    input wire [1:0] wsel,
    input wire [1:0] rsel
);
  wire [3:0] wsel_de;  // 只有一个是有用的
  wire [15:0] r0, r1, r2, r3;

  // 4选1,选择写入
  decode24 de (
      .out(wsel_de),
      .sel(wsel),
      .en (en)
  );

  dff d0 (
      .q  (r0),
      .clk(clk),
      .rst(rst),
      .en (wsel_de[0]),
      .d  (d)
  );
  dff d1 (
      .q  (r1),
      .clk(clk),
      .rst(rst),
      .en (wsel_de[1]),
      .d  (d)
  );
  dff d2 (
      .q  (r2),
      .clk(clk),
      .rst(rst),
      .en (wsel_de[2]),
      .d  (d)
  );
  dff d3 (
      .q  (r3),
      .clk(clk),
      .rst(rst),
      .en (wsel_de[3]),
      .d  (d)
  );
  mux4 m (
      .out(q),
      .sel(rsel),
      .in0(r0),
      .in1(r1),
      .in2(r2),
      .in3(r3)
  );
endmodule


module dff (
    output reg [15:0] q,
    input clk,
    input rst,
    input en,  // 是否写入
    input wire [15:0] d
);

  wire rst_n = ~rst;
  always @(negedge rst_n or posedge clk) begin
    if (~rst_n) begin
      q <= 0;
    end else begin
      if (en) begin
        q <= d;
      end else begin
        q <= q;
      end
    end
  end

endmodule


// 多路选择器
module mux4 (
    output reg  [15:0] out,
    input  wire [ 1:0] sel,
    input  wire [15:0] in0,
    input  wire [15:0] in1,
    input  wire [15:0] in2,
    input  wire [15:0] in3
);
  always @(*) begin
    case (sel)
      2'b00:   out = in0;
      2'b01:   out = in1;
      2'b10:   out = in2;
      2'b11:   out = in3;
      default: out = 0;
    endcase
  end
endmodule

module decode24 (
    output reg [3:0] out,
    input wire [1:0] sel,
    input wire en
);
  always @(*) begin
    if (en) begin
      case (sel)
        2'b00: out = 4'b0001;
        2'b01: out = 4'b0010;
        2'b10: out = 4'b0100;
        2'b11: out = 4'b1000;
      endcase
    end else begin
      out = 4'b0000;
    end
  end
endmodule

