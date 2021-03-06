--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
    port( OpCode: in std_logic_vector (5 downto 0); --Instr[31:26]
          Reset,clk: in std_logic;
      RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite: out std_logic;
          ALUOp: out std_logic_vector (2 downto 0) --3bits
     );
end ControlUnit;

architecture behavior_control_unit of ControlUnit is
    begin --begin architecture
    process(Reset, OpCode)

    begin
    if(Reset = '0') then
    case OpCode is
    when "000000" => --add, sub which are R-Type Instructions
    RegDst <= '1'; Jump <= '0'; Branch <= '0'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '0'; ALUSrc <= '0'; RegWrite <= '1'; ALUOp <= "010";
    when "100011" => -- lw
    RegDst <= '0'; Jump <= '0'; Branch <= '0'; MemRead <= '1'; MemToReg <= '1'; MemWrite <= '0'; ALUSrc <= '1'; RegWrite <= '1'; ALUOp <= "000";
    when "101011" => -- sw
    RegDst <= '0'; Jump <= '0'; Branch <= '0'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '1'; ALUSrc <= '1'; RegWrite <= '0'; ALUOp <= "000";
    when "000100" => -- beq
    RegDst <= '0'; Jump <= '0'; Branch <= '1'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '0'; ALUSrc <= '0'; RegWrite <= '0'; ALUOp <= "001";
    when "000010" => -- jump
    RegDst <= '0'; Jump <= '1'; Branch <= '0'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '0'; ALUSrc <= '0'; RegWrite <= '0'; ALUOp <= "011";
    when "001000" => -- immediate
    RegDst <= '1'; Jump <= '0'; Branch <= '0'; MemRead <= '1'; MemToReg <= '0'; MemWrite <= '0'; ALUSrc <= '0'; RegWrite <= '0'; ALUOp <= "101";
    when others => RegDst <= '0'; Jump <= '0'; Branch <= '0'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '0'; ALUSrc <= '0'; RegWrite <= '0'; ALUOp <= "000";

    end case;
    else
    --reset everything
    RegDst <= '0'; Jump <= '0'; Branch <= '0'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '0'; ALUSrc <= '0'; RegWrite <= '0'; ALUOp <= "000";
    end if; -- end if staement for reset

    end process;
end;
