library ieee;
use ieee.std_logic_1164.all;

entity alu_testbench is 
end alu_testbench;

architecture alu_testbench_behavioral of alu_testbench is

	signal testbench_input1: std_logic_vector(31 downto 0) := (others => '0');
	signal testbench_input2: std_logic_vector(31 downto 0) := (others => '0');
	signal testbench_alu_control: std_logic_vector(3 downto 0) := (others => '0');
	signal testbench_alu_result: std_logic_vector(31 downto 0);
	signal testbench_zero: std_logic;

	begin
	
		testUnit: entity work.ALU(behavior_control_unit)

			port map(
				input1 => testbench_input1,
				input2 => testbench_input2,
				alu_control => testbench_alu_control,
				result => testbench_alu_result,
				zero => testbench_zero
			);

	sim_process: process
	begin
		
		testbench_input1 <= x"00000003";
		testbench_input2 <= x"FFFFFFFF";
		testbench_alu_control <= "0000";

		wait for 20ns;

		testbench_alu_control <= "0001";

		wait for 20ns;

		testbench_alu_control <= "0110";

		wait for 20ns;

		testbench_alu_control <= "0111";

		wait for 20ns;

		testbench_alu_control <= "1100";

		wait for 20ns;

		assert false
		report "END"
			severity failure;
	END PROCESS;

end;

