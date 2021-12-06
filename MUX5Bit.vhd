--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;

entity MUX5Bit is
	port(
		input0, input1 : in std_logic_vector(4 downto 0);
		muxControl : in std_logic;
		muxOutput : out std_logic_vector(4 downto 0)
	);
end MUX5Bit;

architecture Behavioral of MUX5Bit is
begin
	muxOutput <= input0 when muxControl = '0' else input1;
end Behavioral;
