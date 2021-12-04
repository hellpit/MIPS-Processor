--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.NUMERIC_STD.UNSIGNED;

entity InstructionMemory_tb is
end InstructionMemory_tb;

architecture arch of InstructionMemory_tb is
	constant T : time := 20 ns;

	--input
	signal clk, MemRSignal : std_logic;
	signal PC: std_logic_vector(31 downto 0);
	--output
	signal Dout: std_logic_vector(7 downto 0);

	-- declare record type
	type test_vector is record
		MemRSignal : std_logic;
		PC : std_logic_vector(31 downto 0);
		Dout : std_logic_vector(7 downto 0);
	end record;

	type test_vector_array is array (natural range <>) of test_vector;
	constant test_vectors : test_vector_array := (
		--MemRSignal, PC, Dout
		('1',x"00000000",x"01"), --1
		('1',x"00000004",x"2A"), --42
		('1',x"00000008",x"40"), --64
		('1',x"0000000C",x"20"),
		('1',x"00000010",x"01"),
		('0',x"00000014",x"01"),
		('1',x"00000018",x"48"),
		('1',x"0000001C",x"25"),
		('0',x"00000020",x"25"),
		('1',x"00000024",x"11"),
		('0',x"00000028",x"11"),
		('1',x"0000002C",x"01"),
		('1',x"00000030",x"01"),
		('1',x"00000034",x"2B"),
		('1',x"00000038",x"50"),
		('0',x"0000003C",x"50"));
begin

	InstructionMemory_unit : entity work.InstructionMemory
		port map (clk=>clk, MemRSignal=>MemRSignal, PC=>PC, Dout=>Dout);

	--cont. clock	
    	process 
    	begin

		for i in test_vectors'range loop
			clk <= '0';
			wait for T/2;

			MemRSignal <= test_vectors(i).MemRSignal;
			PC <= test_vectors(i).PC;

			clk <= '1';
			wait for T/2;
			
			assert	(
					(Dout = test_vectors(i).Dout)
				)			
            		-- image is used for string-representation of integer etc.
			--expected test.Dout, returned actual.Dout
            		report  "At test_vector " & integer'image(i) & ": Expected " & integer'image(to_integer(unsigned(test_vectors(i).Dout))) & ", returned " & integer'image(to_integer(unsigned(Dout)))
                    	severity error;
        	end loop;
		wait;
    	end process;

end arch;
		
