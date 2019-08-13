library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MRUArray is port(

clk  ,reset_n ,
mruwaybitprevios : in std_logic;
index : in std_logic_vector(5 downto 0);
dataReady : in std_logic;
wayoutput : out std_logic --1 => update in way1 , 0=> update in way0
);
end entity;


architecture arch of MRUArray is





signal valibitway0_signal , validbitway1_signal : std_logic_vector(4 downto 0);

type counterArrayw0 is array (0 to 63) of integer;
signal counterw0 : counterArrayw0 := ( others => 0);


type counterArrayw1 is array (0 to 63) of integer;
signal counterw1 :counterArrayw1 := ( others => 0);


begin
    process(clk,reset_n)
    begin

      if reset_n ='1' then
      if counterw0(to_integer(unsigned(index)))>=counterw1(to_integer(unsigned(index))) then
      counterw0(to_integer(unsigned(index))) <= 0;
    else
      counterw1(to_integer(unsigned(index))) <= 0;
end if;

      elsif clk = '1' then  ---codes starts from here
      ---we have missed data and want to replace or write to cache
      if dataReady='1' then
    if(mruwaybitprevios='1') then  ---read from w1
       counterw1(to_integer(unsigned(index)))<=counterw1( to_integer(unsigned(index)))+1;
     elsif (mruwaybitprevios='0') then --read from w0
       counterw0(to_integer(unsigned(index)))<=counterw0( to_integer(unsigned(index)))+1;
end if;
end if ;
    if counterw0(to_integer(unsigned(index))) > counterw1(to_integer(unsigned(index))) then
      wayoutput<='0';
    elsif counterw1(to_integer(unsigned(index))) > counterw0(to_integer(unsigned(index))) then
    wayoutput <='1';


      end if;
        end if;


    end process;




end architecture;
