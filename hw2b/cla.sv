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

   // TODO: your code here
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
   // TODO: your code here
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
         gp1 bit1(.a(a[i]),
                  .b(b[i]), 
                  .g(level_one_g[i]), 
                  .p(level_one_p[i]));
      end
   endgenerate

   // 8 4-bit modules
   wire level_two_g[8];
   wire level_two_p[8];
   wire [2:0] level_two_c[8];
   genvar j;
   generate
      for (j = 0; j < 8; j = j + 1) begin
         gp4 bit4(.gin(level_one_g[4*j+3:4*j]),
                  .pin(level_one_p[4*j+3:4*j]), 
                  .cin(cin), 
                  .gout(level_two_g[j]),
                  .pout(level_two_p[j]),
                  .cout(level_two_c[j]))
      end
   endgenerate

   // 4 8-bit modules
   wire level_three_g[4];
   wire level_three_p[4];
   wire [6:0] level_three_c[4];
   genvar k;
   generate
      for (k = 0; k < 4; k = k + 1) begin
         gp8 bit8(.gin(level_two_g[8*k+7 : 8*k]),
                  .pin(level_two_p[8*k+7 : 8*k]), 
                  .cin(cin), 
                  .gout(level_three_g[k]),
                  .pout(level_three_p[k]),
                  .cout(level_three_c[k]))
      end
   endgenerate
endmodule
