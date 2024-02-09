/*Ben Menko 70343505*/

`timescale 1ns / 1ns

// quotient = dividend / divisor

module divider_unsigned (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);
    // creating wire arrays to connect modules
    logic [31:0] div_array [33];
    logic [31:0] rem_array [33];
    logic [31:0] quo_array [33];

    // initializing wires as applicable
    assign div_array[0] = i_dividend;
    assign rem_array[0] = 32'b0;
    assign quo_array[0] = 32'b0;

    // connecting modules using wire arrays
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin
            divu_1iter intermediate_divider(
                .i_dividend(div_array[i]), 
                .i_divisor(i_divisor), 
                .i_remainder(rem_array[i]), 
                .i_quotient(quo_array[i]), 
                .o_dividend(div_array[i+1]), 
                .o_remainder(rem_array[i+1]), 
                .o_quotient(quo_array[i+1])
                );
        end
    endgenerate

    // outputting quotient and remainder wires, div_array[32] is unconnected
    assign o_quotient = quo_array[32];
    assign o_remainder = rem_array[32];
endmodule


module divu_1iter (
    input  wire [31:0] i_dividend,
    input  wire [31:0] i_divisor,
    input  wire [31:0] i_remainder,
    input  wire [31:0] i_quotient,
    output wire [31:0] o_dividend,
    output wire [31:0] o_remainder,
    output wire [31:0] o_quotient
);
    /*
    for (int i = 0; i < 32; i++) {
        remainder = (remainder << 1) | ((dividend >> 31) & 0x1);
        if (remainder < divisor) {
            quotient = (quotient << 1);
        } else {
            quotient = (quotient << 1) | 0x1;
            remainder = remainder - divisor;
        }
        dividend = dividend << 1;
    }
    */
    
    always_comb begin
        if (((i_remainder << 1) | ((i_dividend >> 31) & 0x1)) < i_divisor) begin
            assign o_quotient = i_quotient << 1;
            assign o_remainder = i_remainder
        end else begin
            assign o_quotient = ((i_quotient << 1) | (0x1));
            assign o_remainder = i_remainder - i_divisor;
        end
        assign o_dividend = i_dividend << 1;
    end
endmodule
