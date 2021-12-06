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
			('1', x"00000004"),
			('0', x"00000008"),
			('0', x"0000000C"),
			('0', x"00000010"),
			('0', x"00000014"),
			('0', x"00000018"),
			('0', x"0000001C"),
			('0', x"00000020")
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