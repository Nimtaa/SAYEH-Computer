library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity Flags is
  port (
  Zin:in STD_LOGIC;
  Cin:in STD_LOGIC;
  CSet:in STD_LOGIC;
  CReset:in STD_LOGIC;
  ZSet:in STD_LOGIC;
  SRload:in STD_LOGIC;
  ZReset:in STD_LOGIC;
  clk:in STD_LOGIC;
  Cout:out STD_LOGIC;
  Zout:out STD_LOGIC
  );
end entity;
architecture df of Flags is
begin
  process(clk)
  begin
    if clk = '1' then
      if Cset = '1' then
       --
       Cout <= '1'; 
      end if;
      if Zset = '1' then 
        Zout <= '1';
        --
      end if ;
      if CReset = '1' then
       --
       Cout <= '0';
      end if;
      if ZReset = '1' then 
        --
        Zout <= '0';
      end if ;
      if SRload = '1' then
       --
       Cout <= Cin ; 
       Zout <= Zin ; 
      end if;  
    end if;
  end process;
end architecture;