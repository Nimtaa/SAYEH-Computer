

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity tristate is port(
A : in std_logic_vector(15 downto 0); 
EN : in std_logic; 
B : out std_logic_vector (15 downto 0 )
);

end entity ;

architecture Behavioral of tristate is

begin

    -- single active high enabled tri-state buffer
    B <= A when (EN = '1') else "ZZZZZZZZZZZZZZZZ";
    
  end architecture ;