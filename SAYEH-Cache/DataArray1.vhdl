library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataArray1 is port(
clk , wren  : in std_logic ;
address : in std_logic_vector(5 downto 0);
wrdata : in std_logic_vector(15 downto 0);
data : out std_logic_vector(15 downto 0)

);

end entity;

architecture arch of DataArray1 is

--2 set associative
type data_Array1 is array (0 to 63) of std_logic_vector(15 downto 0);
signal arrays1 : data_array1 := (others => "0000000000000000");

signal valid : std_logic ;
signal index : std_logic_vector(5 downto 0) := address(5 downto 0);

begin
  process(clk)
  begin
    if clk = '1' then  ---codes starts from here
      data <= arrays1( to_integer(unsigned((address))));
     if wren = '1' then
    arrays1  (to_integer(unsigned((address)))) <= wrdata;
    end if;
      end if;
  end process;



end architecture;
