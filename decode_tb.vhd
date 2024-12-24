LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY decode_tb IS
END decode_tb;

ARCHITECTURE behavior OF decode_tb IS

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT decode
        PORT (
            clk            : IN  STD_LOGIC;
            instruction    : IN  STD_LOGIC_VECTOR (15 DOWNTO 0);
            instruction_out: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            immediate      : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
            in_data        : IN  STD_LOGIC_VECTOR (15 DOWNTO 0)
        );
    END COMPONENT;

    -- Testbench signals
    SIGNAL clk            : STD_LOGIC := '0';
    SIGNAL instruction    : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL instruction_out: STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL immediate      : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL in_data        : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');

    -- Clock period definition
    CONSTANT clk_period : TIME := 10 ns;

    -- Procedure to check and report results
    PROCEDURE check_results (
        expected_instruction_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
        expected_immediate       : STD_LOGIC_VECTOR(15 DOWNTO 0);
        actual_instruction_out   : STD_LOGIC_VECTOR(15 DOWNTO 0);
        actual_immediate         : STD_LOGIC_VECTOR(15 DOWNTO 0);
        test_name                : STRING
    ) IS
    BEGIN
        -- Check instruction_out
        IF (actual_instruction_out = expected_instruction_out) AND
           (actual_immediate = expected_immediate) THEN
            REPORT test_name & " PASSED" SEVERITY NOTE;
        ELSE
            REPORT test_name & " FAILED"; 
        END IF;
    END PROCEDURE;

BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: decode PORT MAP (
        clk => clk,
        instruction => instruction,
        instruction_out => instruction_out,
        immediate => immediate,
        in_data => in_data
    );

    -- Clock generation process
    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period / 2;
        clk <= '1';
        WAIT FOR clk_period / 2;
    END PROCESS;

    -- Stimulus process
    stim_proc: PROCESS
    BEGIN
        -- Test 1:instruction(15 DOWNTO 13) = "111" and, counter=0
        instruction <= "1110000001111010"; 
        in_data <= "1111000000001111"; -- in_data = 0xF0F1
        WAIT FOR clk_period;
        -- Check the output for instruction(14) = '0' and immediate condition
        check_results(instruction, in_data, instruction_out, immediate, "Test 1");

        -- Test 2: instruction(14) = '0' but instruction(15 DOWNTO 13) is not "111"
        instruction <= "0000000000000001"; -- instruction = 0x0001
        in_data <= "1111000000001111"; -- in_data = 0xF0F1
        WAIT FOR clk_period;
        -- Check the output for instruction(14) = '0' and immediate condition
        check_results(instruction, (OTHERS => '0'), instruction_out, immediate, "Test 2");

        -- Test 3: instruction(14) = '1' and counter = 0
        instruction <= "0100000000000001"; -- instruction = 0x8001
        WAIT FOR clk_period;
        -- Check that the counter behavior works (instruction_out should be zeroed out)
        check_results((OTHERS => '0'), (OTHERS => '0'), instruction_out, immediate, "Test 3");

        -- Test 4: instruction(14) = '1' and counter = 1
        instruction <= "0100000000000001"; -- instruction = 0x8001
        WAIT FOR clk_period;
        -- Check the immediate output (should be the instruction)
        check_results(instruction, instruction, instruction_out, immediate, "Test 4");

        -- Test 5: instruction(14) = '0' and immediate condition
        instruction <= "1000000000000000"; -- instruction = 0x4000
        in_data <= "1111000000001111"; -- in_data = 0xF0F1
        WAIT FOR clk_period;
        -- Check for correct immediate assignment
        check_results(instruction, (OTHERS => '0'), instruction_out, immediate, "Test 5");

        -- End simulation after tests
        REPORT "All tests completed!" SEVERITY NOTE;
        WAIT;
    END PROCESS;

END behavior;
