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
		x"00000001", --$at
		x"00000002", --$v0
		x"00000003", --$v1
		x"00000004", --$a0
		x"00000005", --$a1
		x"00000006", --$a2
		x"00000007", --$a3
		x"00000008", --$t0
		x"00000009", --$t1
		x"0000000A", --$t2
		x"0000000B", --$t3
		x"0000000C", --$t4
		x"0000000D", --$t5
		x"0000000E", --$t6
		x"0000000F", --$t7
		x"00000000", --$s0
		x"00000004", --$s1
		x"00000001", --$s2
		x"00000002", --$s3
		x"00000003", --$s4
		x"00000004", --$s5
		x"00000005", --$s6
		x"00000006", --$s7
		x"00000007", --$t8
		x"00000008", --$t9
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