
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity and_gate is
  port (A:in STD_LOGIC_VECTOR(15 downto 0);
  B:in STD_LOGIC_VECTOR(15 downto 0);
  F:out STD_LOGIC_VECTOR(15 downto 0)
  );
end entity;

architecture arch of and_gate is

 signal temp : STD_LOGIC_VECTOR(15 downto 0);

begin
  temp <= A and B;
  F <= temp;
end architecture;
