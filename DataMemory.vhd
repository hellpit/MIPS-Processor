--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory is
    port(
		clk : in std_logic;
		address : in std_logic_vector(31 downto 0);
		writeData : in std_logic_vector(31 downto 0);
		memWrite, memRead : in std_logic;
		readData : out std_logic_vector(31 downto 0)
     );
end DataMemory;

architecture Behavorial of DataMemory is
	type ArrayOf32Bits is array(0 to 15) of std_logic_vector(31 downto 0);
	signal memory : ArrayOf32Bits :=(
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000",
		x"00000000"
	);
-- assumes that the address starts at x00000000
begin
    	process(clk, memWrite, memRead)
	begin
		if(rising_edge(clk)) then
			if (memWrite = '1') then
				memory(to_integer(unsigned(address)) / 4) <= writeData;
			end if;
			if (memRead = '1') then
				readData <= memory(to_integer(unsigned(address)) / 4);
			end if;
		end if;
	end process;

end Behavorial;
