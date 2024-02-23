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
         gp1 bit1(.a(a[i]), 
                  .b(b[i]), 
                  .g(level_one_g[i]), 
                  .p(level_one_p[i]));
      end
   endgenerate


   // 4 x 8-bit modules
   wire g0, g1, g2, g3;
   wire p0, p1, p2, p3;
   wire [6:0] c0, c1, c2, c3;

   gp8 gp0(
      .gin(level_one_g[7:0]),
      .pin(level_one_p[7:0]),
      .cin(cin),
      .gout(g0),
      .pout(p0),
      .cout(c0)
   );

   wire cin2;
   assign cin2 = ((cin & p0) | g0);

   gp8 gp1(
      .gin(level_one_g[15:8]),
      .pin(level_one_p[15:8]),
      .cin(cin2),
      .gout(g1),
      .pout(p1),
      .cout(c1)
   );

   wire cin3;
   assign cin3 = ((cin & p0 & p1) | (g0 & p1) | g1);

   gp8 gp2(
      .gin(level_one_g[23:16]),
      .pin(level_one_p[23:16]),
      .cin(cin3), 
      .gout(g2),
      .pout(p2),
      .cout(c2)
   );

   wire cin4;
   assign cin4 = ((cin & p0 & p1 & p2) | (g0 & p1 & p2) | (g1 & p2) | g2);

   gp8 gp3(
      .gin(level_one_g[31:24]),
      .pin(level_one_p[31:24]),
      .cin(cin4),
      .gout(g3),
      .pout(p3),
      .cout(c3)
   );

   wire [31:0] c;
   assign c[0] = cin;
   assign c[7:1] = c0;
   assign c[8] = cin2;
   assign c[15:9] = c1;
   assign c[16] = cin3;
   assign c[23:17] = c2;
   assign c[24] = cin4;
   assign c[31:25] = c3;

   // compute sum from g/p/c
   genvar j;
   generate
      for (j = 0; j < 32; j = j + 1) begin
         assign sum[j] = a[j] ^ b[j] ^ c[j];
      end
   endgenerate 

endmodule
