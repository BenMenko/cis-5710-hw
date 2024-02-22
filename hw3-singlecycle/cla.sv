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

module gp32(input wire [31:0] gin, pin,
           input wire cin,
           output wire [31:0] cout);
   logic c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15, c16, c17, c18, c19, c20, c21, c22, c23, c24, c25, c26, c27, c28, c29, c30, c31;
   always_comb begin
      c0 = cin;
      c1 = (gin[0] | (pin[0] & c0));
      c2 = (gin[1] | (pin[1] & c1));
      c3 = (gin[2] | (pin[2] & c2));
      c4 = (gin[3] | (pin[3] & c3));
      c5 = (gin[4] | (pin[4] & c4));
      c6 = (gin[5] | (pin[5] & c5));
      c7 = (gin[6] | (pin[6] & c6));
      c8 = (gin[7] | (pin[7] & c7));
      c9 = (gin[8] | (pin[8] & c8));
      c10 = (gin[9] | (pin[9] & c9));
      c11 = (gin[10] | (pin[10] & c10));
      c12 = (gin[11] | (pin[11] & c11));
      c13 = (gin[12] | (pin[12] & c12));
      c14 = (gin[13] | (pin[13] & c13));
      c15 = (gin[14] | (pin[14] & c14));
      c16 = (gin[15] | (pin[15] & c15));
      c17 = (gin[16] | (pin[16] & c16));
      c18 = (gin[17] | (pin[17] & c17));
      c19 = (gin[18] | (pin[18] & c18));
      c20 = (gin[19] | (pin[19] & c19));
      c21 = (gin[20] | (pin[20] & c20));
      c22 = (gin[21] | (pin[21] & c21));
      c23 = (gin[22] | (pin[22] & c22));
      c24 = (gin[23] | (pin[23] & c23));
      c25 = (gin[24] | (pin[24] & c24));
      c26 = (gin[25] | (pin[25] & c25));
      c27 = (gin[26] | (pin[26] & c26));
      c28 = (gin[27] | (pin[27] & c27));
      c29 = (gin[28] | (pin[28] & c28));
      c30 = (gin[29] | (pin[29] & c29));
      c31 = (gin[30] | (pin[30] & c30));
   end
   assign cout[0] = c0;
   assign cout[1] = c1;
   assign cout[2] = c2;
   assign cout[3] = c3;
   assign cout[4] = c4;
   assign cout[5] = c5;
   assign cout[6] = c6;
   assign cout[7] = c7;
   assign cout[8] = c8;
   assign cout[9] = c9;
   assign cout[10] = c10;
   assign cout[11] = c11;
   assign cout[12] = c12;
   assign cout[13] = c13;
   assign cout[14] = c14;
   assign cout[15] = c15;
   assign cout[16] = c16;
   assign cout[17] = c17;
   assign cout[18] = c18;
   assign cout[19] = c19;
   assign cout[20] = c20;
   assign cout[21] = c21;
   assign cout[22] = c22;
   assign cout[23] = c23;
   assign cout[24] = c24;
   assign cout[25] = c25;
   assign cout[26] = c26;
   assign cout[27] = c27;
   assign cout[28] = c28;
   assign cout[29] = c29;
   assign cout[30] = c30;
   assign cout[31] = c31;
endmodule


module cla
  (input wire [31:0]  a, b,
   input wire         cin,
   output wire [31:0] sum);

   // 32 x 1-bit modules
   wire [31:0] level_one_g;
   wire [31:0] level_one_p;
   genvar i;
   generate
      for (i = 0; i < 32; i = i + 1) begin
         gp1 bit1(.a(a[i]), .b(b[i]), .g(level_one_g[i]), .p(level_one_p[i]));
      end
   endgenerate

   // 1 x 32-bit module
   wire [31:0] c;
   gp32 full_add(.gin(level_one_g), .pin(level_one_p), .cin(cin), .cout(c));

   // compute sum from g/p/c
   genvar j;
   generate
      for (j = 0; j < 32; j = j + 1) begin
         assign sum[j] = a[j] ^ b[j] ^ c[j];
      end
   endgenerate 

endmodule
