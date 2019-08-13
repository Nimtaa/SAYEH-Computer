library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity MainModule is
  port (
  clk,External_Reset : in std_logic
  );
end entity;
architecture df of MainModule is

  component memory is
  	generic (blocksize : integer := 1024);

  	port (clk, ReadMem, WriteMem : in std_logic;
		AddressBus: in std_logic_vector (15 downto 0);
		DataBus : inout std_logic_vector (15 downto 0);
		memdataready : out std_logic
		);
  end component;
  component Sayeh is
    port (
      --Instruction: in std_logic_vector(15 downto 0);
      data_bus : inout std_logic_vector(15 downto 0);
    External_Reset, MemDataReady,clk: in std_logic;
      Readmem , Writemem : out std_logic;
      memAddress : out std_logic_vector(15 downto 0)
      --ir_out_dp : out std_logic_vector(15 downto 0)
    );
  end component;
signal  memdataready_signal,readmem_signal,writemem_signal : std_logic;
signal  memAddress_signal ,ir_out_dp_signal,databus_signal : std_logic_vector(15 downto 0);
begin 
memory_module : memory port map (clk,readmem_signal,writemem_signal,memAddress_signal,databus_signal,memdataready_signal);
sayeh_module : Sayeh port map (databus_signal,External_Reset,memdataready_signal,clk,readmem_signal,writemem_signal,memAddress_signal);
 ----memAddress <= memAddress_signal;
-- ir_out_dp <= ir_out_dp_signal;

end architecture;
