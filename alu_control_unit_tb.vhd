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
    signal ALU_Op : std_logic_vector (1 downto 0); -- 2bits that will be taken from control unit
    --output
    signal Operation : std_logic_vector (3 downto 0); -- 4 bits that will be passed for ALU to do operation

    -- declare record type
    type test_vector is record
	ALU_Op : std_logic_vector (1 downto 0);
        ALU_Function : std_logic_vector (5 downto 0);
        Operation : std_logic_vector (3 downto 0);
    end record;

    type test_vector_array is array (natural range <>) of test_vector;
    constant test_vectors : test_vector_array := 
    (
       --ALU_Op, ALU Function, Operation
	("01", "100000", "0010"), --add
	("01", "100010", "0110"), --sub
	("01", "100100", "0000"), --and
	("01", "100101", "0001"), --or
	("01", "101010", "0001"), --slt
	("01", "111010", "0100"), --slt

	("10", "001000", "1111"), --addi
	("10", "001100", "0000"), --andi
	("10", "001101", "1001"),  --ori
	("10", "001010", "1111") --slti
	
    );
begin

    control_unit_unit : entity work.alu_control_unit--INSERT FILENAME HERE
        port map( 
		clk => clk,
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



