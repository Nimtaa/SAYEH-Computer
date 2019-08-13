library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.numeric_std.all;

entity Controller is port(
External_Reset, MemDataReady,Zout,Cout,clk: in std_logic;
IR_out : in std_logic_vector(15 downto 0);

 B15to0,AandB,AorB,AnorB,AaddB,AsubB,AmulB,AcmpB ,ShrB,ShlB,notB ,Cin,Zin
,EnablePc,ResetPc,PcPlusI,PcPlus1,RPlusI,RPlus0,WPreset, WPadd, IRload, SRload, Address_on_Databus,
ALU_on_Databus, IR_on_LOpndBus, IR_on_HOpndBus,Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide,
RFright_on_OpndBus, ReadMem, WriteMem, ReadIO,WriteIO,RFL_write , RFH_write ,
Cset, Creset, Zset, Zreset : out std_logic; 
 Shadow : out std_logic
);
end entity;

architecture dataflow of Controller is

  type state is(reset , halt , fetch ,memRead,exec , execsta ,execlda,exec2,exec2lda,exec2sta,incpc);

  signal Regd_MemDataReady, ShadowEn : std_logic;
  constant b0000: std_logic_vector (3 DOWNTO 0) := "0000";
	constant b1111: std_logic_vector (3 DOWNTO 0) := "1111";

  --List of Opcodes

  --first : "0000"
  constant nop : std_logic_vector(3 downto 0 ) := "0000" ;
  constant hlt : std_logic_vector(3 downto 0 ) := "0001";
  constant szf : std_logic_vector(3 downto 0 ) := "0010";
  constant czf : std_logic_vector(3 downto 0 ) := "0011";
  constant scf : std_logic_vector(3 downto 0 ) := "0100";
  constant ccf : std_logic_vector(3 downto 0 ) := "0101";
  constant cwp : std_logic_vector(3 downto 0 ) := "0110";
  constant jpr : std_logic_vector(3 downto 0 ) := "0111";
  constant brz : std_logic_vector(3 downto 0 ) := "1000";
  constant brc : std_logic_vector(3 downto 0 ) := "1001";
  constant awp : std_logic_vector(3 downto 0 ) := "1010";
  --end first : "0000"


  constant mvr : std_logic_vector(3 downto 0 ) := "0001";
  constant lda : std_logic_vector(3 downto 0 ) := "0010";
  constant sta : std_logic_vector(3 downto 0 ) := "0011";
  constant inp : std_logic_vector(3 downto 0 ) := "0100";
  constant oup : std_logic_vector(3 downto 0 ) := "0101";
  constant ank : std_logic_vector(3 downto 0 ) := "0110";
  constant orr : std_logic_vector(3 downto 0 ) := "0111";
  constant nott : std_logic_vector(3 downto 0 ) := "1000";
  constant shl : std_logic_vector(3 downto 0 ) := "1001";
  constant shr : std_logic_vector(3 downto 0 ) := "1010";
  constant add : std_logic_vector(3 downto 0 ) := "1011";
  constant sub : std_logic_vector(3 downto 0 ) := "1100";
  constant mul : std_logic_vector(3 downto 0 ) := "1101";
  constant cmp : std_logic_vector(3 downto 0 ) := "1110";


 --first of "1111"
  constant mil : std_logic_vector(1 downto 0 ) := "00";
  constant mih : std_logic_vector(1 downto 0 ) := "01";
  constant spc : std_logic_vector(1 downto 0 ) := "10";
  constant jpa : std_logic_vector(1 downto 0 ) := "11";

 --end of "1111"

 --end of List of opcodes

  signal Pstate ,Nstate : state;

begin
  ShadowEn <= '0' when (IR_out (7 downto 0) = "00001111")  else '1';
  
Stateseq : process(IR_out,Pstate,External_Reset,Cout,Zout,ShadowEn,Regd_MemDataReady)
begin
    --initialize all of signals 
    ResetPc <= '0';
		PCplusI <= '0';
		PCplus1 <= '0';
		RplusI <= '0';
		Rplus0 <= '0';
		Rs_on_AddressUnitRSide <= '0';
		Rd_on_AddressUnitRSide <= '0';
		EnablePC <= '0';
		B15to0 <= '0';
		AandB <= '0';
		AorB <= '0';
		notB <= '0';
		ShlB <= '0';
		ShrB <= '0';
		AaddB <= '0';
		AsubB <= '0';
		AmulB <= '0';
		AcmpB <= '0';
		RFL_write <= '0';
		RFH_write <= '0';
		WPreset <= '0';
		WPadd <= '0';
		IRload <= '0';
		SRload <= '0';
		Address_on_Databus <= '0';
		ALU_on_Databus <= '0';
		IR_on_LOpndBus <= '0';
		IR_on_HOpndBus <= '0';
		RFright_on_OpndBus <= '0';
		ReadMem <= '0';
		WriteMem <= '0';
		ReadIO <= '0';
		WriteIO <= '0';
		Cset <= '0';
		Creset <= '0';
		Zset <= '0';
		Zreset <= '0';
		Shadow <= '0';
  
  case (Pstate)  is
  when reset =>
   if(External_Reset = '1') then
    WPreset <='1';
    Creset<='1';
    ResetPc<='1';
    EnablePc<='1';
    Zreset <='1';
    Nstate <= reset ;
  else 
    Nstate <= fetch;
  
  end if;
    
  when halt =>
    if(External_Reset = '1') then
    Nstate <= fetch ;
  else
    Nstate <= halt;
  end if;

  when fetch =>
    if(External_Reset = '1') then
    Nstate <= reset ;
  else
    ReadMem <= '1';
    Nstate <=memRead;
  end if;

  when memRead =>
   if(External_Reset = '1') then
    Nstate <= reset ;
  else
    ReadMem <= '1';
    IRload <= '1';
    Nstate <=exec;
  end if;

  when exec =>
   if(External_Reset = '1') then
    Nstate <= reset ;
  else
   case (IR_out (15 downto 12)) is
   when b0000 =>
     case (IR_out(11 downto 8)) is

      when nop =>
     if (ShadowEn = '1') then
					Nstate <= exec2;
				else
					PCplus1 <=  '1';
			    EnablePC <= '1';
					Nstate <= fetch;
			end if;

      when hlt =>
        Nstate <= halt ;
      when szf =>
        Zset <= '1';

       if (ShadowEn = '1') then
					Nstate <= exec2;
				else
					PCplus1 <=  '1';
			    EnablePC <= '1';
					Nstate <= fetch;
			end if;
      when czf =>
        Zreset <= '1';

       if (ShadowEn = '1') then
					Nstate <= exec2;
				else
					PCplus1 <=  '1';
			    EnablePC <= '1';
					Nstate <= fetch;
			end if;

      when scf =>
       Cset <= '1';
      if (ShadowEn = '1') then
					Nstate <= exec2;
				else
					PCplus1 <=  '1';
			    EnablePC <= '1';
					Nstate <= fetch;
			end if;
      when ccf =>
       Creset <= '1';
     if (ShadowEn = '1') then
					Nstate <= exec2;
				else
					PCplus1 <=  '1';
			    EnablePC <= '1';
					Nstate <= fetch;
			end if;



      when cwp =>
         WPreset <= '1';
       if (ShadowEn = '1') then
					Nstate <= exec2;
				else
					PCplus1 <=  '1';
			    EnablePC <= '1';
					Nstate <= fetch;
			end if;
      when jpr =>
      --relative jump
        PCplusI <= '1';
        EnablePC <= '1';
        Nstate <= fetch ;

      when brz =>
      if(Zout = '1') then
        PCplusI <= '1';
        EnablePC <= '1';
        Nstate <= fetch ;
      else
        PCplus1 <= '1';
        EnablePC <= '1';
        Nstate <= fetch;
     end if;

      when brc =>
      if(Cout = '1') then
        PCplusI <= '1';
        EnablePC <= '1';
        Nstate <= fetch ;
     else
        PCplus1 <= '1';
        EnablePC <= '1';
        Nstate <= fetch;
     end if;

      when awp =>
        WPadd <= '1';
        PCplus1 <= '1';
        EnablePC <= '1';
        Nstate <= fetch;
      when others =>
						PCplus1 <= '1';
						EnablePC <= '1';
						Nstate <= fetch;
  end case ;

    when mvr =>
    --move register
    RFright_on_OpndBus <= '1';
    B15to0 <='1';
    ALU_on_Databus <='1';
    PCplus1 <='1';
    EnablePC <= '1';
    Nstate<= fetch;

    when lda =>
    Rplus0 <='1';
    Rs_on_AddressUnitRSide <='1';
    ReadMem<='1';
    Nstate <= execlda;

    when sta =>
    Rplus0 <='1';
    Rd_on_AddressUnitRSide<='1';
    RFright_on_OpndBus<='1';
    B15to0<='1';
    ALU_on_Databus<='1';
    Nstate<= execsta;

    --when inp >=

  --  when oup >=

    when ank =>
    --and operation on registers
    RFright_on_OpndBus <= '1';
    AandB <= '1';
    ALU_on_Databus<= '1';
    RFH_write <= '1';
    RFL_write <= '1';
    SRload <='1';
    if (ShadowEn = '1') then
				Nstate <= exec2;
				else
					PCplus1 <= '1';
					EnablePC <='1';
          Nstate <= fetch;
				end if;

    when orr =>
    --or operation on registers
    RFright_on_OpndBus <= '1';
    AorB <= '1';
    ALU_on_Databus<= '1';
    RFH_write <= '1';
    RFL_write <= '1';
    SRload <='1';
    if (ShadowEn = '1') then
        Nstate <= exec2;
        else
          PCplus1 <= '1';
          EnablePC <='1';
          Nstate <= fetch;
        end if;
    when nott =>
    RFright_on_OpndBus <= '1';
    notB <= '1';
    ALU_on_Databus<= '1';
    RFH_write <= '1';
    RFL_write <= '1';
    SRload <='1';
    if (ShadowEn = '1') then
        Nstate <= exec2;
        else
          PCplus1 <= '1';
          EnablePC <='1';
          Nstate <= fetch;
        end if;
    when shl =>
    RFright_on_OpndBus <= '1';
    ShlB <= '1';
    ALU_on_Databus<= '1';
    RFH_write <= '1';
    RFL_write <= '1';
    SRload <='1';
    if (ShadowEn = '1') then
        Nstate <= exec2;
        else
          PCplus1 <= '1';
          EnablePC <='1';
          Nstate <= fetch;
        end if;
    when shr =>
    RFright_on_OpndBus <= '1';
    ShrB <= '1';
    ALU_on_Databus<= '1';
    RFH_write <= '1';
    RFL_write <= '1';
    SRload <='1';
    if (ShadowEn = '1') then
        Nstate <= exec2;
        else
          PCplus1 <= '1';
          EnablePC <='1';
          Nstate <= fetch;
        end if;
    when add =>
    RFright_on_OpndBus <= '1';
    AaddB <= '1';
    ALU_on_Databus<= '1';
    RFH_write <= '1';
    RFL_write <= '1';
    SRload <='1';
    if (ShadowEn = '1') then
        Nstate <= exec2;
        else
          PCplus1 <= '1';
          EnablePC <='1';
          Nstate <= fetch;
        end if;
    when sub =>
    RFright_on_OpndBus <= '1';
    AsubB <= '1';
    ALU_on_Databus<= '1';
    RFH_write <= '1';
    RFL_write <= '1';
    SRload <='1';
    if (ShadowEn = '1') then
        Nstate <= exec2;
        else
          PCplus1 <= '1';
          EnablePC <='1';
          Nstate <= fetch;
        end if;
  --  when mul >=

    when cmp =>
    RFright_on_OpndBus <= '1';
    AcmpB <= '1';
    ALU_on_Databus<= '1';
    RFH_write <= '1';
    RFL_write <= '1';
    SRload <='1';
    if (ShadowEn = '1') then
        Nstate <= exec2;
        else
          PCplus1 <= '1';
          EnablePC <='1';
          Nstate <= fetch;
        end if;

when b1111 =>
  case (IR_out(9 downto 8)) is
    when mil =>
    --move immediate low
    IR_on_LOpndBus <= '1';
    RFL_write<= '1';
    ALU_on_Databus <='1';
    SRload <= '1';
    B15to0 <='1';
    PCplus1 <= '1';
    EnablePC <='1';
    Nstate <= fetch;
    when mih =>
    --move immediate high
    IR_on_HOpndBus <= '1';
    RFH_write <= '1';
    ALU_on_Databus <='1';
    SRload <= '1';
    B15to0 <='1';
    PCplus1 <= '1';
    EnablePC <='1';
    Nstate <= fetch;
    when jpa =>
    --jump addressed
    RPlusI <='1';
    Rd_on_AddressUnitRSide <='1';
    EnablePC <='1';
    Nstate <= fetch;

    when spc =>
    PCplusI<='1';
    Address_on_Databus <= '1';
    EnablePC<= '1';
    RFH_write<='1';
    RFL_write<='1';
    Nstate <= fetch;
    
  when others =>
					Nstate <= fetch;
  end case ;
  
    when others =>
    Nstate <= fetch;
  end case;
end if;
  when execlda =>
  if(External_Reset='1') then
  Nstate<= reset;
else
    RFL_write <= '1';
    RFH_write <= '1';
  if(ShadowEn='1') then
    Nstate <= exec2;
  else
    PCplus1 <='1';
    EnablePC<= '1';
    Nstate <= fetch;
  end if;
end if;

--execstc state
when execsta =>
			if (External_Reset = '1') then
				Nstate <= reset;
			else
				WriteMem <= '1';
				if (ShadowEn = '1') then
					Nstate <= exec2;
				else
					Nstate <= incpc;
				end if;
			end if ;

--execstc state

when exec2 =>
Shadow <= '1';
  if (External_Reset = '1') then Nstate<=reset;
else
  case (IR_out(7 downto 4)) is
  when b0000 =>
    case( IR_out(3 downto 0) ) is
     when hlt =>
       Nstate <= halt;
      when szf =>
      Zset <= '1';
      PCplus1 <= '1';
      EnablePC <= '1';
      Nstate <= fetch;
  
      when czf =>
      Zreset<='1';
      PCplus1<='1';
      EnablePC<='1';
      Nstate<=fetch;

      when scf =>
      Cset<= '1';
      PCplus1 <= '1';
      EnablePC <= '1';
      Nstate <= fetch;
      when ccf =>
      Creset<= '1';
      PCplus1 <= '1';
      EnablePC <= '1';
      Nstate <= fetch;
      when cwp =>
      WPreset <= '1';
			PCplus1 <= '1';
			EnablePC <= '1';
			Nstate <= fetch;

      when others =>
      PCplus1 <= '1';
			EnablePC <= '1';
			Nstate <= fetch;

    end case ;


when mvr =>
RFright_on_OpndBus <= '1';
B15to0 <= '1';
ALU_on_Databus <='1';
RFL_write<='1';
RFH_write <='1';
SRload <='1';
PCplus1<='1';
EnablePC<='1';
Nstate <= fetch;

when lda =>
RPlus0<='1';
Rs_on_AddressUnitRSide<='1';
ReadMem<='1';
Nstate <=exec2lda;

when sta =>
RPlus0 <= '1';
Rd_on_AddressUnitRSide <='1';
RFright_on_OpndBus <='1';
B15to0 <='1';
ALU_on_Databus <='1';
Nstate <= exec2sta;

--when inp=>
--when  oup=>
when ank=>
RFright_on_OpndBus <= '1';
AandB <= '1';
ALU_on_Databus<= '1';
RFH_write <= '1';
RFL_write <= '1';
SRload <='1';
PCplus1<='1';
EnablePc<='1';
Nstate<=fetch;

when orr=>
RFright_on_OpndBus <= '1';
AorB <= '1';
ALU_on_Databus<= '1';
RFH_write <= '1';
RFL_write <= '1';
SRload <='1';
PCplus1<='1';
EnablePc<='1';
Nstate<=fetch;
when nott=>
RFright_on_OpndBus <= '1';
notB <= '1';
ALU_on_Databus<= '1';
RFH_write <= '1';
RFL_write <= '1';
SRload <='1';
PCplus1<='1';
EnablePc<='1';
Nstate<=fetch;
when shl=>
RFright_on_OpndBus <= '1';
ShlB <= '1';
ALU_on_Databus<= '1';
RFH_write <= '1';
RFL_write <= '1';
SRload <='1';
PCplus1<='1';
EnablePc<='1';
Nstate<=fetch;
when shr=>
RFright_on_OpndBus <= '1';
ShrB <= '1';
ALU_on_Databus<= '1';
RFH_write <= '1';
RFL_write <= '1';
SRload <='1';
PCplus1<='1';
EnablePc<='1';
Nstate<=fetch;
when add =>

RFright_on_OpndBus <= '1';
AaddB <= '1';
ALU_on_Databus<= '1';
RFH_write <= '1';
RFL_write <= '1';
SRload <='1';
PCplus1<='1';
EnablePc<='1';
Nstate<=fetch;
when sub=>

RFright_on_OpndBus <= '1';
AsubB <= '1';
ALU_on_Databus<= '1';
RFH_write <= '1';
RFL_write <= '1';
SRload <='1';
PCplus1<='1';
EnablePc<='1';
Nstate<=fetch;
when cmp=>

RFright_on_OpndBus <= '1';
	AcmpB <= '1';
	SRload <= '1';
	PCplus1 <= '1';
	EnablePC <= '1';
	Nstate <= fetch;

  when others =>
  					Nstate <= fetch;
  				end case;
  			end if;

when exec2lda =>
    Shadow <= '1';
    if (External_Reset = '1') then
      Nstate <= reset;
    else
    RFL_write<='1';
    RFH_write<='1';
    PCplus1<='1';
    EnablePc<='1';
    Nstate<=fetch;
end if;

when exec2sta =>
if (External_Reset = '1') then
  Nstate <= reset;
else 
 WriteMem<='1';
Nstate<= incpc;
end if;
when incpc =>
	PCplus1 <= '1' ;
	EnablePC <= '1';
	Nstate <= fetch;
   end  case;
end process;
process(clk)
begin
  if rising_edge (clk) then
  Regd_MemDataReady <= MemDataReady;
  Pstate <= Nstate;
end if;
end process;

end architecture;
