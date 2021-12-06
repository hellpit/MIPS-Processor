--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;

entity SignExtender is
	port(
		input : in std_logic_vector(15 downto 0);
		inputExtended : out std_logic_vector(31 downto 0)
	);
end SignExtender;

architecture Behavioral of SignExtender is
begin
	--extend with x0000 if msb is 0, else extend with xffff
	inputExtended <= x"0000" & input when input(15) = '0' else x"ffff" & input;
end Behavioral;