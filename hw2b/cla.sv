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

endmodule



module cla
  (input wire [31:0]  a, b,
   input wire         cin,
   output wire [31:0] sum);

   // TODO: your code here

endmodule
