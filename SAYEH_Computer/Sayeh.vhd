library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;


entity Sayeh is
  port (
    --Instruction: in std_logic_vector(15 downto 0);
    data_bus : inout std_logic_vector(15 downto 0);
    External_Reset, MemDataReady,clk: in std_logic;
    Readmem , Writemem : out std_logic;
    memAddress : out std_logic_vector(15 downto 0)
    --ir_out_dp : out std_logic_vector(15 downto 0)

  );
end entity;

architecture dataflow of Sayeh is

component DataPath is port (

  databus : inout std_logic_vector(15 downto 0) ;

  clk : in std_logic ;
 --ALU
 B15to0 :in STD_LOGIC;
  AandB :in STD_LOGIC;
  AorB :in STD_LOGIC;
  AnorB :in STD_LOGIC;
  AaddB :in STD_LOGIC;
  AsubB :in STD_LOGIC;
  AmulB : in STD_LOGIC;
  AcmpB :in STD_LOGIC;
  ShrB :in STD_LOGIC;
  ShlB :in STD_LOGIC;
  notB :in STD_LOGIC;
  --IR
  ir_load : in std_logic;
  --address logic
  ResetPC : in std_logic;
  PCPlusI : in std_logic ;
  PCplus1 : in std_logic ;
  RPlusI : in std_logic ;
  RPlus0 : in std_logic;
  EnablePC : in std_logic;
  --wp
  WPadd : in std_logic ;
  WPreset : in std_logic;
  --flags
  C_Set , C_Reset , Z_Set , Z_Reset  , SR_Load : in std_logic ;
  --rf
  RFL_write , RFH_write , Shadow : in std_logic ;
  --Memory
  memAddress : out std_logic_vector(15 downto 0 );
  --alu
  alu_opcode : in std_logic_vector(3 downto 0);
  --tristates
    rd_on_AddressUnitRSide ,
    rs_on_AddressUnitRSide ,
    address_on_databus ,
    aluout_on_databus : in std_logic ;
    --OUTPUT
    Zout , Cout : out std_logic ;
    ir_out_dp : out std_logic_vector(15 downto 0)
);
end component ;
component Controller is port(
External_Reset, MemDataReady,Zout,Cout,clk: in std_logic;
IR_out : in std_logic_vector(15 downto 0);
 B15to0,AandB,AorB,AnorB,AaddB,AsubB,AmulB,AcmpB ,ShrB,ShlB,notB ,Cin,Zin
,EnablePc,ResetPc,PcPlusI,PcPlus1,RPlusI,RPlus0,WPreset, WPadd, IRload, SRload, Address_on_Databus,
ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus,Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide,
RFright_on_OpndBus, ReadMem, WriteMem, ReadIO,WriteIO,RFL_write , RFH_write ,
Cset, Creset, Zset, Zreset : out std_logic;
 Shadow : out std_logic
);
end component;

signal
memAddress_signal,ir_out_dp_signal: std_logic_vector(15 downto 0);

signal
B15to0_signal,AandB_signal,AorB_signal,AnorB_signal,AaddB_signal,AsubB_signal,AmulB_signal
,AcmpB_signal ,ShrB_signal,ShlB_signal,notB_signal ,Cin_signal,Zin_signal
,EnablePc_signal,ResetPc_signal,PcPlusI_signal,PcPlus1_signal,RPlusI_signal,RPlus0_signal,WPreset_signal,
WPadd_signal, IRload_signal, SRload_signal, Address_on_Databus_signal,
ALU_on_Databus_signal, IR_on_LOpndBus_signal, IR_on_HOpndBus_signal,Rs_on_AddressUnitRSide_signal, Rd_on_AddressUnitRSide_signal,
RFright_on_OpndBus_signal, ReadMem_signal, WriteMem_signal, ReadIO_signal,WriteIO_signal,RFL_write_signal , RFH_write_signal ,
Cset_signal, Creset_signal, Zset_signal, Zreset_signal ,Shadow_signal: std_logic;


  begin
controller_module : Controller port map (External_Reset,MemDataReady,Zin_signal,Cin_signal,clk,data_bus,
B15to0_signal,AandB_signal,AorB_signal,AnorB_signal,AaddB_signal
,AsubB_signal,AmulB_signal,AcmpB_signal ,ShrB_signal,ShlB_signal,notB_signal
,Cin_signal,Zin_signal,EnablePc_signal,ResetPc_signal,PcPlusI_signal,PcPlus1_signal
,RPlusI_signal,RPlus0_signal,WPreset_signal,WPadd_signal, IRload_signal, SRload_signal,
Address_on_Databus_signal,ALU_on_Databus_signal, IR_on_LOpndBus_signal, IR_on_HOpndBus_signal
,Rs_on_AddressUnitRSide_signal, Rd_on_AddressUnitRSide_signal,RFright_on_OpndBus_signal,
ReadMem_signal, WriteMem_signal, ReadIO_signal,WriteIO_signal,RFL_write_signal , RFH_write_signal
,Cset_signal, Creset_signal, Zset_signal, Zreset_signal);


datapath_module : DataPath port map(data_bus,clk,B15to0_signal,AandB_signal,AorB_signal,AnorB_signal,AaddB_signal,AsubB_signal,AmulB_signal,
AcmpB_signal,ShrB_signal,ShlB_signal,notB_signal,
IRload_signal,ResetPc_signal,PcPlusI_signal,PcPlus1_signal,
RPlusI_signal,RPlus0_signal,EnablePc_signal,WPadd_signal
,WPreset_signal,Cset_signal,Creset_signal,Zset_signal,Zreset_signal,SRload_signal,
RFL_write_signal,RFH_write_signal,Shadow_signal,memAddress_signal,data_bus(15 downto 12),
Rd_on_AddressUnitRSide_signal,Rs_on_AddressUnitRSide_signal,
Address_on_Databus_signal,ALU_on_Databus_signal,Zin_signal,Cin_signal,ir_out_dp_signal
);


memAddress <= memAddress_signal;

Readmem <= ReadMem_signal;
Writemem <= WriteMem_signal;




end architecture;
