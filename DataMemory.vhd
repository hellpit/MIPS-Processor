--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory is
    port(
		address : in std_logic_vector(31 downto 0);
		writeData : in std_logic_vector(31 downto 0);
		memWrite, memRead : in std_logic;
		readData : out std_logic_vector(31 downto 0)
     );
end DataMemory;

architecture Behavorial of DataMemory is

begin --begin architecture
    	process(memWrite, memRead)
	begin

	end process;

end Behavorial;
