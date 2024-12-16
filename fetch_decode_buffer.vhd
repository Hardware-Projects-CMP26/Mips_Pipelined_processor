LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY fetch_decode_buffer IS
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
END fetch_decode_buffer;

ARCHITECTURE fetch_decode_buffer_arch OF fetch_decode_buffer IS

    SIGNAL opCode : STD_LOGIC_VECTOR (4 DOWNTO 0);
    SIGNAL Imm : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL Rdst_index : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rsrc1_index : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Rsrc2_index : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL Int_index : STD_LOGIC_VECTOR (1 DOWNTO 0);
    SIGNAL PC : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN

    op_code_out <= opCode;
    immediate_out <= Imm;
    rdest_out_index <= Rdst_index;
    rsrc1_out_index <= Rsrc1_index;
    rsrc2_out_index <= Rsrc2_index;
    int_ind_out <= Int_index;
    pc_out <= PC;

    PROCESS (clk, rst, enable)
    BEGIN
        IF rising_edge(clk) THEN
            IF (enable /= '0' AND rst /= '1') THEN
                opCode <= instruction_in (15 DOWNTO 11);
                Rdst_index <= instruction_in (10 DOWNTO 8);
                Rsrc1_index <= instruction_in (7 DOWNTO 5);
                Rsrc2_index <= instruction_in (4 DOWNTO 2);
                Int_index <= instruction_in (1 DOWNTO 0);
                Imm <= immediate_in;
                PC <= pc_in;
            END IF;
            IF (rst = '1') THEN
                opCode <= (OTHERS => '0');
                Rdst_index <= (OTHERS => '0');
                Rsrc1_index <= (OTHERS => '0');
                Rsrc2_index <= (OTHERS => '0');
                Int_index <= (OTHERS => '0');
                Imm <= (OTHERS => '0');
                PC <= (OTHERS => '0');
            END IF;
        END IF;
    END PROCESS;

END fetch_decode_buffer_arch;