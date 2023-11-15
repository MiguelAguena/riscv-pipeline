-- FILEPATH: /pipe/DF_EX.vhd

library ieee;
use ieee.std_logic_1164.all;

entity DF_EX is
  port (
        Clock : in std_logic;
        Reset : in std_logic;
    --- Entradas
        RD1E : in std_logic_vector(31 downto 0);
        RD2E : in std_logic_vector(31 downto 0);
        PCE : in std_logic_vector(31 downto 0);
        ImmExtE : in std_logic_vector(31 downto 0);
        AluResultM : in std_logic_vector(31 downto 0);
        ResultW : in std_logic_vector(31 downto 0);
        ALUControlE : in std_logic_vector(2 downto 0);
        ALUsrcE : in std_logic;
        FowardAE : in std_logic_vector(1 downto 0);
        FowardBE : in std_logic_vector(1 downto 0);
    --- Saídas
        PCTargetE : out std_logic_vector(31 downto 0);
        WriteDataE : out std_logic_vector(31 downto 0);
        AluResultE : out std_logic_vector(31 downto 0);
        zeroE : out std_logic
  );
end entity DF_EX;

architecture rtl of DF_EX is
  component alu is
    generic (
        size : natural := 32
    );

    port (
        A, B : in  std_logic_vector(size-1 downto 0);
        F    : out std_logic_vector(size-1 downto 0);
        S    : in  std_logic_vector(2 downto 0);
        Z    : out std_logic;
        Ov   : out std_logic;
        Co   : out std_logic
    );
  end component alu;
  
  signal srcAE, srcBE, s_writeDataE : std_logic_vector(31 downto 0);
begin
  
  ALU_MAIN: alu generic map(32) port map(
    A => srcAE,
    B => srcBE,
    F => AluResultE,
    S => ALUControlE,
    Z => zeroE
  );

  with FowardAE select
    srcAE <=    RD1E when "00",
                resultW when "01",
                aluResultM when "10",
                (others => '0') when others;

  with FowardBE select
    s_writeDataE <= RD2E when "00",
                    resultW when "01",
                    aluResultM when "10",
                    (others => '0') when others;

  with AluSrcE select
    srcB <= s_writeDataE when '0',
            ImmExtE when others;

  ADDER4: alu generic map(32) port map(
    A => PCE,
    B => ImmExtE,
    F => PCTargetE,
    S => "000" --Fixo para soma
  );


  writeDataE <= s_writeDataE;
  
end architecture rtl;
