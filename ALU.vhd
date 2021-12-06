library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is 

	port (
		input1, input2: in STD_LOGIC_VECTOR (31 downto 0);
		alu_control: in STD_LOGIC_VECTOR (3 downto 0);
		result: out STD_LOGIC_VECTOR (31 downto 0);
		zero: out STD_LOGIC
	);

end alu;


architecture aluBehavioral of alu is

	signal aluResult : STD_LOGIC_VECTOR(31 downto 0);

begin
	process (input1, input2, alu_control)
	begin

		case alu_control is

			when "0000" => aluResult <= input1 and input2;					--input1 && input2
			when "0001" => aluResult <= input1 or input2;					--input1 || input2
			when "0010" => aluResult <= std_logic_vector(unsigned(input1) + unsigned(input2));	--input1 + input2
			when "0110" => aluResult <= std_logic_vector(unsigned(input1) - unsigned(input2));	--input1 - input2
			when "0111" => 
				if (signed(input1) < signed(input2)) then
					aluResult <= x"00000001";
				else
					aluResult <= x"00000000";
				end if;
			--when "1100" => aluResult <= input1 nor input2;
			when "1010" => aluResult <= std_logic_vector(unsigned(input1) + (unsigned(input2))); --addi
			when "1000" => aluResult <= input1 and input2; --andi
			when "1001" => aluResult <= input1 or input2; --ori
			when "1111" => --slti
				if (signed(input1) < signed(input2)) then
					aluResult <= x"00000001";
				else
					aluResult <= x"00000000";
				end if;
			when "1100" => --beq
				if (signed(input1) = signed(input2)) then
					aluResult <= x"00000001";
				else
					aluResult <= x"00000000";
				end if;
			when "1101" => --bne
				if (signed(input1) /= signed(input2)) then
					aluResult <= x"00000001";
				else
					aluResult <= x"00000000";
				end if;
			when "1110" => --blez (less than equal to 0)
				if (signed(input1) <= 0) then
					aluResult <= x"00000001";
				else
					aluResult <= x"00000000";
				end if;
			
			when others => null;
			aluResult <= x"00000000";

		end case;

	end process;
	
	result <= aluResult;
	zero <= '1' when aluResult = x"00000000" else '0';

end aluBehavioral;
