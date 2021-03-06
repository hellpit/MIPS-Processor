--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.NUMERIC_STD.UNSIGNED;

entity IRAM_tb is
end IRAM_tb;

architecture arch of IRAM_tb is
	constant T : time := 20 ns;

	--input
	signal clk : std_logic;
	signal PC: std_logic_vector(31 downto 0);
	--output
	signal Dout: std_logic_vector(31 downto 0);

	-- declare record type
	type test_vector is record
		PC : std_logic_vector(31 downto 0);
		Dout : std_logic_vector(31 downto 0);
	end record;

	type test_vector_array is array (natural range <>) of test_vector;
	constant test_vectors : test_vector_array := (
		--PC, Dout
		(x"00000000",x"012A4020"),
		(x"00000004",x"014B4822"),
		(x"00000008",x"018D5824"),
		(x"0000000C",x"014B4825"),
		(x"00000010",x"8E110000"),
		(x"00000018",x"0232802A"),
		(x"0000001C",x"01CF6826"),
		(x"00000024",x"000F7082"),
		(x"0000002C",x"3128FFFF"),
		(x"00000030",x"3528FFFF"),
		(x"00000034",x"29491111"),
		(x"00000038",x"00000000"),
		(x"0000003C",x"00000000"));
begin

	IRAM_unit : entity work.IRAM
		port map (clk=>clk, PC=>PC, Dout=>Dout);

	--cont. clock	
    	process 
    	begin
		for i in test_vectors'range loop
			clk <= '0';
			wait for T/2;

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
		
