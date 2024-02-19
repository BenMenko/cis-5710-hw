`timescale 1ns / 1ps

/**
 * @param a first 1-bit input
 * @param b second 1-bit input
 * @param g whether a and b generate a carry
 * @param p whether a and b would propagate an incoming carry
 */
module gp1(input wire a, b,
           output wire g, p);
   assign g = a & b;
   assign p = a | b;
endmodule


/**
 * Computes aggregate generate/propagate signals over a 4-bit window.
 * @param gin incoming generate signals
 * @param pin incoming propagate signals
 * @param cin the incoming carry
 * @param gout whether these 4 bits internally would generate a carry-out (independent of cin)
 * @param pout whether these 4 bits internally would propagate an incoming carry from cin
 * @param cout the carry outs for the low-order 3 bits
 */
module gp4(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [2:0] cout);

   logic c1, c2, c3, p_out, g_out;
   always_comb begin
      c1 = (gin[0] | (pin[0] & cin));
      c2 = (gin[1] | (pin[1] & c1));
      c3 = (gin[2] | (pin[2] & c2));
      p_out = (pin[0] & pin[1] & pin[2] & pin[3]);
      g_out = (gin[0] & pin[1] & pin[2] & pin[3]) | (pin[3] & gin[1] & pin[2]) | (gin[2] & pin[3]) | gin[3];
   end
   assign gout = g_out;
   assign pout = p_out;
   assign cout[2] = c3;
   assign cout[1] = c2;
   assign cout[0] = c1;
endmodule


/** Same as gp4 but for an 8-bit window instead */
module gp8(input wire [7:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [6:0] cout);
   logic c1, c2, c3, c4, c5, c6, c7, g_out, p_out;
   always_comb begin
      c1 = (gin[0] | (pin[0] & cin));
      c2 = (gin[1] | (pin[1] & c1));
      c3 = (gin[2] | (pin[2] & c2));
      c4 = (gin[3] | (pin[3] & c3));
      c5 = (gin[4] | (pin[4] & c4));
      c6 = (gin[5] | (pin[5] & c5));
      c7 = (gin[6] | (pin[6] & c6));
      p_out = (pin[0] & pin[1] & pin[2] & pin[3] & pin[4] & pin[5] & pin[6] & pin[7]);
      g_out = (gin[0] & pin[1] & pin[2] & pin[3] & pin[4] & pin[5] & pin[6] & pin[7]) | (gin[1] & pin[2] & pin[3] & pin[4] & pin[5] & pin[6] & pin[7]) | (gin[2] & pin[3] & pin[4] & pin[5] & pin[6] & pin[7]) | (gin[3] & pin[4] & pin[5] & pin[6] & pin[7]) | (gin[4] & pin[5] & pin[6] & pin[7]) | (gin[5] & pin[6] & pin[7]) | (gin[6] & pin[7]) | (gin[7]);
   end
   assign cout[0] = c1;
   assign cout[1] = c2;
   assign cout[2] = c3;
   assign cout[3] = c4;
   assign cout[4] = c5;
   assign cout[5] = c6;
   assign cout[6] = c7;
   assign gout = g_out;
   assign pout = p_out;
endmodule


module cla
  (input wire [31:0]  a, b,
   input wire         cin,
   output wire [31:0] sum);

   // 32 1-bit modules
   wire level_one_g[32];
   wire level_one_p[32];
   genvar i;
   generate
      for (i = 0; i < 32; i = i + 1) begin
         gp1 bit1(.a(a[i]), .b(b[i]), .g(level_one_g[i]), .p(level_one_p[i]));
      end
   endgenerate

   // 4 8-bit modules
   wire level_two_g[4];
   wire level_two_p[4];
   wire [6:0] level_two_c[4];
   genvar k;
   generate
      for (k = 0; k < 4; k = k + 1) begin
         gp8 bit8(.gin(level_one_g[8*k+7 : 8*k]), .pin(level_one_p[8*k+7 : 8*k]), .cin(cin), .gout(level_two_g[k]), .pout(level_two_p[k]),  .cout(level_two_c[k]));
      end
   endgenerate

   logic [31:0] c;
   always_comb begin
      c[0] = level_two_c[0][0];
      c[1] = level_two_c[0][1];
      c[2] = level_two_c[0][2];
      c[3] = level_two_c[0][3];
      c[4] = level_two_c[0][4];
      c[5] = level_two_c[0][5];
      c[6] = level_two_c[0][6];
      c[7] = (cin & level_two_p[0]) | level_two_g[0];
      c[8] = level_two_c[1][0];
      c[9] = level_two_c[1][1];
      c[10] = level_two_c[1][2];
      c[11] = level_two_c[1][3];
      c[12] = level_two_c[1][4];
      c[13] = level_two_c[1][5];
      c[14] = level_two_c[1][6];
      c[15] = (c[7] & level_two_p[1]) | level_two_g[1];
      c[16] = level_two_c[2][0];
      c[17] = level_two_c[2][1];
      c[18] = level_two_c[2][2];
      c[19] = level_two_c[2][3];
      c[20] = level_two_c[2][4];
      c[21] = level_two_c[2][5];
      c[22] = level_two_c[2][6];
      c[23] = (c[15] & level_two_p[2]) | level_two_g[2];
      c[24] = level_two_c[3][0];
      c[25] = level_two_c[3][1];
      c[26] = level_two_c[3][2];
      c[27] = level_two_c[3][3];
      c[28] = level_two_c[3][4];
      c[29] = level_two_c[3][5];
      c[30] = level_two_c[3][6];
      c[31] = (c[23] & level_two_p[3]) | level_two_g[3];
   end

   genvar l;
   generate
      for (l = 0; l < 32; l = l + 1) begin
         assign sum[l] = a[l] ^ b[l] ^ c[l];
      end
   endgenerate 
endmodule
