-- FILEPATH: /pipe/DF_EX.vhd

library ieee;
use ieee.std_logic_1164.all;

entity DF_ID is
  port (
    instruction : in std_logic_vector(31 downto 0);
    regWrite : in std_logic;
    regData : in std_logic_vector(31 downto 0);
    regAddress : in std_logic_vector(4 downto 0);
    
    -- Entradas de Controle
    ImmSrcD : in std_logic_vector(1 downto 0);
    -- Saídas de fluxo
    regOut1 , regOut2, regOutW, ImmExtD: out std_logic_vector(31 downto 0)
  );
end entity DF_ID;

architecture rtl of DF_ID is

  signal nclock : std_logic;
  signal reg_rr1, reg_rr2 : std_logic_vector(4 downto 0);
begin

    reg_rr1 <= instruction(19 downto 15);
    reg_rr2 <= instruction(24 downto 20);

    regOutW <= instruction(11 downto 7);

    -- Falta colocar o Imm
    
    nclock <= not clock;
    REG_BANK: regfile generic map(32, 32) port map(
        clock => nclock,
        reset => reset,
        regWrite => reg_load,
        rr1 => reg_rr1,
        rr2 => reg_rr2,
        wr => regAddress,
        d => regData,
        q1 => regOut1,
        q2 => regOut2
    );

end architecture rtl;
