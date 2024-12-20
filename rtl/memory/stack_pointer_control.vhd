--=========================================
-- AUTHOR: Sarah Soliman
--=========================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity stack_pointer_control is
  port (
    stack_op   : in std_logic_vector(15 downto 0);
    address_in : in std_logic_vector(15 downto 0);
    mem_out    : out std_logic_vector(15 downto 0);
    sp_out     : out std_logic_vector(15 downto 0);
    execp      : out std_logic
  );
end entity;

architecture rtl of stack_pointer_control is
  constant PUSH     : integer := 1;
  constant POP      : integer := 2;
  constant MAX_ADDR : integer := 16#0FFF#;
begin
  process (stack_op, address_in)
    variable new_address : integer := 0;
  begin
    if to_integer(unsigned(stack_op)) = PUSH then
      mem_out <= address_in;
      new_address := to_integer(unsigned(address_in)) - 1;
      sp_out <= std_logic_vector(to_unsigned(new_address, 16));
    elsif to_integer(unsigned(stack_op)) = POP then
      new_address := to_integer(unsigned(address_in) + 1);
      if new_address = MAX_ADDR + 1 then
        execp  <= '1';
        sp_out <= sp_out;
      else
        execp   <= '0';
        mem_out <= std_logic_vector(to_unsigned(new_address, 16));
        sp_out  <= std_logic_vector(to_unsigned(new_address, 16));
      end if;
    else
      sp_out <= sp_out;
      execp  <= '0';

    end if;
  end process;
end architecture;