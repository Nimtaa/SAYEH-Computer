library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity misshitLogic is port(

tag : in std_logic_vector(3 downto 0);
w0,w1 : in std_logic_vector(4 downto 0);
hit,w0_valid,w1_valid : out std_logic

);
end entity;


architecture arch of misshitLogic is
signal v0 : std_logic ;
signal v1 : std_logic ;
signal tag0 :std_logic_vector(3 downto 0) ;
signal tag1 : std_logic_vector(3 downto 0);


begin
--initialize
v0 <= w0(4);
v1 <= w1(4);
tag0 <= w0(3 downto 0);
tag1 <= w1(3 downto 0);

hit <= '1' when tag1=tag and v1 = '1' else
     '1' when tag0=tag and v0 = '1' else
    '0';
w0_valid <= '1' when tag0=tag and v0 = '1' else '0';
w1_valid <= '1' when tag1=tag and v1 = '1' else '0';



end architecture;
