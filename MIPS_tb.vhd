--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MIPS_tb is
end MIPS_tb;

architecture arch of MIPS_tb is
	constant T : time := 20 ns;

	--input
	signal clk : std_logic;
	signal reset : std_logic;

	--output
	signal newPC : std_logic_vector(31 downto 0);
	
	-- declare record type
	type test_vector is record
		reset : std_logic;
		newPC : std_logic_vector(31 downto 0);
	end record;

	type test_vector_array is array (natural range <>) of test_vector;
	constant test_vectors : test_vector_array := (
			--reset, newPC
			('0', x"00000008"), --x"012A4020", add 8, 9, 10
			('0', x"0000000C"), --x"014B4822", sub 9, 10, 11
			('0', x"00000010"), --x"018D5824", and 10, 11, 12
			('0', x"00000014"), --x"014B4825", or 9, 10, 11
			('0', x"00000018"), --x"8E110001", lw 17, 0(16)
			('0', x"0000001C"), --x"AE300000", sw 16, 0(17)
			('0', x"00000020"), --x"0232802A", slt s0 s1 s2
			('0', x"00000024"), --x"01CF6826", xor 13 14 15
			('0', x"00000028"), --x"000F7040", sll 14 15 0x001
			('0', x"0000002C"), --x"000F7082", srl 14 15 0x002
			('0', x"00000030"), --x"2230FFFF", addi 16, 17, 0xFFFF
			('0', x"00000034"), --x"3128FFFF", andi 8 9 0xffff
			('0', x"00000038"), --x"3528FFFF", ori 8 9 0xffff
			('0', x"0000003C") --x"29491111", slti 9, 10, 0x1111
		);
begin

	MIPS_unit : entity work.MIPS
		port map(
				clk=>clk, 
				reset=>reset, 
				newPC=>newPC
		);
	--cont. clock	
    	process 
    	begin

		for i in test_vectors'range loop
			clk <= '0';
			wait for T/2;

			--input at rising edge
			reset <= test_vectors(i).reset;

			clk <= '1';
			wait for T/2;
			
			assert	(
					(newPC = test_vectors(i).newPC)
				)			
            		-- image is used for string-representation of integer etc.
            		report  "At test_vector " & integer'image(i) & ": Expected " & integer'image(to_integer(unsigned(test_vectors(i).newPC))) & ", returned " & integer'image(to_integer(unsigned(newPC)))
                    	severity error;
        	end loop;
		wait;
    	end process;

end arch;