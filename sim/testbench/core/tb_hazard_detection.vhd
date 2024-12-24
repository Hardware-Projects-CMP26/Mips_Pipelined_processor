library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hazard_detection_tb is
end entity;

architecture tb of hazard_detection_tb is

  -- Component declaration
  component hazard_detection
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
  end component;

  -- Testbench signals
  signal clk         : std_logic                    := '0';
  signal will_branch : std_logic                    := '0';
  signal wb_address  : std_logic_vector(2 downto 0) := (others => '0');
  signal mem_read    : std_logic                    := '0';
  signal wb          : std_logic                    := '0';
  signal hlt         : std_logic                    := '0';
  signal reset       : std_logic                    := '0';
  signal rs1         : std_logic_vector(2 downto 0) := (others => '0');
  signal rs2         : std_logic_vector(2 downto 0) := (others => '0');
  signal stall       : std_logic;

  -- Clock period constant
  constant clk_period : time := 10 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : hazard_detection
  port map
  (
    clk         => clk,
    will_branch => will_branch,
    wb_address  => wb_address,
    mem_read    => mem_read,
    wb          => wb,
    hlt         => hlt,
    reset       => reset,
    rs1         => rs1,
    rs2         => rs2,
    stall       => stall
  );

  -- Clock generation
  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
  end process;

  -- Stimulus process
  stimulus : process
  begin
    -- Reset the system
    reset <= '1';
    wait for clk_period;
    reset <= '0';

    -- Test case 1: No hazard, no stall
    mem_read <= '0';
    wb       <= '0';
    hlt      <= '0';
    wait for clk_period;

    -- Test case 2: Hazard detected (mem_read, wb, rs1 matches wb_address)
    mem_read   <= '1';
    wb         <= '1';
    wb_address <= "001";
    rs1        <= "001";
    wait for clk_period;
    assert stall = '1'
    report "Test case load use: error"
      severity error;
    wait for clk_period;

    mem_read   <= '0';
    wb         <= '0';
    wb_address <= "001";
    rs1        <= "001";
    wait for clk_period;

    assert stall = '0'
    report "Test case load use: error"
      severity error;
    -- Test case 3: Branch instruction
    wait for (clk_period * 2);
    will_branch <= '1';
    wait for (clk_period);
    assert stall = '1'
    report "Test case branch: error"
      severity error;
    will_branch <= '0';
    wait for (clk_period * 2);
    assert stall = '1'
    report "Test case branch: error"
      severity error;
    wait for clk_period;
    assert stall = '0'
    report "Test case branch: error"
      severity error;
    -- Test case 4: Halt signal
    hlt <= '1';
    wait for (clk_period * 8);
    assert stall = '1'
    report "Test case Hlt: error"
      severity error;
    hlt <= '0';
    -- Test case 5: Reset during operation
    reset <= '1';
    wait for clk_period;
    assert stall = '0'
    report "Test case RESET: error"
      severity error;
    reset <= '0';

    -- Test completed
    wait;
  end process;

end architecture;
