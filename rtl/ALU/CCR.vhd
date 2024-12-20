library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity CCR is
  port (
    reset      : in std_logic;
    alu_flags  : in std_logic_vector(2 downto 0);
    wb_flags   : in std_logic_vector(2 downto 0);
    alu_select : in std_logic;
    wb_select  : in std_logic;
    execute    : in std_logic;
    reti       : in std_logic;
    which_flag : in std_logic_vector (2 downto 0);
    ccr_out    : out std_logic_vector(2 downto 0)
  );
end entity CCR;

architecture Behavioral of CCR is
  signal ccr : std_logic_vector(2 downto 0) := "000";
begin
  process (alu_flags, wb_flags, alu_select, wb_select, execute, reti)
  begin
    if reset = '1' then
      ccr <= "000";
    else
      if execute = '1' or reti = '1' then
        if alu_select = '1' then
          ccr(0) <= alu_flags(0) when which_flag(0) = '1' else
          ccr(0);
          ccr(1) <= alu_flags(1) when which_flag(1) = '1' else
          ccr(1);
          ccr(2) <= alu_flags(2) when which_flag(2) = '1' else
          ccr(2);
        elsif wb_select = '1' then
          ccr <= wb_flags;
        else
          ccr <= ccr;
        end if;
      end if;
    end if;
  end process;

  ccr_out <= ccr;
end architecture Behavioral;
