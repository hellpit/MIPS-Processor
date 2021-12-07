--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MIPS is
	port(
		clk, reset : in std_logic;
		newPC : out std_logic_vector(31 downto 0)
	);
end MIPS;

architecture Behavioral of MIPS is
	--handles all program counter work
	signal currentPC : std_logic_vector(31 downto 0) := x"00000000";
	signal nextPC : std_logic_vector(31 downto 0);
	--from instruction memory
	signal instruction : std_logic_vector(31 downto 0) := x"00000000";
	--for control unit
	signal RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite : std_logic;
	signal aluop : std_logic_vector(2 downto 0);
	--for register file
	signal writeRegister : std_logic_vector(4 downto 0);
	signal writeData : std_logic_vector(31 downto 0);
	signal readData1, readData2 : std_logic_vector(31 downto 0);
	--for alu
	signal aluResult : std_logic_vector(31 downto 0);
	signal operand2 : std_logic_vector(31 downto 0);
	signal aluZero : std_logic;
	--for alu control unit
	signal aluControl : std_logic_vector(3 downto 0);
	--for data memory
	signal readData : std_logic_vector(31 downto 0);
	--for sign extender
	signal inputExtended : std_logic_vector(31 downto 0);

begin
	--program counter
        process(clk, reset) 
        begin
		if (rising_edge(clk) and reset = '0') then
			currentPC <= nextPC;
		end if;
		if (reset = '1') then
			currentPC <= x"00000000";
		end if;
	end process;
	nextPC <= std_logic_vector(unsigned(currentPC) + x"00000004"); --increment pc + 4
	
	--read instruction
	MIPS_IRAM: entity work.IRAM
		port map(
			PC=>currentPC,		--from pc (main)
			clk=>clk,		
			Dout=>instruction	--to ctrl unit, IRAM, Sign Extender
		);

	--pass instruction into control unit
	MIPS_CONTROL: entity work.ControlUnit
		port map(
			OpCode=>instruction(31 downto 26),	--from IRAM
          		reset=>reset,
			clk=>clk,
			--to basically everywhere
      			regdst=>regdst, 
			jump=>jump, 
			branch=>branch, 
			memread=>memread, 
			memtoreg=>memtoreg, 
			memwrite=>memwrite, 
			alusrc=>alusrc, 
			regwrite=>regwrite, 
			aluop=>aluop
		);

	--mulitplexer for regdst
	MIPS_MUX_REG_FILE: entity work.MUX5Bit
		port map(
			input0=>instruction(20 downto 16),		--from IRAM
			input1=>instruction(15 downto 11),		--from IRAM
			muxControl=>regdst,				--from ctrl unit
			muxOutput=>writeRegister			--to reg file mux
		);

	--pass into register file
	MIPS_REGISTER: entity work.RegisterFile
		port map(
			regWrite=>regWrite,				--from ctrl unit
			clk=>clk,
			readRegister1=>instruction(25 downto 21),	--from IRAM
			readRegister2=>instruction(20 downto 16),	--from IRAM
			writeRegister=>writeRegister,			--from mux
			writeData=>writeData,				--from DM mux
			readData1=>readData1, readData2=>readData2	--to alu/alu mux
		);

	--sign extend
	MIPS_SIGN_EXTEND: entity work.SignExtender
		port map(
			input=>instruction(15 downto 0),
			inputExtended=>inputExtended
		);

	--pass into alu control unit
	MIPS_ALU_CTRL_UNIT: entity work.ALU_Control_Unit
		port map(
	  		ALU_Function=>instruction(5 downto 0),	--from IRAM
	  		ALU_Op=> aluop,				--from ctrl unit
	  		Operation=>aluControl			--to alu
		);

	--alu multiplexer
	MIPS_MUX_ALU: entity work.MUX
		port map(
			input0=>readData2,	--from DM
			input1=>inputExtended,	--from sign extender
			muxControl=>alusrc,	--from ctrl unit
			muxOutput=>operand2	--to alu
		);
	
	--alu
	MIPS_ALU: entity work.alu
		port map(
			input1=>readData1,		--from reg file
			input2=>operand2,		--from alu mux(reg file / sign extender)
			alu_control=>aluControl,	--from alu ctrl
			result=>aluResult,		--to DM and DM mux
			zero=>aluZero			--to jump mux
		);


	--pass into data memory
	MIPS_DM: entity work.DataMemory
		port map(
			clk=>clk,
			address=>aluResult, 	--from alu
			writeData=>readData2, 	--from reg file
			memWrite=>memWrite,	--from ctrl unit
			memRead=>memRead,	--from ctrl unit
			readData=>readData	--to DM mux
		);

	-- write back
	MIPS_MUX_WRITE_BACK: entity work.MUX
		port map(
			input0=>aluResult,	--from alu
			input1=>readData,	--from DM
			muxControl=>memToReg,	--from control unit
			muxOutput=>writeData	--to register file
		);

	-- output PC for next instruction
	newPC <= nextPC;
end Behavioral;
