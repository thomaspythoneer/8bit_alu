module alu (
    input  [7:0]  a_in,
    input  [7:0]  b_in,
    input  [3:0]  command_in,
    input         oe,
    output [15:0] d_out
);

    parameter ADD  = 4'b0000,
              INC  = 4'b0001,
              SUB  = 4'b0010,
              DEC  = 4'b0011,
              MUL  = 4'b0100,
              DIV  = 4'b0101,
              SHL  = 4'b0110,
              SHR  = 4'b0111,
              AND  = 4'b1000,
              OR   = 4'b1001,
              INV  = 4'b1010,
              NAND = 4'b1011,
              NOR  = 4'b1100,
              XOR  = 4'b1101,
              XNOR = 4'b1110,
              BUF  = 4'b1111;

    reg [15:0] out;

  always @(command_in,a_in,b_in) begin
        case (command_in)
            ADD  : out = a_in + b_in;
            INC  : out = a_in + 1'b1;
            SUB  : out = a_in - b_in;
            DEC  : out = a_in - 1'b1;
            MUL  : out = a_in * b_in;
            DIV  : out = (b_in != 0) ? (a_in / b_in) : 16'd0;
            SHL  : out = a_in << 1;
            SHR  : out = a_in >> 1;
            INV  : out = ~a_in;
            AND  : out = a_in & b_in;
            OR   : out = a_in | b_in;
            NAND : out = ~(a_in & b_in);
            NOR  : out = ~(a_in | b_in);
            XOR  : out = a_in ^ b_in;
            XNOR : out = ~(a_in ^ b_in);
            BUF  : out = a_in;
            default : out = 16'd0;
        endcase
    end

    assign d_out = (oe) ? out : 16'hZZZZ;

endmodule
