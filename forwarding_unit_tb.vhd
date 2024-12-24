LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY forwarding_unit_tb IS
    -- No ports in the testbench
END forwarding_unit_tb;

ARCHITECTURE behavior OF forwarding_unit_tb IS
    COMPONENT forwarding_unit
        PORT (
            EX_WB, MEM_WB : IN STD_LOGIC;
            EX_Rdest_IND, MEM_Rdest_IND, EX_Rsrc1, EX_Rsrc2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            sel1, sel2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT;

    SIGNAL EX_WB, MEM_WB : STD_LOGIC;
    SIGNAL EX_Rdest_IND, MEM_Rdest_IND, EX_Rsrc1, EX_Rsrc2 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL sel1, sel2 : STD_LOGIC_VECTOR(1 DOWNTO 0);

    -- Procedure to check results and log pass/fail
    PROCEDURE check_result (
        signal actual_sel1 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        signal actual_sel2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        expected_sel1 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        expected_sel2 : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        test_case_name : IN STRING
    ) IS
    BEGIN
        IF (actual_sel1 = expected_sel1 AND actual_sel2 = expected_sel2) THEN
            REPORT test_case_name & " PASSED" SEVERITY NOTE;
        ELSE
            REPORT test_case_name & " FAILED." ;
        END IF;
    END PROCEDURE;

BEGIN
    uut: forwarding_unit
        PORT MAP (
            EX_WB => EX_WB,
            MEM_WB => MEM_WB,
            EX_Rdest_IND => EX_Rdest_IND,
            MEM_Rdest_IND => MEM_Rdest_IND,
            EX_Rsrc1 => EX_Rsrc1,
            EX_Rsrc2 => EX_Rsrc2,
            sel1 => sel1,
            sel2 => sel2
        );

    process
    begin
        -- Test case 1: No forwarding
        EX_WB <= '0'; MEM_WB <= '0';
        EX_Rdest_IND <= "000"; MEM_Rdest_IND <= "001";
        EX_Rsrc1 <= "010"; EX_Rsrc2 <= "011";
        wait for 10 ns;
        check_result(sel1, sel2, "00", "00", "Test Case 1: No forwarding");

        -- Test case 2: EX forwarding for EX_Rsrc1
        EX_WB <= '1'; MEM_WB <= '0';
        EX_Rdest_IND <= "010"; MEM_Rdest_IND <= "001";
        EX_Rsrc1 <= "010"; EX_Rsrc2 <= "011";
        wait for 10 ns;
        check_result(sel1, sel2, "01", "00", "Test Case 2: EX forwarding for EX_Rsrc1");

        -- Test case 3: MEM forwarding for EX_Rsrc1
        EX_WB <= '0'; MEM_WB <= '1';
        EX_Rdest_IND <= "000"; MEM_Rdest_IND <= "010";
        EX_Rsrc1 <= "010"; EX_Rsrc2 <= "011";
        wait for 10 ns;
        check_result(sel1, sel2, "10", "00", "Test Case 3: MEM forwarding for EX_Rsrc1");

        -- Test case 4: EX forwarding for EX_Rsrc2
        EX_WB <= '1'; MEM_WB <= '0';
        EX_Rdest_IND <= "011"; MEM_Rdest_IND <= "000";
        EX_Rsrc1 <= "001"; EX_Rsrc2 <= "011";
        wait for 10 ns;
        check_result(sel1, sel2, "00", "01", "Test Case 4: EX forwarding for EX_Rsrc2");

        -- Test case 5: MEM forwarding for EX_Rsrc2
        EX_WB <= '0'; MEM_WB <= '1';
        EX_Rdest_IND <= "000"; MEM_Rdest_IND <= "011";
        EX_Rsrc1 <= "001"; EX_Rsrc2 <= "011";
        wait for 10 ns;
        check_result(sel1, sel2, "00", "10", "Test Case 5: MEM forwarding for EX_Rsrc2");

        -- Test case 6: Both EX and MEM forwarding (priority to EX)
        EX_WB <= '1'; MEM_WB <= '1';
        EX_Rdest_IND <= "100"; MEM_Rdest_IND <= "100";
        EX_Rsrc1 <= "100"; EX_Rsrc2 <= "100";
        wait for 10 ns;
        check_result(sel1, sel2, "01", "01", "Test Case 6: Both EX and MEM forwarding");

        REPORT "All test cases completed" SEVERITY NOTE;
        wait;
    end process;
END ARCHITECTURE behavior;
