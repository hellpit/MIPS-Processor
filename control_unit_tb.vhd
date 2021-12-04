--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_unit_tb is
end control_unit_tb;

architecture arch of control_unit_tb is
	constant T : time := 20 ns;

	--input
	signal clk, reset : std_logic;
	signal opcode : std_logic_vector(5 downto 0);
	--output
	signal regdst, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite : std_logic;
	signal aluop : std_logic_vector(1 downto 0);

	-- declare record type
	type test_vector is record
		reset : std_logic;
		opcode : std_logic_vector(5 downto 0);
		regdst, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite : std_logic;
		aluop : std_logic_vector(1 downto 0);
	end record;

	type test_vector_array is array (natural range <>) of test_vector;
	constant test_vectors : test_vector_array := 
	(
		--reset, opcode, regdst, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite, aluop
		('0', "000000", '1', '0', '0', '0', '0', '0', '0', '1', "10"),	--r-type
		('0', "100011", '0', '0', '0', '1', '1', '0', '1', '1', "00"),	--lw
		('0', "101011", '0', '0', '0', '0', '0', '1', '1', '0', "00"),	--sw
		('0', "000100", '0', '0', '1', '0', '0', '0', '0', '0', "01"),	--beq
		('0', "000010", '0', '1', '0', '0', '0', '0', '0', '0', "11"),	--jump
		('1', "------", '0', '0', '0', '0', '0', '0', '0', '0', "00") 	--reset
	);
begin

	control_unit_unit : entity work.ControlUnit
		port map(	clk=>clk, reset=>reset, 
				opcode=>opcode, regdst=>regdst, jump=>jump, branch=>branch, memread=>memread, memtoreg=>memtoreg, memwrite=>memwrite, alusrc=>alusrc, regwrite=>regwrite, 
				aluop=>aluop
			);

	--cont. clock
    	process 
    	begin

		for i in test_vectors'range loop
			clk <= '0';
			wait for T/2;

			reset <= test_vectors(i).reset;
			opcode <= test_vectors(i).opcode;

			clk <= '1';
			wait for T/2;
			
			assert	(
					(regdst = test_vectors(i).regdst) and
					(jump = test_vectors(i).jump) and
					(branch = test_vectors(i).branch) and
					(memread = test_vectors(i).memread) and
					(memtoreg = test_vectors(i).memtoreg) and
					(memwrite = test_vectors(i).memwrite) and	
					(alusrc = test_vectors(i).alusrc) and
					(regwrite = test_vectors(i).regwrite) and
					(aluop = test_vectors(i).aluop)
				)			
            		-- image is used for string-representation of integer etc.
            		report  "test_vector " & integer'image(i) & " failed "
                    	severity error;
        	end loop;
		wait;
    	end process;

end arch;
