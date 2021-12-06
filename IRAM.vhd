--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IRAM is
    port(    PC: in std_logic_vector(31 downto 0); --program counter
        MemRSignal, clk: in std_logic; --memRSignal is 1 or 0
        Dout: out std_logic_vector (31 downto 0) --instruction register (instruction memory)
        );
end IRAM;

architecture Behavioral of IRAM is

-- Creates a simple array of bytes, 16 bytes total:
type ram_type is array (0 to 15) of std_logic_vector(31 downto 0);
constant ram_data: ram_type:=(
x"012A4020", --add t0, t1, t2
x"014B4822", --sub t1, t2, t3
x"018D5824", --and t3 t4 t5
x"014B4825", --or 9, 10, 11
x"8E110001", --lw 17, 1(16)
x"AE300016", --sw 16, 22(17)
x"0232802A", --slt s0 s1 s2
x"01CF6826", --xor t5 t6 t7
x"000F7040", --sll t6 t7 0x001
x"000F7082", --srl t6 t7 0x002
x"2230FFFF", --addi 16, 17, 0xFFFF
x"3128FFFF", --andi t0 t1 0xffff
x"3528FFFF", --ori t0 t1 0xffff
x"29491111", --slti 9, 10, 0x1111
x"00000000",
x"00000000"
);
begin--begin architecture
        process(clk) 
        begin
                if (rising_edge(clk) and MemRSignal = '1') then 
			Dout <= ram_data(to_integer(unsigned(PC(5 downto 2))));
        	end if;
	end process;
end Behavioral;
