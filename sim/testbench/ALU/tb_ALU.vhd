library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_ALU is
  -- No ports for a testbench
end tb_ALU;

architecture behavior of tb_ALU is
  -- Component Declaration
  component ALU is
    port (
      alu_opcode : in std_logic_vector(2 downto 0);
      a          : in std_logic_vector(15 downto 0);
      b          : in std_logic_vector(15 downto 0);
      data_out   : out std_logic_vector(15 downto 0);
      flag_out   : out std_logic_vector(2 downto 0);
      wb_flags   : out std_logic
    );
  end component;

  -- Signals
  signal alu_opcode : std_logic_vector(2 downto 0);
  signal a          : std_logic_vector(15 downto 0);
  signal b          : std_logic_vector(15 downto 0);
  signal data_out   : std_logic_vector(15 downto 0);
  signal flag_out   : std_logic_vector(2 downto 0);
  signal wb_flags   : std_logic;

begin
  -- Instantiate ALU
  uut : ALU
  port map
  (
    alu_opcode => alu_opcode,
    a          => a,
    b          => b,
    data_out   => data_out,
    flag_out   => flag_out,
    wb_flags   => wb_flags
  );

  -- Stimulus Process
  stim_proc : process
  begin
    -- Test 1: Set Carry
    alu_opcode <= "000";
    a          <= x"0000";
    b          <= x"0000";
    wait for 10 ns;
    assert data_out = x"0000" and flag_out(0) = '1' and wb_flags = '1'
    report "Test 1 failed: Set Carry" severity error;

    -- Test 2: Not A
    alu_opcode <= "001";
    a          <= x"FFFF";
    wait for 10 ns;
    assert data_out = x"0000" and flag_out(2) = '1'
    report "Test 2 failed: Not A" severity error;

    -- Test 3: Increment A
    alu_opcode <= "010";
    a          <= x"0001";
    wait for 10 ns;
    assert data_out = x"0002" and flag_out(2) = '0' and flag_out(1) = '0'
    report "Test 3 failed: Increment A" severity error;

    -- Test 4: Subtract A - B
    alu_opcode <= "011";
    a          <= x"0003";
    b          <= x"0002";
    wait for 10 ns;
    assert data_out = x"0001" and flag_out(2) = '0' and flag_out(1) = '0'
    report "Test 4 failed: Subtract A - B" severity error;

    -- Test 5: Buffer A
    alu_opcode <= "100";
    a          <= x"00FF";
    wait for 10 ns;
    assert data_out = x"00FF" and wb_flags = '0'
    report "Test 5 failed: Buffer A" severity error;

    -- Test 6: Addition A + B
    alu_opcode <= "110";
    a          <= x"000F";
    b          <= x"0001";
    wait for 10 ns;
    assert data_out = x"0010" and flag_out(0) = '0'
    report "Test 6 failed: Addition A + B" severity error;

    -- Test 7: Logical AND
    alu_opcode <= "111";
    a          <= x"00FF";
    b          <= x"0F0F";
    wait for 10 ns;
    assert data_out = x"000F"
    report "Test 7 failed: Logical AND" severity error;

    -- Test 8: Buffer B
    alu_opcode <= "101";
    b          <= x"00FF";
    wait for 10 ns;
    assert data_out = x"00FF" and wb_flags = '0'
    report "Test 8 failed: Buffer B" severity error;

    -- Test 9: Negative Flag Test (Negative result)
    -- Subtract A - B where A = 5 and B = 10 (Expect negative result)
    alu_opcode <= "011";
    a          <= x"0005"; -- A = 5
    b          <= x"000A"; -- B = 10
    wait for 10 ns;
    assert data_out = x"FFFB" and flag_out(1) = '1'
    report "Test 9 failed: Negative Flag Test (A - B < 0)" severity error;

    -- Test 10: Negative Flag Test (Positive result)
    -- Subtract A - B where A = 10 and B = 5 (Expect positive result)
    alu_opcode <= "011";
    a          <= x"000A"; -- A = 10
    b          <= x"0005"; -- B = 5
    wait for 10 ns;
    assert data_out = x"0005" and flag_out(1) = '0'
    report "Test 10 failed: Negative Flag Test (A - B > 0)" severity error;
    report "Simulation completed successfully" severity note;

    wait; -- End simulation
  end process;

end behavior;
