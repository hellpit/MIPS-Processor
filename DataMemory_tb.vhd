--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.NUMERIC_STD.UNSIGNED;

entity DataMemory_tb is
end DataMemory_tb;

architecture arch of DataMemory_tb is
	constant T : time := 20 ns;

	--input
	signal clk : std_logic;
	signal address : std_logic_vector(31 downto 0);
	signal writeData : std_logic_vector(31 downto 0);
	signal memRead, memWrite : std_logic;

	--output
	signal readData : std_logic_vector(31 downto 0);

	-- declare record type
	type test_vector is record
		address : std_logic_vector(31 downto 0);
		writeData : std_logic_vector(31 downto 0);
		memRead, memWrite : std_logic;
		readData : std_logic_vector(31 downto 0);
	end record;

	type test_vector_array is array (natural range <>) of test_vector;
	constant test_vectors : test_vector_array := (
		--addr, write, memR, memW, read
		(x"00000000", x"00000000", '1', '0', x"00000000"), --read 0th element
		(x"00000004", x"aaaaaaaa", '0', '1', x"00000000"), --write xAAAAAAAA to 1st element
		(x"00000004", x"00000000", '1', '0', x"aaaaaaaa"), --read 1st element (expect xAAAAAAAA)
		(x"00000004", x"aeaeaeae", '0', '1', x"aaaaaaaa"), --write xAEAEAEAE to 1st element
		(x"00000008", x"bcbcbcbc", '0', '1', x"aaaaaaaa"), --write xBCBCBCBC to 2nd element
		(x"0000000C", x"12345678", '0', '1', x"aaaaaaaa"), --write x12345678 to 3rd element
		(x"0000003C", x"00000000", '1', '0', x"00000000"), --read 15th element (expect x00000000)
		(x"0000000C", x"00000000", '1', '0', x"12345678"), --read 3rd element (expect x12345678)	
		(x"00000008", x"00000000", '1', '0', x"BCBCBCBC"), --read 2nd element (expect xBCBCBCBC)	
		(x"00000004", x"00000000", '1', '0', x"AEAEAEAE"), --read 1st element (expect xAEAEAEAE)
		(x"00000000", x"00000000", '1', '0', x"00000000") --read 0th element (expect x00000000)				
		);

begin

	DataMemory_unit : entity work.DataMemory
		port map(
				clk=>clk,
				address=>address,
				writeData=>writeData,
				memRead=>memRead,
				memWrite=>memWrite,
				readData=>readData
		);

    	process 
    	begin
		for i in test_vectors'range loop
			clk <= '0';
			wait for T/2;

			address <= test_vectors(i).address;
			writeData <= test_vectors(i).writeData;
			memRead <= test_vectors(i).memRead;
			memWrite <= test_vectors(i).memWrite;

			clk <= '1';
			wait for T/2;
			
			assert	(
					(readData = test_vectors(i).readData)
				)			
            		report  "At test_vector " & integer'image(i) & ": Expected readData " & integer'image(to_integer(unsigned(test_vectors(i).readData))) & ", returned " & integer'image(to_integer(unsigned(readData)))
                    	severity error;
        	end loop;
		wait;
    	end process;

end arch;
