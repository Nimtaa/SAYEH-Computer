library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataArray2 is port(
clk , wren  : in std_logic ;
address : in std_logic_vector(5 downto 0);
wrdata : in std_logic_vector(15 downto 0);
data : out std_logic_vector(15 downto 0)

);

end entity;

architecture arch of DataArray2 is

--2 set associative
type data_Array2 is array (0 to 63) of std_logic_vector(15 downto 0);
signal arrays2 : data_array2;
signal valid : std_logic ;
signal index : std_logic_vector(5 downto 0) := address(5 downto 0);

begin
  process(clk)
  begin
    if clk = '1' then  ---codes starts from here
      if wren= '0' then
      data <= arrays2(to_integer(unsigned ((address))));
    else if wren = '1' then
     arrays2 (to_integer(unsigned((address)))) <= wrdata;
    end if;

      end if;
    end if;
  end process;




end architecture;
