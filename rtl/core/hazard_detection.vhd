library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazard_detection is
  port (
    clk         : in std_logic;
    will_branch : in std_logic;
    wb_address  : in std_logic_vector(2 downto 0);
    mem_read    : in std_logic;
    wb          : in std_logic;
    hlt         : in std_logic;
    reset       : in std_logic;
    rs1         : in std_logic_vector(2 downto 0);
    rs2         : in std_logic_vector(2 downto 0);
    stall       : out std_logic
  );
end entity;

architecture rtl of hazard_detection is
begin

  process (mem_read, will_branch, wb_address, wb, reset, rs1, rs2, clk, hlt)
    variable counter_value : integer   := 0;
    variable is_hlt        : std_logic := '0';

  begin
    if mem_read = '1' and wb = '1' and (wb_address = rs1 or wb_address = rs2) then
      counter_value := counter_value + 1;
    elsif will_branch = '1' then
      counter_value := counter_value + 3;
    elsif hlt = '1' then
      is_hlt := '1';
    end if;
    if reset = '1' then
      is_hlt := '0';
    end if;
    if rising_edge(clk) then
      if counter_value > 0 or is_hlt = '1' then
        stall <= '1';
        counter_value := counter_value - 1;
      else
        stall <= '0';
      end if;
    end if;
  end process;
end architecture;
