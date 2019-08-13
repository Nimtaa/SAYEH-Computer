library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CacheController is port(
  clk : in std_logic;
  read : in std_logic;
  write : in std_logic;
  memdataready : in std_logic;
  hit : in std_logic;
  w0_valid : in std_logic;
  w1_valid : in std_logic;
  tva0valid : in std_logic;
  tva1valid : in std_logic;
  wFromMRU : in std_logic;


  writeEnable0 : out std_logic;
  writeEnable1 : out std_logic;
  TagValidWEnable0 : out std_logic;
  TagValidWEnable1 : out std_logic;
  Invalidate0 : out std_logic;
  Invalidate1 : out std_logic;
  selectWay : out std_logic;
  resetCounter : out std_logic;
 --output for counter increament
  ReadyCounterInc : out std_logic;
  readMem : out std_logic;
  writeMem : out std_logic
  );
end entity;

architecture arch of CacheController is

type state is (State0Reset , State1Read , State2Write , State3Missed ,State4Replace,State5Wait);
signal currrentState : state;
signal nextState : state;
--state 0 is for reset
--state 1 is for read from memory
--state 2 is for write to memory
--state 3 is for Missing Data
--state 4 is for when we should replace data to cache
--state 5 is for when we want to wait for writing to cache
begin

process (clk)
begin
  if (clk = '1') then
    currrentState <= nextState;
  end if;
end process;

process (currrentState)
begin
  writeEnable0 <= '0';
  writeEnable1 <= '0';
  TagValidWEnable0 <= '0';
  TagValidWEnable1 <= '0';
  Invalidate0 <= '0';
  Invalidate1 <= '0';
  readmem <= '0';
  writemem <= '0';
  ReadyCounterInc <='0';
  selectWay <= '0';
  resetCounter <= '0';

  case currrentState is
    when State0Reset =>
    if(read = '1') then
        nextState <= State1Read;
    elsif (write = '1') then
      writeMem <= '1';
      nextState <= State2Write;
    else
      nextState <= State0Reset;
    end if;
    when State2Write   =>
      if(w0_valid = '1') then
        Invalidate0 <= '1';
        TagValidWEnable0 <= '1';
      end if;
      if(w1_valid = '1') then
        Invalidate1 <= '1';
        TagValidWEnable1 <= '1';
      end if;
      nextState <= State0Reset;

    when State1Read =>
      if(hit = '1') then
        ReadyCounterInc<='1';
        if(w0_valid = '1') then
          selectWay <= '0';
        elsif (w1_valid = '1') then
          selectWay <= '1';
        end if;
        nextState <= State0Reset;
      else
        readMem <= '1';
        nextState <= State3Missed;
      end if;

    when State3Missed =>
      readMem <= '1';
      nextState <= State4Replace;


    when State4Replace =>
      --readMem <= '1';
      if(tva0valid = '0') then --way 0 is empty
        writeEnable0 <= '1';
        TagValidWEnable0 <= '1';
        Invalidate0 <= '0';
      elsif (tva1valid = '0') then --way1 is empty
        writeEnable1 <= '1';
        TagValidWEnable1 <= '1';
        Invalidate0 <= '0';
      elsif (tva0valid = '1' and tva1valid = '1') then --we should use MRU output
        if(wFromMRU = '0') then
          writeEnable0 <= '1';
          TagValidWEnable0 <= '1';
        else
          writeEnable1 <= '1';
          TagValidWEnable1 <= '1';
        end if;
      end if;
      resetCounter <= '1';
      nextState <= State5Wait;

      when State5Wait =>
      nextState<= State0Reset;
   -- when Others =>

  end case;
end process;

end architecture;
