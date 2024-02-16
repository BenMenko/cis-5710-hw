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
   logic carry = cin;
   logic p0 = pin[0];
   logic p1 = pin[1];
   logic p2 = pin[2];
   logic p3 = pin[3];
   logic g0 = gin[0];
   logic g1 = gin[1];
   logic g2 = gin[2];
   logic g3 = gin[3];
   logic c1out, c2out, c3out, pOut, gOut;
   always_comb begin
      c1out = (carry & p0) || g0;
      c2out = (g0 & p1) || g1 || (carry & p0 & p1);
      c3out = g2 || (g1 & p2) || (g0 & p1 & p2) || (carry & p0 & p1 & p2);
      pOut = p0 & p1 & p2 & p3;
      gOut = (g0 & p1 & p2 & p3) || (p3 & g1 & p2) || (g2 & p3) || g3;
   end
   assign gout = gOut;
   assign pout = pOut;
   assign cout[2] = c3out;
   assign cout[1] = c2out;
   assign cout[0] = c1out;
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
