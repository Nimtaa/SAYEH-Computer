
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity addressLogic is
  port (
  PCside:in STD_LOGIC_VECTOR(15 downto 0);
  Rside:in STD_LOGIC_VECTOR(15 downto 0);
  Iside:in STD_LOGIC_VECTOR(7 downto 0);
  Alout:out STD_LOGIC_VECTOR(15 downto 0);
  ResetPc:in STD_LOGIC;
  PcPlusI:in STD_LOGIC;
  PcPlus1:in STD_LOGIC;
  RPlusI:in STD_LOGIC;
  RPlus0:in STD_LOGIC
  );
end entity;

architecture arch of addressLogic is

Constant one :STD_LOGIC_VECTOR(4 downto 0) := "10000";
Constant two :STD_LOGIC_VECTOR(4 downto 0) := "01000";
Constant three :STD_LOGIC_VECTOR(4 downto 0) := "00100";
Constant four :STD_LOGIC_VECTOR(4 downto 0) := "00010";
Constant five :STD_LOGIC_VECTOR(4 downto 0) := "00001";

begin
  process (PCside, Rside, Iside, ResetPc, PcPlusI, PcPlus1, RPlusI, RPlus0)
  variable temp :STD_LOGIC_VECTOR(4 downto 0);
  begin
    temp := (ResetPc & PcPlusI & PcPlus1 & RPlusI & RPlus0);
    case temp is
      when one => Alout <= (others => '0');
      when two => Alout <= PCside + Iside ;
      when three => Alout <= PCside + 1;
      when four => Alout <= Rside + Iside;
      when five => ALout <= Rside;
      WHEN OTHERS => ALout <= PCside;
      END CASE;
      END PROCESS;

end architecture;
