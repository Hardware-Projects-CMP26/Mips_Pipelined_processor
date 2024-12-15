LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY forwarding_unit IS
    PORT (
        EX_WB, MEM_WB : IN STD_LOGIC;
        EX_Rdest_IND, MEM_Rdest_IND, EX_Rsrc1, EX_Rsrc2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        sel1, sel2 : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
END forwarding_unit;

ARCHITECTURE forwarding_unit_arch OF forwarding_unit IS
BEGIN
    sel1 <= "01" WHEN (EX_WB = '1' AND EX_Rdest_IND = EX_Rsrc1) ELSE
            "10" WHEN (MEM_WB = '1' AND MEM_Rdest_IND = EX_Rsrc1) ELSE
            "00";

    sel2 <= "01" WHEN (EX_WB = '1' AND EX_Rdest_IND = EX_Rsrc2) ELSE
            "10" WHEN (MEM_WB = '1' AND MEM_Rdest_IND = EX_Rsrc2) ELSE
            "00";
END ARCHITECTURE forwarding_unit_arch;
