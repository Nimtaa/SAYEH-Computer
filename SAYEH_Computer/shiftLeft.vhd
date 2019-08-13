library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity shiftLeft is
  port (A:in STD_LOGIC_VECTOR(15 downto 0);
  B:out STD_LOGIC_VECTOR(15 downto 0);
  Carry:out STD_LOGIC

  );
end entity;

architecture arch of shiftLeft is

begin
  B(15 downto 1) <= A(14 downto 0);
  Carry <= A(15);
end architecture;
