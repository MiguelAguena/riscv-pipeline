-- FILEPATH: /pipe/DF_EX.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;


entity DF_ID is
  port (
    Clock : in std_logic;
    Reset : in std_logic;
    InstrD : in std_logic_vector(31 downto 0);
    RegWriteW : in std_logic;
    ResultW : in std_logic_vector(31 downto 0);
    RdW : in std_logic_vector(4 downto 0);
    
    -- Entradas de Controle
    ImmSrcD : in std_logic_vector(1 downto 0);
    -- Saídas de fluxo
    RdD, RS1D, RS2D: out std_logic_vector(4 downto 0);
    RD1D, RD2D, ImmExtD: out std_logic_vector(31 downto 0)
  );
end entity DF_ID;

architecture rtl of DF_ID is

    component signExtend is
        port(
            i: in  std_logic_vector(24 downto 0);
            imm_src: in std_logic_vector(1 downto 0);
            o: out std_logic_vector(31 downto 0)
        );
    end component signExtend;

    component regfile is
        generic (
            reg_n: natural := 10;
            word_s: natural := 32
        );
    
        port (
            clock:        in  std_logic;
            reset:        in  std_logic;
            regWrite:     in  std_logic;
            rr1, rr2, wr: in  std_logic_vector(natural(ceil(log2(real(reg_n)))) -1 downto 0);
            d:            in  std_logic_vector(word_s-1 downto 0);
            q1, q2:       out std_logic_vector(word_s-1 downto 0)
        );
    end component;

  signal nclock : std_logic;
  signal reg_rr1, reg_rr2 : std_logic_vector(4 downto 0);
begin

    reg_rr1 <= InstrD(19 downto 15);
    reg_rr2 <= InstrD(24 downto 20);
    RdD <= InstrD(11 downto 7);
    RS1D <= reg_rr1;
    RS2D <= reg_rr2;


    -- Falta colocar o Imm

    SE: signExtend
        port map(
            i => InstrD(31 downto 7),
            imm_src => ImmSrcD,
            o => ImmExtD
        );

    
    nclock <= not clock;

    REG_BANK: regfile generic map(32, 32) port map(
        clock => nclock,
        reset => reset,
        regWrite => RegWriteW,
        rr1 => reg_rr1,
        rr2 => reg_rr2,
        wr => RdW,
        d => ResultW,
        q1 => RD1D,
        q2 => RD2D
    );

end architecture rtl;
