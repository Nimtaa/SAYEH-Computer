library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;



entity programCounter is
  port (EnablePc:in STD_LOGIC;
  inputCode:in STD_LOGIC_VECTOR(15 downto 0);
  clk:in STD_LOGIC;
  outputCode:out STD_LOGIC_VECTOR(15 downto 0)
  );
end entity;

architecture dataFlow of programCounter is

begin
  process(clk)
  begin
    if clk = '1' then
      if EnablePc = '1' then
        outputCode <= inputCode;
      end if;
    end if;
  end process;
end architecture;
