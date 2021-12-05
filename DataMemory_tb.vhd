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
		(x"00000000", x"00000000", '0', '0', x"00000000"),
		(x"00000000", x"00000000", '0', '0', x"00000000")
		);

begin

	DataMemory_unit : entity work.DataMemory
		port map(
				address=>address,
				writeData=>writeData,
				memRead=>memRead,
				memWrite=>memWrite,
				readData=>readData
		);

    	process 
    	begin
		for i in test_vectors'range loop
			address <= test_vectors(i).address;
			writeData <= test_vectors(i).writeData;
			memRead <= test_vectors(i).memRead;
			memWrite <= test_vectors(i).memWrite;

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
