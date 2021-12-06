--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_Control_Unit is
    port( clk: in std_logic;
	  ALU_Function: in std_logic_vector (5 downto 0); -- 6 bits 
	  ALU_Op: in std_logic_vector (1 downto 0); -- 2bits that will be taken from control unit
	  Operation: out std_logic_vector (2 downto 0) -- 3 bits that will be passed for ALU to do operation
     );
end ALU_Control_Unit;

architecture behavior_ALU_Control_Unit of ALU_Control_Unit is
    begin --begin architecture
	process(ALU_Op, ALU_Function)
	    begin
		if(rising_edge(clk)) then
	            if(ALU_OP = "01") then
		        case ALU_Function is
		        when "100000" => --add
 		        Operation <= "010";
		        when "100010" => --sub
		        Operation <= "110";
		        when "100100" => --and
		        Operation <= "000";
		        when "100101" => --or
		        Operation <= "001";
		        when "101010" => --slt
		        Operation <= "111";
		        when others => Operation <= "XXX"; --xor
		        end case;
		    end if;
		end if; --for clk
		--if(ALU_OP
	end process;
end;

