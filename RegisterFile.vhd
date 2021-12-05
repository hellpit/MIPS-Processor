--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RegisterFile is
    port(
		regWrite, clk : in std_logic;
		readRegister1, readRegister2 : in std_logic_vector(4 downto 0);	-- rs, rt
		writeRegister : in std_logic_vector(4 downto 0);		-- rd
		writeData : in std_logic_vector(31 downto 0);			-- data of rd
		readData1, readData2 : out std_logic_vector(31 downto 0)	-- data of rs, rt
     );
end RegisterFile;

architecture Behavorial of RegisterFile is
	-- declare 2d array
	type ThirtyTwoByThirtyTwoArray is array (0 TO 31) of std_logic_vector(31 downto 0);
	-- 32 registers, each holds 32 bits
	SIGNAL registerArray : ThirtyTwoByThirtyTwoArray := (
		x"00000000", --$zero
		x"11111111", --$at
		x"22222222", --$v0
		x"33333333", --$v1
		x"44444444", --$a0
		x"55555555", --$a1
		x"66666666", --$a2
		x"77777777", --$a3
		x"88888888", --$t0
		x"99999999", --$t1
		x"10101010", --$t2
		x"11000011", --$t3
		x"12121212", --$t4
		x"13131313", --$t5
		x"14141414", --$t6
		x"15151515", --$t7
		x"16161616", --$s0
		x"17171717", --$s1
		x"18181818", --$s2
		x"19191919", --$s3
		x"20202020", --$s4
		x"21212121", --$s5
		x"22000022", --$s6
		x"23232323", --$s7
		x"24242424", --$t8
		x"25252525", --$t9
		x"26262626", --$k0
		x"27272727", --$k1
		x"28282828", --$gp
		x"29292929", --$sp
		x"30303030", --$fp
		x"31313131"  --$ra
	);
begin --begin architecture
    	process(regWrite, clk)
	begin
    		if(rising_edge(clk) and regWrite = '1') then
			registerArray(to_integer(unsigned(writeRegister))) <= writeData;
    		end if;
	end process;

	-- regardless of regWrite, go read
	readData1 <= registerArray(to_integer(unsigned(readRegister1)));
	readData2 <= registerArray(to_integer(unsigned(readRegister2)));
end Behavorial;

--TODO -populate tests to be meaningful -may not need reset?