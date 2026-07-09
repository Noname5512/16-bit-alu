`timescale 1ns/1ps
module alu_tb ;
    reg [15:0] A, B;
    reg [3:0] ALU_Sel;
    wire [15:0] Result;
    wire Zero , overflow , negative , carry , borrow ;

    ALU_16bit DUT (
        .A(A),
        .B(B),
        .ALU_Sel(ALU_Sel),
        .Result(Result),
        .Zero(Zero),
        .overflow(overflow),
        .negative(negative),
        .carry(carry),
        .borrow(borrow)
    );

    task test ;
        input [3:0] sel;
        input [15:0] a,b;
        begin
            ALU_Sel = sel;
            A =a;
            B = b;
            #10 ;

            $display("--------------------------------------------");
            $display("ALU_Sel = %d", ALU_Sel);
            $display("A = %h (%0d)", A, $signed(A));
            $display("B = %h (%0d)", B, $signed(B));
            $display("Result = %h (%0d)", Result, $signed(Result));
            $display("Zero=%b Carry=%b Borrow=%b Overflow=%b Negative=%b",
                    Zero, carry, borrow, overflow, negative);

        end
    endtask
    
    initial begin

        // ADD 
        test(4'd0,16'd0,16'd0);
        test(4'd0,16'd5,16'd10);
        test(4'd0,16'hFFFF,16'd1);
        test(4'd0,16'h7FFF,16'd1);
        test(4'd0,16'h8000,16'h8000);

        //SUB
        test(4'd1,16'd10,16'd5);
        test(4'd1,16'd5,16'd10);
        test(4'd1,16'd0,16'd1);
        test(4'd1,16'h8000,16'd1);
        test(4'd1,16'h7FFF,16'hFFFF);

        //AND
        test(4'd2,16'hFFFF,16'h1234);
        test(4'd2,16'hAAAA,16'h5555);

        //OR 
        test(4'd3,16'hAAAA,16'h5555);
        test(4'd3,16'h1234,16'h000F);

        // XOR 
        test(4'd4,16'hAAAA,16'h5555);
        test(4'd4,16'hFFFF,16'hFFFF);

        // NOT A
        test(4'd5, 16'h0000, 16'h0000);
        test(4'd5, 16'hAAAA, 16'h0000);
        test(4'd5, 16'hFFFF, 16'h0000);
        test(4'd5, 16'h1234, 16'h0000);

        // NOT B
        test(4'd6, 16'h0000, 16'h0000);
        test(4'd6, 16'h0000, 16'h5555);
        test(4'd6, 16'h0000, 16'hFFFF);
        test(4'd6, 16'h0000, 16'h1234);

        // SHIFT LEFT
        test(4'd7, 16'h0001, 16'h0000);
        test(4'd7, 16'h000F, 16'h0000);
        test(4'd7, 16'h8000, 16'h0000);
        test(4'd7, 16'h4001, 16'h0000);
        test(4'd7, 16'h7FFF, 16'h0000);

        // SHIFT RIGHT
        test(4'd8, 16'h0002, 16'h0000);
        test(4'd8, 16'h0003, 16'h0000);
        test(4'd8, 16'h8000, 16'h0000);
        test(4'd8, 16'hFFFF, 16'h0000);

        $finish;
    end
    
    initial begin
        $dumpfile("ALU_16Bit.vcd");
        $dumpvars(0,alu_tb);
    end
    


endmodule
