--@author: Ricardo Baeza, Matthew Graca, Jorge Aranda, Nathan Goshay
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
    port( OpCode: in std_logic_vector (5 downto 0); --Instr[31:26]
          Reset,clk: in std_logic;
      RegDst, Jump, Branch, MemRead, MemToReg, MemWrite, ALUSrc, RegWrite: out std_logic;
          ALUOp: out std_logic_vector (1 downto 0) --2bits
     );
end ControlUnit;

architecture behavior_control_unit of ControlUnit is
    begin --begin architecture
    process(Reset, OpCode)

    begin
    if(Reset = '0') then
    case OpCode is
    when "000000" => --add, sub which are R-Type Instructions
    RegDst <= '1'; Jump <= '0'; Branch <= '0'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '0'; ALUSrc <= '0'; RegWrite <= '1'; ALUOp <= "10";
    when "100011" => -- lw
    RegDst <= '0'; Jump <= '0'; Branch <= '0'; MemRead <= '1'; MemToReg <= '1'; MemWrite <= '0'; ALUSrc <= '1'; RegWrite <= '1'; ALUOp <= "00";
    when "101011" => -- sw
    RegDst <= '0'; Jump <= '0'; Branch <= '0'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '1'; ALUSrc <= '1'; RegWrite <= '0'; ALUOp <= "00";
    when "000100" => -- beq
    RegDst <= '0'; Jump <= '0'; Branch <= '1'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '0'; ALUSrc <= '0'; RegWrite <= '0'; ALUOp <= "01";
    when "000010" => -- jump
    RegDst <= '0'; Jump <= '1'; Branch <= '0'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '0'; ALUSrc <= '0'; RegWrite <= '0'; ALUOp <= "11";
    --jump 
    when others => RegDst <= '0'; Jump <= '0'; Branch <= '0'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '0'; ALUSrc <= '0'; RegWrite <= '0'; ALUOp <= "00";

    end case;
    else
    --reset everything
    RegDst <= '0'; Jump <= '0'; Branch <= '0'; MemRead <= '0'; MemToReg <= '0'; MemWrite <= '0'; ALUSrc <= '0'; RegWrite <= '0'; ALUOp <= "00";
    end if; -- end if staement for reset

    end process;
end;
