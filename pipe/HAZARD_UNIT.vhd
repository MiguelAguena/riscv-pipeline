library ieee;
use ieee.std_logic_1164.all;

entity HAZARD_UNIT is
    port(
    -- Entradas
    Rs1D   : in std_logic_vector(4 downto 0);
    Rs2D   : in std_logic_vector(4 downto 0);
    RdE    : in std_logic_vector(4 downto 0);
    Rs2E   : in std_logic_vector(4 downto 0);
    Rs1E   : in std_logic_vector(4 downto 0);
    PCScrE : in std_logic;
    ResultSrcE_0 : in std_logic;
    RdM    : in std_logic_vector(4 downto 0);
    RegWriteM : in std_logic;
    RdW    : in std_logic_vector(4 downto 0);
    RegWriteW : in std_logic;
    -- Saidas
    StallF : out std_logic;
    StallD : out std_logic;
    FlushD : out std_logic;
    FlushE : out std_logic;
    ForwardAE : out std_logic_vector(1 downto 0);
    ForwardBE : out std_logic_vector(1 downto 0)
    );
end entity;

architecture structural of HAZARD_UNIT is
    signal Rs1E_equal_to_RdM : std_logic_vector(4 downto 0);
    signal Rs1E_different_than_zero : std_logic_vector(4 downto 0);
    signal zero : std_logic_vector(4 downto 0) : "0000";
    signal Rs1E_equal_to_RdW : std_logic_vector(4 downto 0);

    signal Rs2E_equal_to_RdM : std_logic_vector(4 downto 0);
    signal Rs2E_equal_to_zero : std_logic_vector(4 downto 0);
    signal Rs2E_equal_to_RdW : std_logic_vector(4 downto 0);

    signal Rs1D_equal_to_RdE : std_logic_vector(4 downto 0);
    signal Rs2D_equal_to_RdE : std_logic_vector(4 downto 0);

    signal lwStall : std_logic;

begin 
    Rs1E_equal_to_RdM <= Rs1E XNOR RdM;
    Rs1E_different_than_zero <= Rs1E XOR zero;
    Rs1E_equal_to_RdW <= Rs1E XNOR RdW;

    Rs2E_equal_to_RdM <= Rs2E XNOR RdM;
    Rs2E_different_than_zero <= Rs2E XOR zero;
    Rs2E_equal_to_RdW <= Rs2E XNOR RdW;

    Rs1D_equal_to_RdE <= Rs1D XNOR RdE;
    Rs2D_equal_to_RdE <= Rs2D XNOR RdE;

    ForwardAE <= "10" when (Rs1E_equal_to_RdM and RegWriteM and Rs1E_different_than_zero) else
                 "01" when (Rs1E_equal_to_RdW and RegWriteW and Rs1E_different_than_zero) else
                 "00" when others;
    ForwardBE <= "10" when (Rs2E_equal_to_RdM and RegWriteM and Rs2E_different_than_zero) else 
                 "01" when (Rs2E_equal_to_RdW and RegWriteW and Rs2E_different_than_zero) else
                 "00" when others;
    
    lwStall <= ResultSrcE_0 and (Rs1D_equal_to_RdE or Rs2D_equal_to_RdE);
    StallF <= lwStall;
    StallD <= lwStall;

    FlushD <= PCSrcE;
    FlushE <= lwStall or PCSrcE;

end architecture;