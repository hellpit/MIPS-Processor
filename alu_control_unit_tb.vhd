library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_control_unit_tb is
end alu_control_unit_tb;

architecture arch of alu_control_unit_tb is
    constant T : time := 20 ns;

    --input
    signal clk : std_logic;
    signal ALU_Function: std_logic_vector (5 downto 0); -- 6 bits
    signal ALU_Op : std_logic_vector (2 downto 0); -- 3 bits that will be taken from control unit
    --output
    signal Operation : std_logic_vector (3 downto 0); -- 4 bits that will be passed for ALU to do operation

    -- declare record type
    type test_vector is record
	ALU_Op : std_logic_vector (2 downto 0);
        ALU_Function : std_logic_vector (5 downto 0);
        Operation : std_logic_vector (3 downto 0);
    end record;

    type test_vector_array is array (natural range <>) of test_vector;
    constant test_vectors : test_vector_array := 
    (
       --ALU_Op, ALU Function, Operation
	--rtype
	("010", "100000", "0010"), --add
	("010", "100010", "0110"), --sub
	("010", "100100", "0000"), --and
	("010", "100101", "0001"), --or
	("010", "101010", "0111"), --slt
	("010", "111010", "0100"), --xor
	--itype
	("101", "001000", "1010"), --addi
	("101", "001100", "1000"), --andi
	("101", "001101", "1001"),  --ori
	("101", "001010", "1111"), --slti
	--branch
	("001", "000100", "1100"), --beq
	("001", "000101", "1101"), --bne
	("001", "000110", "1110")  --blez
    );
begin

    control_unit_unit : entity work.alu_control_unit--INSERT FILENAME HERE
        port map( 
		ALU_Op => ALU_Op, 
		ALU_Function => ALU_Function, 
		Operation => Operation
                
                 );

    --cont. clock
        process 
        begin

        for i in test_vectors'range loop
            clk <= '0';
            wait for T/2;

            ALU_Op <= test_vectors(i).ALU_Op;
            ALU_Function <= test_vectors(i).ALU_Function;

            clk <= '1';
            wait for T/2;
            
            assert    (
                    (Operation = test_vectors(i).Operation)
                )            
                    -- image is used for string-representation of integer etc.
                    report  "test_vector " & integer'image(i) & " failed "
                        severity error;
            end loop;
        wait;
        end process;

end arch;






