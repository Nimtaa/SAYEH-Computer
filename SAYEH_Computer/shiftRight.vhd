library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity shiftRight is
  port (A:in STD_LOGIC_VECTOR(15 downto 0);
  B:out STD_LOGIC_VECTOR(15 downto 0);
  Carry:out STD_LOGIC

  );
end entity;

architecture arch of shiftRight is

begin
  B(14 downto 0) <= A(15 downto 1);
  Carry <= A(0);
end architecture;
