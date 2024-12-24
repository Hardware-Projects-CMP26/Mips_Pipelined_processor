LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY decode IS
    PORT (
        clk : IN STD_LOGIC;
        instruction : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        instruction_out : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        immediate : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
        in_data : IN STD_LOGIC_VECTOR (15 DOWNTO 0)
    );
END decode;

ARCHITECTURE decode_arch OF decode IS
    SIGNAL counter : INTEGER RANGE 0 TO 1 := 0;
    SIGNAL old_instruction : STD_LOGIC_VECTOR (15 DOWNTO 0) := (OTHERS => '0');
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            CASE counter IS
                WHEN 0 =>
                    IF (instruction(14) = '0') THEN
                        instruction_out <= instruction;
                        immediate <= (OTHERS => '0');
                    ELSIF (instruction(15 DOWNTO 13) = "111") THEN
                        instruction_out <= instruction;
                        immediate <= in_data;
                    ELSE
                        instruction_out <= (OTHERS => '0');
                        immediate <= (OTHERS => '0');
                        counter <= 1; 
                        old_instruction <= instruction;
                    END IF;

                WHEN 1 =>
                    instruction_out <= old_instruction;
                    immediate <= instruction;
                    counter <= 0;

                WHEN OTHERS =>
                    instruction_out <= (OTHERS => '0');
                    immediate <= (OTHERS => '0');
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE decode_arch;
