library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataSelection is port (

w1_valid , w0_valid  : in std_logic;
way1_out , way0_out  : in std_logic_vector(15 downto 0);
dataout : out  std_logic_vector(15 downto 0)



);

end entity;

architecture arch of DataSelection is

begin

dataout <= way0_out when (w0_valid='1') else way1_out when (w1_valid='1')
else "ZZZZZZZZZZZZZZZZ";

end architecture;
