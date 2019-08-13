
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.numeric_std.all;

ENTITY AddressUnit IS
 PORT (
 Rside : IN std_logic_vector (15 DOWNTO 0);
 Iside : IN std_logic_vector (7 DOWNTO 0);
 Address : OUT std_logic_vector (15 DOWNTO 0);
 clk, ResetPC, PCplusI, PCplus1 : IN std_logic;
 RplusI, Rplus0, EnablePC : IN std_logic
 );
 END AddressUnit;

 ARCHITECTURE dataflow OF AddressUnit IS
 
component programCounter is
  port (EnablePc:in STD_LOGIC;
  inputCode:in STD_LOGIC_VECTOR(15 downto 0);
  clk:in STD_LOGIC;
  outputCode:out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;


component addressLogic is
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
end component;


 SIGNAL pcout : std_logic_vector (15 DOWNTO 0);
 SIGNAL AddressSignal : std_logic_vector (15 DOWNTO 0);
 BEGIN
 Address <= AddressSignal;
 l1 : programCounter PORT MAP (EnablePC, AddressSignal, clk, pcout);
 l2 : addressLogic PORT MAP
 (pcout, Rside, Iside, AddressSignal,
 ResetPC, PCplusI, PCplus1, RplusI, Rplus0);
 END dataflow;
