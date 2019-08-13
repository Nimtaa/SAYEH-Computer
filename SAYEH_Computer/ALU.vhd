library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use ieee.numeric_std.all;

entity ALU is
  port (
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
  Cin :in STD_LOGIC;   
  Zin :in STD_LOGIC;   
  inputA : in STD_LOGIC_VECTOR(15 downto 0);
  inputB : in STD_LOGIC_VECTOR(15 downto 0);
  ALUout:out STD_LOGIC_VECTOR(15 downto 0);
  Cout :out STD_LOGIC;   
  Zout :out STD_LOGIC
 -- Rd:out STD_LOGIC_VECTOR(15 downto 0)  
  );
end entity;

architecture arch of ALU is


component and_gate is
  port (A:in STD_LOGIC_VECTOR(15 downto 0);
  B:in STD_LOGIC_VECTOR(15 downto 0);
  F:out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;

component totalAdder is
  port (A:in STD_LOGIC_VECTOR(15 downto 0);
  B:in STD_LOGIC_VECTOR(15 downto 0);
  Cin:in STD_LOGIC;
  Sum:out STD_LOGIC_VECTOR(15 downto 0);
  Cout:out STD_LOGIC
  );
end component;

component or_gate is
  port (A:in STD_LOGIC_VECTOR(15 downto 0);
  B:in STD_LOGIC_VECTOR(15 downto 0);
  F:out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;


component shiftRight is
  port (A:in STD_LOGIC_VECTOR(15 downto 0);
  B:out STD_LOGIC_VECTOR(15 downto 0);
  Carry:out STD_LOGIC

  );
end component;
component comparator is
  port (
  A:in STD_LOGIC_VECTOR(15 downto 0);
  B:in STD_LOGIC_VECTOR(15 downto 0);
  ZeroFlag:out STD_LOGIC;
  CarryFlag:out STD_LOGIC
  );
end component;

component Sub is
  port (A:in STD_LOGIC_VECTOR(15 downto 0);
  B:in STD_LOGIC_VECTOR(15 downto 0);
  R:out STD_LOGIC_VECTOR(15 downto 0);
  Cout : out STD_LOGIC
  );
end component;

component not_gate is
  port (
  A:in STD_LOGIC_VECTOR(15 downto 0);
  B: out STD_LOGIC_VECTOR(15 downto 0)
  );
end component;


component shiftLeft is
  port (A:in STD_LOGIC_VECTOR(15 downto 0);
  B:out STD_LOGIC_VECTOR(15 downto 0);
  Carry:out STD_LOGIC

  );
end component;




begin

u1 : and_gate port map (inputA , inputB , ALUout);
u2 : or_gate port map  (inputA , inputB , ALUout);
u3 : shiftRight port map (inputA  , ALUout, Cout);
u4 : shiftLeft port map (inputA  , ALUout, Cout);
u5 : not_gate port map (inputB , ALUout);
u6 : comparator port map (inputA , inputB , Zout , Cout); 
u7 : totalAdder port map (inputA , inputB , Cin , ALUout , Cout);
u8 : Sub port map (inputA , inputB , ALUout , Cout) ; 
 


end architecture;
