library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity riscv_pp_tb is
end riscv_pp_tb;

architecture arch of riscv_pp_tb is

    component riscv_pp is
        port (
            clock : in std_logic;
            reset : in std_logic;

            --- Mem In
            InstrF : in std_logic_vector(31 downto 0);
            ReadDataM : in std_logic_vector(31 downto 0);

            -- Mem Out
            PCF : out std_logic_vector(31 downto 0);
            ALUResultM : out std_logic_vector(31 downto 0);
            WriteDataM : out std_logic_vector(31 downto 0);
            MemWriteM : out std_logic
        );
    end component;

    constant clockPeriod : time := 20 ns; -- clock de 50MHz
    signal keep_simulating : std_logic := '0'; -- delimita o tempo de geração do clock

    type mem is array (natural range <>) of std_logic_vector(7 downto 0);
    signal instMem : mem(0 to 4095) := (others => (others => '0'));
    signal dataMem : mem(0 to 4095) := (others => (others => '0'));

    signal reset_s : std_logic := '1';

    signal InstrF_s : std_logic_vector(31 downto 0) := (others => '0');
    signal ReadDataM_s : std_logic_vector(31 downto 0) := (others => '0');

    signal PCF_s : std_logic_vector(31 downto 0) := (others => '0');
    signal ALUResultM_s : std_logic_vector(31 downto 0) := (others => '0');
    signal WriteDataM_s : std_logic_vector(31 downto 0) := (others => '0');
    signal MemWriteM_s : std_logic := '0';

    signal clock_in : std_logic := '0';

    type programType is array (natural range <>) of std_logic_vector(31 downto 0);
    signal program : programType(0 to 20) := (
        x"00500113",
        x"00C00193",
        x"FF718393",
        x"0023E233",
        x"0041F2B3",
        x"004282B3",
        x"02728863",
        x"0041A233",
        x"00020463",
        x"00000293",
        x"0023A233",
        x"005203B3",
        x"402383B3",
        x"0471AA23",
        x"06002103",
        x"005104B3",
        x"008001EF",
        x"00100113",
        x"00910133",
        x"0221A023",
        x"00210063"
    );

begin
    clock_in <= (not clock_in) and keep_simulating after clockPeriod/2;

    uut : riscv_pp
    port map(
        clock => clock_in,
        reset => reset_s,

        --- Mem In
        InstrF => InstrF_s,
        ReadDataM => ReadDataM_s,

        -- Mem Out
        PCF => PCF_s,
        ALUResultM => ALUResultM_s,
        WriteDataM => WriteDataM_s,
        MemWriteM => MemWriteM_s
    );

    ReadDataM_s <= dataMem(to_integer(unsigned(ALUResultM_s(11 downto 0))) + 3) & dataMem(to_integer(unsigned(ALUResultM_s(11 downto 0))) + 2) &
                   dataMem(to_integer(unsigned(ALUResultM_s(11 downto 0))) + 1) & dataMem(to_integer(unsigned(ALUResultM_s(11 downto 0))));

    InstrF_s <= instMem(to_integer(unsigned(PCF_s(11 downto 0))) + 3) & instMem(to_integer(unsigned(PCF_s(11 downto 0))) + 2) &
                instMem(to_integer(unsigned(PCF_s(11 downto 0))) + 1) & instMem(to_integer(unsigned(PCF_s(11 downto 0))));

    mempro : process (clock_in)
    begin
        if rising_edge(clock_in) then
            if MemWriteM_s = '1' then
                dataMem(to_integer(unsigned(ALUResultM_s(11 downto 0)))) <= WriteDataM_s(7 downto 0);
                dataMem(to_integer(unsigned(ALUResultM_s(11 downto 0))) + 1) <= WriteDataM_s(15 downto 8);
                dataMem(to_integer(unsigned(ALUResultM_s(11 downto 0))) + 2) <= WriteDataM_s(23 downto 16);
                dataMem(to_integer(unsigned(ALUResultM_s(11 downto 0))) + 3) <= WriteDataM_s(31 downto 24);
            end if;
        end if;
    end process; -- mempro

    stimulus : process is
    begin
        assert false report "Inicio das simulacoes" severity note;
        keep_simulating <= '1';

        -- Insira lógica de preparação dos testes aqui

        for i in program'range loop
            instMem(4 * i) <= program(i)(7 downto 0);
            instMem(4 * i + 1) <= program(i)(15 downto 8);
            instMem(4 * i + 2) <= program(i)(23 downto 16);
            instMem(4 * i + 3) <= program(i)(31 downto 24);
        end loop;

        reset_s <= '0';

        -- Insira lógica de teste aqui

        wait for (program'length * 5 + 3) * clockPeriod;

        assert false report "Fim das simulacoes" severity note;
        keep_simulating <= '0';

        wait; -- fim da simulação: aguarda indefinidamente (não retirar esta linha)
    end process;
end arch; -- arch