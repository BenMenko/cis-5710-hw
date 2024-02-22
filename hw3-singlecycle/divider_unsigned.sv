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
    wire [31:0] div_array[33];
    wire [31:0] rem_array[33];
    wire [31:0] quo_array[33];

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
    // creating necesarry logic variables
    logic [31:0] quo, rem, div;

    // logic
    always_comb begin
        rem = ((i_remainder << 1) | ((i_dividend >> 31) & 32'b1));
        if (rem < i_divisor) begin
            quo = i_quotient << 1;
        end else begin
            quo = ((i_quotient << 1) | 32'b1);
            rem = rem - i_divisor;
        end
        div = i_dividend << 1;
    end

    // connect output wires
    assign o_quotient = quo;
    assign o_dividend = div;
    assign o_remainder = rem;

endmodule


/*
Division algorithm
for (int i = 0; i < 32; i++) {
    remainder = (remainder << 1) | ((dividend >> 31) & 32'b1);
    if (remainder < divisor) {
        quotient = (quotient << 1);
    } else {
        quotient = (quotient << 1) | 0x1;
        remainder = remainder - divisor;
    }
    dividend = dividend << 1;
}
*/
