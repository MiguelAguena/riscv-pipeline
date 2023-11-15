-- FILEPATH: /pipe/DF_EX.vhd

library ieee;
use ieee.std_logic_1164.all;

entity DF_WB is
  port (
    -- Entradas
    ReadDataW : in std_logic_vector(31 downto 0);
    PCPlus4W  : in std_logic_vector(31 downto 0);
    AluResultW : in std_logic_vector(31 downto 0);
    ResultSrcW : in std_logic_vector(1 downto 0);
    -- Saídas
    ResultW : out std_logic_vector(31 downto 0)
  );
end entity DF_WB;

architecture rtl of DF_WB is
  signal saida_mux : std_logic_vector(31 downto 0);

begin
    with ResultSrcW select
      saida_mux <=  AluResultW when "00",
                    ReadDataW when "01",
                    PCPlus4W when others;
    
    ResultW <= saida_mux;

end architecture rtl;
