module alu(flags, result, instruction, reg_A, reg_B);

    /* Initializing inputs and outputs */
    input[31:0] instruction, reg_A, reg_B;
    output signed [31:0] result;
    output[2:0] flags;

    wire[5:0] opcode; //Variable to store the opcode
    reg[5:0] func; //Variable to store the function code
    logic extra; //Temp bit used for sign extension. Mainly used to check for overflow

    reg[31:0] ALU_result; //Buffer register for the output
    reg[2:0] ALU_flags; //Buffer register for the flags
    reg[31:0] reg_RS, reg_RT; //Buffer register for the ALU

    assign opcode = instruction[31:26];

    always @(*) begin

        // Assignment of the rs register
        if(instruction[25:21] == 5'b00000) reg_RS = reg_A;
        else if (instruction[25:21] == 5'b00001) reg_RS = reg_B;
        else reg_RS = 0;

        // Assignment of the rt register
        if(instruction[20:16] == 5'b00000) reg_RT = reg_A;
        else if (instruction[20:16] == 5'b00001) reg_RT = reg_B;
        else reg_RT = 0;

        // Set all flags to be 0 at the start
        ALU_flags = 3'b000;

        //Set the function code to be 0 at the start
        func = 6'b000000;

        case(opcode)

            /* For R-type instructions */
            6'b000000: begin

                func = instruction[5:0];

                case(func)

                    6'b100000: begin //Add instruction

                        {extra, ALU_result} = $signed({reg_RS[31], reg_RS}) + $signed({reg_RT[31], reg_RT}); //Sign extending and adding
                        ALU_flags[2] = ({extra, ALU_result[31]} == 2'b01 || {extra, ALU_result[31]} == 2'b10); //Detect overflow

                        if($signed(ALU_result) < 0) ALU_flags[1] = 1'b1; //Checks if result is negative, if it is then set negative flag

                        else if(ALU_result == 32'd0) ALU_flags[0] = 1'b1; //Checks if result is 0, if it is then set zero flag
                       
                    end

                    6'b100001: ALU_result = reg_RS + reg_RT; //Addu instruction

                    6'b100010: begin //Sub instruction
                        
                        {extra, ALU_result} = $signed({reg_RS[31], reg_RS}) - $signed({reg_RT[31], reg_RT}); //Sign extending and subracting
                        ALU_flags[2] = ({extra, ALU_result[31]} == 2'b01 || {extra, ALU_result[31]} == 2'b10); //Detect overflow

                        if($signed(ALU_result) < 0) ALU_flags[1] = 1'b1; //Checks if result is negative, if it is then set negative flag

                        else if(ALU_result == 32'd0) ALU_flags[0] = 1'b1; //Checks if result is 0, if it is then set zero flag'

                    end    

                    6'b100011: ALU_result = reg_RS - reg_RT; //Subu instruction

                    6'b000000: ALU_result = reg_RT << instruction[10:6]; //Sll instruction

                    6'b000100: ALU_result = reg_RT << reg_RS; //Sllv instruction

                    6'b000010: ALU_result = reg_RT >> instruction[10:6]; //Srl instruction

                    6'b000110: ALU_result = reg_RT >> reg_RS; //Srlv instruction

                    6'b000011: ALU_result = reg_RT >>> instruction[10:6]; //Sra instruction

                    6'b000111: ALU_result = reg_RT >>> reg_RS; //Srav instruction

                    6'b100100: ALU_result = reg_RS & reg_RT; //And instruction

                    6'b100111: ALU_result = ~(reg_RS | reg_RT); //Nor instruction

                    6'b100101: ALU_result = reg_RS | reg_RT; //Or instruction

                    6'b100110: ALU_result = reg_RS ^ reg_RT; //Xor instruction

                    6'b101010: begin //Slt instruction
                        
                        ALU_result = ($signed(reg_RS) < $signed(reg_RT)) ? 1 : 0; 

                        if(ALU_result) ALU_flags[1] = 1'b1; //Checks if the slt instruction succeeds and set flag accordingly

                    end

                    6'b101011: begin //Sltu instruction
                        
                        ALU_result = (reg_RS < reg_RT) ? 1 : 0; 

                        if(ALU_result) ALU_flags[1] = 1'b1; //Checks if the sltu instruction succeeds and set flag accordingly

                    end

                endcase
            end

            /* For I-type instructions */
            6'b001000: begin //Addi instruction
            
                {extra, ALU_result} = $signed({reg_RS[31], reg_RS}) + $signed({{17{instruction[15]}}, instruction[15:0]}); //Sign extending and adding
                ALU_flags[2] = ({extra, ALU_result[31]} == 2'b01 || {extra, ALU_result[31]} == 2'b10); //Detect overflow

                if($signed(ALU_result) < 0) ALU_flags[1] = 1'b1; //Checks if result is negative, if it is then set negative flag

                else if(ALU_result == 32'd0) ALU_flags[0] = 1'b1; //Checks if result is 0, if it is then set zero flag

            end

            6'b001001: ALU_result = reg_RS + {{16{instruction[15]}}, instruction[15:0]}; //Addiu instruction

            6'b001100: ALU_result = reg_RS & {{16{1'b0}},instruction[15:0]}; //Andi instruction

            6'b001101: ALU_result = reg_RS | {{16{1'b0}},instruction[15:0]}; //Ori instruction

            6'b001110: ALU_result = reg_RS ^ {{16{1'b0}},instruction[15:0]}; //Xori instruction

            6'b000100: begin //Beq instruction
                
                ALU_result = ($signed(reg_RS) == $signed(reg_RT)) ? instruction[15:0] : 0; //Branch to said instruction if equal, set to 0 otherwise
                
                if(ALU_result == 0) ALU_flags[0] = 1'b1; //If not set to zero along with the zero flag
                
            end

            6'b000101: begin //Bne instruction

                ALU_result = ($signed(reg_RS) != $signed(reg_RT)) ? instruction[15:0] : 0; //Branch to said instruction
                
                if(ALU_result == 0) ALU_flags[0] = 1'b1; //If not set to zero along with the zero flag

            end

            6'b001010: begin //Slti instruction
                
                ALU_result = ($signed(reg_RS) < $signed({{16{instruction[15]}}, instruction[15:0]})) ? 1 : 0; 

                if(ALU_result) ALU_flags[1] = 1'b1; //Checks if the slti instruction succeeds and set flag accordingly

            end

            6'b001011: begin //Sltiu instruction
                
                ALU_result = reg_RS < {{16{instruction[15]}}, instruction[15:0]} ? 1 : 0; 

                if(ALU_result) ALU_flags[1] = 1'b1; //Checks if the sltiu instruction succeeds and set flag accordingly

            end

            6'b100011: ALU_result = $signed(reg_RT) + $signed({{16{instruction[15]}}, instruction[15:0]}); //Lw instruction

            6'b101011: ALU_result = $signed(reg_RT) + $signed({{16{instruction[15]}}, instruction[15:0]}); //Sw instruction

        endcase
    end
                   
    assign result = ALU_result;
    assign flags = ALU_flags;

endmodule