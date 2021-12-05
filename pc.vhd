library ieee; 
use ieee.std_logic_1164.ALL; 
use ieee.std_logic_unsigned.ALL; 

entity pc is 
	port ( 
		clk : in std_logic; 		-- Clock
		reset : in std_logic;  		-- Reset
		fetchOrDecode : in std_logic; -- Decides to fetch or decode instruction
		dIn : in std_logic_vector(31 downto 0); -- Decode input
		dOut : out std_logic_vector(31 downto 0)); -- Decode output
end pc; 

architecture arch of pc is 
begin
	process(clk, reset) 
	begin 
		if (reset = '0') then 
			if (fetchOrDecode = '0') then
				dOut <= x"00000000";	-- Begin fetch
			elsif (fetchOrDecode = '1') then 
				dOut <= x"0000006E";	-- Decode instruction 
			end if;
		elsif (rising_edge(clk)) then
			dOut <= dIn; 		-- Control unit decides to increment pc or to jump
						-- to a different memory address
		end if; 
	end process;
end arch;