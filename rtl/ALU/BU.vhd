-- =========================================
-- Author      : Sarah Soliman
-- =========================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity BU is
  port (
    flags      : in std_logic_vector(2 downto 0);
    if_jump    : in std_logic;
    which_flag : in std_logic_vector(2 downto 0);
    will_jump  : out std_logic
  );
end entity BU;

architecture rtl of BU is
begin
  process (flags, which_flag, if_jump)
  begin
    if if_jump = '1' then
      will_jump <= '1' when
        ((flags and which_flag) /= "000") else
        '0';
    else
      will_jump <= '0';
    end if;
  end process;
end architecture rtl;
