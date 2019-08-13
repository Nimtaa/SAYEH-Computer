library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

 -- this module connects cache objects together *

entity MainCache is port(
clk , reset_n,
reset_c ,--reset counter
mruwaybitprevios, --from controller
write, --comes from sayeh

writeToMem : in std_logic;
wren0 ,wren1 , tagWren0 , tagWren1 ,invalidate0, invalidate1: in std_logic;

ReadyCounterInc : in std_logic;
address   : in std_logic_vector(9 downto 0 );
wrdata : in std_logic_vector(15 downto 0 );
w0_valid,w1_valid,tag_valid0,tag_valid1  : out std_logic;
wayOutputMRU : out std_logic;
outdata : out std_logic_vector(15 downto 0);
hit : out std_logic
);
end entity ;

architecture arch of MainCache is
  component DataArray1 is port(
  clk , wren  : in std_logic ;
  address : in std_logic_vector(5 downto 0);
  wrdata : in std_logic_vector(15 downto 0);
  data : out std_logic_vector(15 downto 0)

  );

end component;
component DataArray2 is port(
clk , wren  : in std_logic ;
address : in std_logic_vector(5 downto 0);
wrdata : in std_logic_vector(15 downto 0);
data : out std_logic_vector(15 downto 0)

);

end component;

component DataSelection is port (

w1_valid , w0_valid  : in std_logic;
way1_out , way0_out  : in std_logic_vector(15 downto 0);
dataout : out  std_logic_vector(15 downto 0)
);

end component;


component MRUArray is port(

clk  ,reset_n ,
mruwaybitprevios : in std_logic;
index : in std_logic_vector(5 downto 0);
dataReady : in std_logic;
wayoutput : out std_logic --1 => update in way1 , 0=> update in way0
);
end component;


component misshitLogic is port(

tag : in std_logic_vector(3 downto 0);
w0,w1 : in std_logic_vector(4 downto 0);
hit,w0_valid,w1_valid : out std_logic

);
end component;



component Tag_Valid_Array1 is port(
clk , wren , reset_n  : in std_logic ;
address : in std_logic_vector(5 downto 0);
wrdata : in std_logic_vector(3 downto 0);
data : out std_logic_vector(4 downto 0);
invalidate : in std_logic
);

end component;
component Tag_Valid_Array2 is port(
clk , wren ,reset_n : in std_logic ;
address : in std_logic_vector(5 downto 0);
wrdata : in std_logic_vector(3 downto 0);
data : out std_logic_vector(4 downto 0);
invalidate : in std_logic
);

end component;

  signal data0 : std_logic_vector (15 downto 0);
  signal data1 : std_logic_vector (15 downto 0);
  signal outdata_signal : std_logic_vector (15 downto 0);
  signal tagValid0_signalvector : std_logic_vector (4 downto 0);
  signal tagValid1_signalvector : std_logic_vector (4 downto 0);



  signal ouput_MRU, ready_MRU : std_logic;

  signal hit_temp_signal, w0_valid_signal, w1_valid_signal : std_logic;

begin
  --this write comes from sayeh pc

    dataArray00 : DataArray1 port map (clk,wren0  , address(5 downto 0),  wrdata, data0);
    dataArray11 : DataArray2 port map (clk,wren1 , address(5 downto 0), wrdata, data1);

  	-----------------
  	tagValidArray1 : Tag_Valid_Array1 port map (clk,  tagWren0,reset_n,address(5 downto 0),  address(9 downto 6), tagValid0_signalvector,invalidate0);
  	tagValidArray2 : Tag_Valid_Array2 port map (clk,  tagWren1,reset_n,address(5 downto 0),  address(9 downto 6), tagValid1_signalvector,invalidate1);
  	-----------------
  	miss_hit_logic : missHitLogic port map (address(9 downto 6), tagValid0_signalvector, tagValid1_signalvector, hit_temp_signal, w0_valid_signal, w1_valid_signal);
  	hit <= hit_temp_signal;
  	-----------------

    SelectingData: DataSelection port map  (w1_valid_signal, w0_valid_signal, data0 , data1, outdata_signal);

    ------------------

  	MRU : MRUArray port map (clk, reset_c, mruwaybitprevios, address(5 downto 0),ReadyCounterInc, wayOutputMRU);
  	-----------------

--final outputs
outdata <= outdata_signal ;
w0_valid <= w0_valid_signal;
w1_valid <= w1_valid_signal;
tag_valid0<=tagValid0_signalvector(4);
tag_valid1 <=tagValid1_signalvector(4);

end architecture;
