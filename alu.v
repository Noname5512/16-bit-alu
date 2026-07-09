module ALU_16bit (
    A,B,ALU_Sel,Result,Zero,carry,overflow,negative,borrow
);
    input [15:0] A, B;
    input [3:0] ALU_Sel;
    output reg [15:0] Result;
    output reg carry , borrow ;
    output Zero , overflow , negative ;
    reg temp ; // temp to store borrow

    parameter ADD = 4'b0000, SUB = 4'b0001, AND = 4'b0010, OR = 4'b0011 , XOR = 4'b0100
              , NOT_A = 4'b0101 , NOT_B = 4'b0110 , SHIFT_LEFT = 4'b0111 , 
              SHIFT_RIGHT = 4'b1000 , COMPARE = 4'b1001 , INCREMENT = 4'b1010 ,
              DECREMENT = 4'b1011 ;

    assign Zero = ~|Result;
    assign negative = Result[15];
    assign overflow =
                (ALU_Sel == ADD) ?
                (( A[15] &  B[15] & ~Result[15]) |     
                (~A[15] & ~B[15] &  Result[15])) :

                (ALU_Sel == SUB) ?
                (( A[15] & ~B[15] & ~Result[15]) |
                (~A[15] &  B[15] &  Result[15])) : 1'b0;

    always @(*) begin
        Result = 16'b0;
        carry = 1'b0;
        borrow = 1'b0;
        case (ALU_Sel)
            ADD : {carry,Result} = A + B;
            SUB : begin 
                {temp,Result} = A - B;
                borrow = ~temp; 
            end
            AND : Result = A & B;
            OR : Result = A | B;
            XOR : Result = A ^ B;
            NOT_A : Result = ~A;
            NOT_B : Result = ~B;
            SHIFT_LEFT : Result = A << 1;
            SHIFT_RIGHT : Result = A >> 1;
            COMPARE : begin 
                if (A == B) Result = 16'b1;
                else if (A > B) Result = 16'b10;
                else Result = 16'b11;
            end 
            INCREMENT : Result = A + 1;
            DECREMENT : Result = A - 1;
            default: Result = 16'b0;
        endcase
    end
endmodule


