library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity tb_CCR is
end entity tb_CCR;

architecture behavior of tb_CCR is
  -- Component Declaration for the Unit Under Test (UUT)
  component CCR
    port (
      reset      : in std_logic;
      alu_flags  : in std_logic_vector(2 downto 0);
      wb_flags   : in std_logic_vector(2 downto 0);
      alu_select : in std_logic;
      wb_select  : in std_logic;
      execute    : in std_logic;
      reti       : in std_logic;
      which_flag : in std_logic_vector(2 downto 0);
      ccr_out    : out std_logic_vector(2 downto 0)
    );
  end component;

  -- Signals to connect to the UUT
  signal alu_flags  : std_logic_vector(2 downto 0);
  signal wb_flags   : std_logic_vector(2 downto 0);
  signal alu_select : std_logic;
  signal wb_select  : std_logic;
  signal execute    : std_logic;
  signal reti       : std_logic;
  signal reset      : std_logic;
  signal which_flag : std_logic_vector(2 downto 0);
  signal ccr_out    : std_logic_vector(2 downto 0);

begin
  -- Instantiate the UUT
  uut : CCR
  port map
  (
    reset      => reset,
    alu_flags  => alu_flags,
    wb_flags   => wb_flags,
    alu_select => alu_select,
    wb_select  => wb_select,
    execute    => execute,
    reti       => reti,
    which_flag => which_flag,
    ccr_out    => ccr_out
  );

  -- Test process
  stim_proc : process
  begin
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    wait for 10 ns;

    -- Test Case 1: ALU select, execute is active, and `which_flag` is set
    alu_flags  <= "101"; -- Set some flags on alu_flags
    wb_flags   <= "000"; -- No flags for wb_flags
    alu_select <= '1';
    wb_select  <= '0';
    execute    <= '1';
    reti       <= '0';
    which_flag <= "011"; -- Update only flags 1 and 0
    wait for 10 ns; -- Wait for some time
    assert (ccr_out = "001") report "Test Case 1 Failed" severity error;

    -- Test Case 2: WB select, execute is active, `which_flag` doesn't matter
    alu_flags  <= "111";
    wb_flags   <= "010";
    alu_select <= '0';
    wb_select  <= '1';
    execute    <= '0';
    reti       <= '1';
    which_flag <= "111";
    wait for 10 ns;
    assert (ccr_out = "010") report "Test Case 2 Failed" severity error;

    -- Test Case 3: Execute is off, so flags shouldn't change
    alu_flags  <= "111";
    wb_flags   <= "101";
    alu_select <= '1';
    wb_select  <= '0';
    execute    <= '0';
    reti       <= '0';
    which_flag <= "001";
    wait for 10 ns;
    assert (ccr_out = "010") report "Test Case 3 Failed" severity error; -- ccr_out should stay the same

    -- Test Case 4: RETI is active, `which_flag` updates corresponding flags
    alu_flags  <= "001";
    wb_flags   <= "100";
    alu_select <= '1';
    wb_select  <= '0';
    execute    <= '1';
    reti       <= '0';
    which_flag <= "111"; -- Update all flags
    wait for 10 ns;
    assert (ccr_out = "001") report "Test Case 4 Failed" severity error;

    -- Test Case 5: No flag selection, all flags unchanged
    alu_flags  <= "111";
    wb_flags   <= "010";
    alu_select <= '0';
    wb_select  <= '0';
    execute    <= '1';
    reti       <= '0';
    which_flag <= "000"; -- No flag update
    wait for 10 ns;
    assert (ccr_out = "001") report "Test Case 5 Failed" severity error;

    -- End simulation

    wait;
  end process stim_proc;

end architecture behavior;
