--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.NUMERIC_STD.UNSIGNED;

entity RegisterFile_tb is
end RegisterFile_tb;

architecture arch of RegisterFile_tb is
	constant T : time := 20 ns;

	--input
	signal clk, regWrite : std_logic;
	signal readRegister1, readRegister2 : std_logic_vector(4 downto 0);
	signal writeRegister : std_logic_vector(4 downto 0);
	signal writeData : std_logic_vector(31 downto 0);

	--output
	signal readData1, readData2 : std_logic_vector(31 downto 0);

	-- declare record type
	type test_vector is record
		regWrite : std_logic;
		readRegister1, readRegister2 : std_logic_vector(4 downto 0);
	 	writeRegister : std_logic_vector(4 downto 0);
		writeData : std_logic_vector(31 downto 0);
		readData1, readData2 : std_logic_vector(31 downto 0);
	end record;

	type test_vector_array is array (natural range <>) of test_vector;
	constant test_vectors : test_vector_array := (
		--writeE, readR1, readR2, writeR, writeD, readD1, readD2
		('1', "01000", "01001", "01010", x"10101010", x"88888888", x"99999999"), --read t0, t1; write to t2
		('1', "10000", "10001", "10010", x"18181818", x"16161616", x"17171717"), --read s0, s1; write to s2
		('0', "00010", "00011", "00000", x"00000000", x"22222222", x"33333333"), --disable write; read v0, v1
		('1', "11000", "11001", "01011", x"16548138", x"24242424", x"25252525") --read t8, t9; write to t3
		);

begin

	RegsiterFile_unit : entity work.RegisterFile
		port map(
				clk=>clk, 
				regWrite=>regWrite,
				readRegister1=>readRegister1,
				readRegister2=>readRegister2,
				writeRegister=>writeRegister,
				writeData=>writeData,
				readData1=>readData1,
				readData2=>readData2
		);

	--cont. clock	
    	process 
    	begin

		
		for i in test_vectors'range loop
			clk <= '0';
			wait for T/2;

			regWrite <= test_vectors(i).regWrite;
			readRegister1 <= test_vectors(i).readRegister1;
			readRegister2 <= test_vectors(i).readRegister2;
			writeRegister <= test_vectors(i).writeRegister;
			writeData <= test_vectors(i).writeData;

			clk <= '1';
			wait for T/2;
			
			assert	(
					(readData1 = test_vectors(i).readData1) and
					(readData2 = test_vectors(i).readData2)
				)			
            		report  "At test_vector " & integer'image(i) & ": Expected readData1 " & integer'image(to_integer(unsigned(test_vectors(i).readData1))) & " and readData2 " & integer'image(to_integer(unsigned(test_vectors(i).readData2))) & ", returned " & integer'image(to_integer(unsigned(readData1))) & " and " & integer'image(to_integer(unsigned(readData2)))
                    	severity error;
        	end loop;
		wait;
    	end process;

end arch;
