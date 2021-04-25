`timescale 1ns/1ps
`include "ALU.v"

module alu_test;

    reg[31:0] instruction, reg_A, reg_B;

    wire signed [31:0] result;
    wire[2:0] flags;

    alu test_alu(flags, result, instruction, reg_A, reg_B);

    initial begin

        $dumpfile("test_ALU.vcd");
        $dumpvars(0, alu_test);

        $display("Format of output");
        $monitor("instruction\t= %32b \nop\t\t= %6b \nfunc\t\t= %6b \nreg_A\t\t= %h \nreg_B\t\t= %h \nreg_rs\t\t= %h \nreg_rt\t\t= %h \nresult\t\t= %h \nflags\t\t= %3b \n",
        instruction, test_alu.opcode, test_alu.func, reg_A, reg_B, test_alu.reg_RS, test_alu.reg_RT, result, flags);

        //// 1. add
        #10 
        $display("Add instruction");
        instruction <= 32'b0000_0000_0010_0000_0101_1000_0010_0000; //add $t3, $reg_B, $reg_A
        reg_A <= 32'b1000_0000_0000_0000_0000_0000_0000_0000;
        reg_B <= 32'b1000_0000_0000_0000_0000_0000_0000_0000;
        
        //// 2. addi
        #10
        $display("Addi instruction");
        instruction <= 32'b0010_0000_0000_0000_0000_0000_0001_0100; //addi $zero, $reg_A, 20
        reg_A <= 32'b0000_0010_0000_0010_0000_0100_0000_0010;
        reg_B <= 32'b1000_0000_0000_0010_0000_0000_0001_0001;

        //// 3. addu
        #10 
        $display("Addu instruction");
        instruction <= 32'b0000_0000_0000_0001_0101_1000_0010_0001; //addu $t3, $reg_A, $reg_B
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_0010;

        //// 4. addiu
        #10 
        $display("Addiu instruction");
        instruction <= 32'b0010_0100_0010_0010_0000_0000_0000_1001; //addiu $v0, $reg_B, 9
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;

        //// 5. sub
        #10 
        $display("Sub instruction");
        instruction <= 32'b0000_0000_0000_0001_0000_1000_0010_0010; //sub $at, $reg_A, $reg_B
        reg_A <= 32'b1111_1111_1111_1111_1111_1111_1101_1101;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0010_0101;
        
        //// 6. subu
        #10 
        $display("Subu instruction");
        instruction <= 32'b0000_0000_0000_0001_1100_1000_0010_0011; //subu $t9, $reg_A, $reg_B
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_0010;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_0001;

        //// 7. and
        #10
        $display("And instruction"); 
        instruction <= 32'b0000_0000_0010_0000_0000_0000_0010_0100; //and $zero, $reg_B, $reg_A
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_1001;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_1101;

        /// 8. andi
        #10 
        $display("Andi instruction");
        instruction <= 32'b0011_0000_0000_0001_0000_0000_0000_1111; //andi $at, $reg_A, 15
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_1001;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;

        //// 9. nor
        #10 
        $display("Nor instruction");
        instruction <= 32'b0000_0000_0000_0001_1001_0000_0010_0111; //nor $s2, $reg_A, $reg_B
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_1001;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_1101;

        //// 10. or
        #10 
        $display("Or instruction");
        instruction <= 32'b0000_0000_0010_0000_1000_0000_0010_0101; //or $s0, $reg_B, $reg_A
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_1001_0000;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_1101_0000;

        //// 11. ori
        #10 
        $display("Ori instruction");
        instruction <= 32'b0011_0100_0001_0001_1111_1111_1111_0100; //ori $s1, $reg_A, -12
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_1001;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;

        /// 12. xor
        #10 
        $display("Xor instruction");
        instruction <= 32'b0000_0000_0010_0000_0001_1000_0010_0110; //xor $v1, $reg_B, $reg_A
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_1001;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_1101;

        /// 13. xori
        #10 
        $display("Xori instruction");
        instruction <= 32'b0011_1000_0010_1111_0000_0000_0000_1001; //xori $t7, $reg_B, 9
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_1001;

        /// 14. beq
        #10 
        $display("Beq instruction");
        instruction <= 32'b0001_0000_0010_0000_0000_0000_0000_1010; //beq $reg_B, $reg_A, 10
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_1001;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_1001;

        /// 15. bne
        #10 
        $display("Bne instruction");
        instruction <= 32'b0001_0100_0000_0001_0000_0000_0000_0101; //bne $reg_A, $reg_B, 5
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_1001;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_1001;

        //// 16. slt
        #10 
        $display("Slt instruction");
        instruction <= 32'b0000_0000_0010_0000_0111_0000_0010_1010; //slt $t6, $reg_B, $reg_A
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_1000;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_0001;

        //// 17. slti
        #10 
        $display("Slti instruction");
        instruction <= 32'b0010_1000_0000_1000_1111_1111_1111_1100; //slti $t0, $reg_A, -4
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0010_0000;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;

        //// 18. sltiu
        #10 
        $display("Sltiu instruction");
        instruction <= 32'b0010_1100_0010_1011_0000_0000_0000_0101; //sltiu $t3, $reg_B, 5
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        reg_B <= 32'b1111_1111_1111_1111_1111_1111_1111_1101;

        //// 19. sltu
        #10 
        $display("Sltu instruction");
        instruction <= 32'b0000_0000_0000_0001_1001_0000_0010_1011; //sltu $s2, $reg_A, $reg_B
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_0001;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_1000;

        //// 20. lw
        #10 
        $display("Lw instruction");
        instruction <= 32'b1000_1100_0011_0000_0000_0000_0000_0000; //lw $s0, 0($reg_B)
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        reg_B <= 32'b0000_0000_0000_0000_0000_1000_0001_0000;

        //// 21. sw
        #10 
        $display("Sw instruction");
        instruction <= 32'b1010_1100_0000_1000_0000_0000_0000_1000; //sw $t0, 8($reg_A)
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_1000;

        //// 22. sll
        #10 
        $display("Sll instruction");
        instruction <= 32'b0000_0000_0000_0001_0111_1001_0000_0000; //sll $t7, $reg_B, 4
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        reg_B <= 32'b1101_1101_1101_1101_1101_1101_1101_1101;

        /// 23. sllv
        #10 
        $display("Sllv instruction");
        instruction <= 32'b0000_0000_0010_0000_1011_1000_0000_0100; //sllv $s7, $reg_A, $reg_B
        reg_A <= 32'b1101_1101_1101_1101_1101_1101_1101_1101;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_0100;

        //// 24. srl
        #10 
        $display("Srl instruction");
        instruction <= 32'b0000_0000_0000_0000_0111_0000_1100_0010; //srl $t6, $reg_A, 3
        reg_A <= 32'b1101_1101_1101_1101_1101_1101_1101_1101;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_0100;

        /// 25. srlv
        #10 
        $display("Srlv instruction");
        instruction <= 32'b0000_0000_0000_0001_1100_1000_0000_0110; //srlv $t9, $reg_B, $reg_A
        reg_A <= 32'b0000_0000_0000_0000_0000_0000_0000_0100;
        reg_B <= 32'b1101_1101_1101_1101_1101_1101_1101_1101;

        //// 26. sra
        #10 
        $display("Sra instruction");
        instruction <= 32'b0000_0000_0000_0000_0101_1000_1000_0011; //sra $t3, $reg_A, 2
        reg_A <= 32'b1101_1101_1101_1101_1101_1101_1101_1101;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;

        /// 27. srav
        #10 
        $display("Srav instruction");
        instruction <= 32'b0000_0000_0010_0000_0000_0000_0000_0111; //srav $s8, $reg_A, $reg_B
        reg_A <= 32'b1101_1101_1101_1101_1101_1101_1101_1101;
        reg_B <= 32'b0000_0000_0000_0000_0000_0000_0000_0100;
        
        #10 $finish;
    end
endmodule