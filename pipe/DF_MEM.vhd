-- FILEPATH: /pipe/DF_EX.vhd

library ieee;
use ieee.std_logic_1164.all;

entity DF_MEM is
  port (
    -- Entradas
    Clock : in std_logic;
    AluResultM : in std_logic_vector(31 downto 0);
    WriteDataM : in std_logic_vector(31 downto 0);
    MemWriteM : in std_logic;
    -- Saídas
    ReadDataM : out std_logic_vector(31 downto 0)
  );
end entity DF_MEM;

architecture rtl of DF_MEM is
  component ram is
    generic (
        addr_s : natural := 64;
        word_s : natural := 32;
        init_f : string  := "ram.dat"
    );
    port (
        ck     : in  bit;
        rd, wr : in  bit;
        addr   : in  bit_vector(addr_s-1 downto 0);
        data_i : in  bit_vector(word_s-1 downto 0);
        data_o : out bit_vector(word_s-1 downto 0)
    );
  end component;
begin

  DATA_MEMORY : ram port(
    ck => Clock,
    rd => open,
    wr => MemWriteM,
    addr => AluResultM,
    data_i => WriteDataM,
    data_o => ReadDataMxx
  );

end architecture rtl;
