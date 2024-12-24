LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fetch_decode_buffer_tb IS
END fetch_decode_buffer_tb;

ARCHITECTURE behavior OF fetch_decode_buffer_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT fetch_decode_buffer
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            enable : IN STD_LOGIC;
            instruction_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            immediate_in : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            immediate_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            pc_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            pc_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            op_code_out : OUT STD_LOGIC_VECTOR (4 DOWNTO 0);
            rdest_out_index : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            rsrc1_out_index : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            rsrc2_out_index : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            int_ind_out : OUT STD_LOGIC_VECTOR (1 DOWNTO 0)
        );
    END COMPONENT;

    -- Signals for the testbench
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL rst : STD_LOGIC := '0';
    SIGNAL enable : STD_LOGIC := '0';
    SIGNAL instruction_in : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL immediate_in : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL pc_in : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');

    SIGNAL immediate_out : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL pc_out : STD_LOGIC_VECTOR (31 DOWNTO 0);
    SIGNAL op_code_out : STD_LOGIC_VECTOR (4 DOWNTO 0);
    SIGNAL rdest_out_index : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL rsrc1_out_index : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL rsrc2_out_index : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL int_ind_out : STD_LOGIC_VECTOR (1 DOWNTO 0);

    CONSTANT clk_period : TIME := 10 ns;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: fetch_decode_buffer PORT MAP (
        clk => clk,
        rst => rst,
        enable => enable,
        instruction_in => instruction_in,
        immediate_in => immediate_in,
        immediate_out => immediate_out,
        pc_in => pc_in,
        pc_out => pc_out,
        op_code_out => op_code_out,
        rdest_out_index => rdest_out_index,
        rsrc1_out_index => rsrc1_out_index,
        rsrc2_out_index => rsrc2_out_index,
        int_ind_out => int_ind_out
    );

    -- Clock generation
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    -- Test process
    stim_proc: PROCESS
    BEGIN
        -- Test reset condition
        rst <= '1';
        WAIT FOR clk_period;
        rst <= '0';
        WAIT FOR clk_period;

        -- Test normal operation with enable = '1'
        WAIT UNTIL rising_edge(clk);
        enable <= '1';
        instruction_in <= "1101011001101011";
        immediate_in <= "0000111100001111";
        pc_in <= X"0000ABCD";
        WAIT FOR clk_period;
        
        -- Check outputs
        WAIT UNTIL falling_edge(clk);
        ASSERT op_code_out = "11010" REPORT "op_code_out mismatch" SEVERITY ERROR;
        ASSERT rdest_out_index = "110" REPORT "rdest_out_index mismatch" SEVERITY ERROR;
        ASSERT rsrc1_out_index = "011" REPORT "rsrc1_out_index mismatch" SEVERITY ERROR;
        ASSERT rsrc2_out_index = "010" REPORT "rsrc2_out_index mismatch" SEVERITY ERROR;
        ASSERT int_ind_out = "11" REPORT "int_ind_out mismatch" SEVERITY ERROR;
        ASSERT immediate_out = "0000111100001111" REPORT "immediate_out mismatch" SEVERITY ERROR;
        ASSERT pc_out = X"0000ABCD" REPORT "pc_out mismatch" SEVERITY ERROR;
        -- Test with enable = '0' (outputs should remain unchanged)
        WAIT UNTIL rising_edge(clk);
        enable <= '0';
        instruction_in <= (OTHERS => '0');
        immediate_in <= (OTHERS => '0');
        pc_in <= (OTHERS => '0');
        WAIT FOR clk_period;
        
        WAIT UNTIL rising_edge(clk);
        ASSERT op_code_out = "11010" REPORT "Outputs changed unexpectedly when enable = '0'" SEVERITY ERROR;

        -- End simulation
        WAIT;
    END PROCESS;

END behavior;
