library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_BU is
  -- No ports, as this is a test bench
end entity;

architecture tb of tb_BU is
  -- Component declaration for the Unit Under Test (UUT)
  component BU
    port (
      flags      : in std_logic_vector(2 downto 0);
      if_jump    : in std_logic;
      which_flag : in std_logic_vector(2 downto 0);
      will_jump  : out std_logic
    );
  end component;

  -- Signals for UUT connections
  signal flags_tb      : std_logic_vector(2 downto 0);
  signal if_jump_tb    : std_logic;
  signal which_flag_tb : std_logic_vector(2 downto 0);
  signal will_jump_tb  : std_logic;

begin
  -- Instantiate the Unit Under Test (UUT)
  uut : BU
  port map
  (
    flags      => flags_tb,
    if_jump    => if_jump_tb,
    which_flag => which_flag_tb,
    will_jump  => will_jump_tb
  );

  -- Test process
  stim_proc : process
  begin
    -- Test Case 1: if_jump = '0', no jump
    flags_tb      <= "101";
    which_flag_tb <= "010";
    if_jump_tb    <= '0';
    wait for 10 ns;
    assert will_jump_tb = '0'
    report "Test case 1: Failed"
      severity error;

    -- Test Case 2: if_jump = '1', and matching flag
    flags_tb      <= "101"; -- Flags set
    which_flag_tb <= "100"; -- Match on flag(2)
    if_jump_tb    <= '1';
    wait for 10 ns;
    assert will_jump_tb = '1'
    report "Test case 2: Failed"
      severity error;

    -- Test Case 3: if_jump = '1', and no matching flag
    flags_tb      <= "101";
    which_flag_tb <= "010";
    if_jump_tb    <= '1';
    wait for 10 ns;
    assert will_jump_tb = '0'
    report "Test case 3: Failed"
      severity error;

    -- Test Case 4: if_jump = '1', multiple flags matching
    flags_tb      <= "111";
    which_flag_tb <= "011";
    if_jump_tb    <= '1';
    wait for 10 ns;
    assert will_jump_tb = '1'
    report "Test case 4: Failed"
      severity error;

    -- Test Case 5: if_jump = '1', no flags enabled
    flags_tb      <= "000";
    which_flag_tb <= "111";
    if_jump_tb    <= '1';
    wait for 10 ns;
    assert will_jump_tb = '0'
    report "Test case 5: Failed"
      severity error;

    -- Test complete
    wait;
  end process;

end architecture;
