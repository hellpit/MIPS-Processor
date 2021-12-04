--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionMemory is
    port(    PC: in std_logic_vector(31 downto 0); --program counter
        MemRSignal, clk: in std_logic; --memRSignal is 1 or 0
        Dout: out std_logic_vector (7 downto 0) --instruction register (instruction memory)
        );
end InstructionMemory;

architecture behavior_instruction_memory of InstructionMemory is

signal read_addr: std_logic_vector(3 downto 0); --index for reading ram_data array

-- Creates a simple array of bytes, 16 bytes total:
type ram_type is array (0 to 15) of std_logic_vector(7 downto 0);
constant ram_data: ram_type:=(
x"01",
x"2A",
x"40",
x"20", --add 8, 9, 10
x"01",
x"4B",
x"48",
x"25", --or 9, 10, 11
x"8E",
x"11",
x"00",
x"01", --lw 17, 1(16)
x"01",
x"2B",
x"50",
x"2A" --slt 10, 9, 11
);
begin--begin architecture
        process(clk) 
        begin
                if (rising_edge(clk) and MemRSignal = '1') then 
			Dout <= ram_data(to_integer(unsigned(PC(5 downto 2))));
        	end if;
	end process;
end;
