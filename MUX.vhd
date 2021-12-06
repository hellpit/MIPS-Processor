--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;

entity MUX is
	port(
		input0, input1 : in std_logic_vector(31 downto 0);
		muxControl : in std_logic;
		muxOutput : out std_logic_vector(31 downto 0)
	);
end MUX;

architecture Behavioral of MUX is
begin
	muxOutput <= input0 when muxControl = '0' else input1;
end Behavioral;
