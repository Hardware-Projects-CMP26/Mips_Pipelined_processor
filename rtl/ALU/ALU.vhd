--=========================================
-- AUTHOR: Sarah Soliman
--=========================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity ALU is
  port (
    alu_opcode : in std_logic_vector(2 downto 0);
    a          : in std_logic_vector(15 downto 0);
    b          : in std_logic_vector(15 downto 0);
    data_out   : out std_logic_vector(15 downto 0);
    flag_out   : out std_logic_vector(2 downto 0); --ZNC
    wb_flags   : out std_logic
  );
end entity ALU;

architecture rtl of ALU is

begin
  alu_process : process (alu_opcode, a, b)
    variable temp_result : signed(16 downto 0);
    variable wb_flags_en : std_logic := '1';
  begin
    temp_result := (others => '0');
    wb_flags_en := '1';

    case alu_opcode is
      when "000" => -- Set Carry
        temp_result(16) := '1';
      when "001" => -- Not A
        temp_result := '0' & not signed(a);
      when "010" => --Inc A
        temp_result := signed(('0' & a)) + 1;
      when "011" => -- SUB A-B
        temp_result := signed(('0' & a)) - signed(('0' & b));
      when "100" => -- Buff A 
        temp_result := signed(('0' & a));
        wb_flags_en := '0';
      when "101" => -- Buff B
        temp_result := signed(('0' & b));
        wb_flags_en := '0';
      when "110" =>
        temp_result := signed(('0' & a)) + signed(('0' & b));
      when "111" => -- Addition
        temp_result := signed(('0' & a)) and signed(('0' & b));
      when others =>
        temp_result := "00000000000000000";

    end case;
    data_out <= std_logic_vector(temp_result(15 downto 0));
    -- Flags
    flag_out(2) <= '1' when temp_result(15 downto 0) = "0000000000000000" else
    '0';
    flag_out(1) <= temp_result(15);

    flag_out(0) <= temp_result(16);
    wb_flags    <= wb_flags_en;
  end process;

end architecture;
