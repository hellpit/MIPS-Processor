--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU_Control_Unit is
    port(
	  ALU_Function: in std_logic_vector (5 downto 0); -- 6 bits 
	  ALU_Op: in std_logic_vector (2 downto 0); -- 3its that will be taken from control unit
	  Operation: out std_logic_vector (3 downto 0) -- 4 bits that will be passed for ALU to do operation
     );
end ALU_Control_Unit;

architecture behavior_ALU_Control_Unit of ALU_Control_Unit is
    begin --begin architecture
	process(ALU_Op, ALU_Function)
	    begin
	            if(ALU_OP = "010") then --r-type
		        case ALU_Function is
		        when "100000" => --add
 		        Operation <= "0010";
		        when "100010" => --sub
		        Operation <= "0110";
		        when "100100" => --and
		        Operation <= "0000";
		        when "100101" => --or
		        Operation <= "0001";
		        when "101010" => --slt
		        Operation <= "0111";
			when "111010" => 
			Operation <= "0100"; --xor
		        when others => Operation <= "0000";
		        end case;
		    end if;--r type instr
		    if (ALU_OP = "101") then --i type
		        case ALU_Function is
			when "001000" => 
			Operation <= "1010"; --addi
			when "001100" => 
			Operation <= "1000"; --andi
			when "001101" => 
			Operation <= "1001"; --ori
			when "001010" =>
			Operation <= "1111"; -- slti
			when others => Operation <= "0000"; 
		        end case;
		    end if; --i type instr
		    if (ALU_OP = "001") then -- branch 
		        case ALU_Function is --6 bit op code taken in 
			when "000100" =>
			Operation <= "1100"; --beq 
			when "000101" =>
			Operation <= "1101"; --bne 
			when "000110" =>
			Operation <= "1110"; --blez 
			when others => Operation <= "0000";
			end case;
		    end if; --beq
	end process;
end;










