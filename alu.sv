`define OP_ADD 4'b0000
`define OP_SUB 4'b0001
`define OP_MUL 4'b0010
`define OP_DIV 4'b0011
`define OP_SHIFT_LEFT 4'b0100
`define OP_SHIFT_RIGHT 4'b0101
`define OP_ROTATE_LEFT 4'b0110
`define OP_ROTATE_RIGHT 4'b0111
`define OP_AND 4'b1000
`define OP_OR 4'b1001
`define OP_XOR 4'b1010
`define OP_NOR 4'b1011
`define OP_NAND 4'b1100
`define OP_XNOR 4'b1101
`define OP_GT 4'b1110
`define OP_EQ 4'b1111

`timescale 1ns / 1ps

module testbench;
  reg[7:0] a;
  reg[7:0] b;
  reg[3:0] op;

  wire[7:0] out;
  wire carry;

  reg [7:0] test_data;

  alu8bit uut (
    a,
    b,             
    op,
    out,
    carry
  );

  integer i;
  initial begin
    a = 8'h00;
    b = 4'h00;
    op = 4'h0;

    for (i = 0; i <= 15; i = i + 1) begin
      op = op + 8'h01;
      #10;
    end;

    a = 8'hF4;
    b = 8'h0B;
    op = `OP_EQ;
    #10;

    test_data <= out;
    assert(test_data == 8'd0);
  end

endmodule

module alu8bit (
  input [7:0] a,
  input [7:0] b,          
  input [3:0] op,
  output [7:0] out,
  output carry
);
  reg [7:0] result;
  wire [8:0] carry8bit;

  always @(*) begin
    case(op)
      `OP_ADD:
        result = a + b; 
      `OP_SUB:
        result = a - b;
      `OP_MUL:
        result = a * b;
      `OP_DIV:
        result = a / b;
      `OP_SHIFT_LEFT:
        result = a << 1;
      `OP_SHIFT_RIGHT:
        result = a >> 1;
      `OP_ROTATE_LEFT:
        result = { a[6:0], a[7] };
      `OP_ROTATE_RIGHT:
        result = { a[0], a[7:1] };
      `OP_AND:
        result = a & b;
      `OP_OR:
        result = a | b;
      `OP_XOR:
        result = a ^ b;
      `OP_NOR:
        result = ~(a | b);
      `OP_NAND:
        result = ~(a & b);
      `OP_XNOR:
        result = ~(a ^ b);
      `OP_GT:
        result = (a > b) ? 8'd1 : 8'd0;
      `OP_EQ:
        result = (a == b) ? 8'd1 : 8'd0;
      default:
        result = a + b; 
    endcase
  end

  assign out = result;
  assign carry8bit = { 1'b0, a } + { 1'b0, b };
  assign carry = carry8bit[8];

endmodule
