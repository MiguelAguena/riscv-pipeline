entity tb is
end tb;

architecture tb_1 of tb is
    component ram is
        generic (
            addr_s : natural := 8;
            word_s : natural := 64;
            a : natural := 32;
            b : natural := 96
        );
        port (
            ck     : in  bit;
            rd, wr : in  bit;
            addr   : in  bit_vector(addr_s-1 downto 0);
            data_i : in  bit_vector(word_s-1 downto 0);
            data_o : out bit_vector(word_s-1 downto 0)
        );
    end component ram;
    signal dmem_addr_aux : bit_vector(7 downto 0);
    signal dmem_dati_aux : bit_vector(63 downto 0);
    signal dmem_dato_aux : bit_vector(63 downto 0);
    signal dmem_we_aux : bit;
    signal clock : bit;
begin
    RAMTEST: ram generic map (8, 64, 32, 96) port map (
        ck => clock,
        rd => '1',
        wr => dmem_we_aux,
        addr => dmem_addr_aux,
        data_i => dmem_dati_aux,
        data_o => dmem_dato_aux
    );

    p: process is
        type pattern_type is record
            clock : bit;
            addr : bit_vector(7 downto 0);
        end record;
        type pattern_array is array (natural range <>) of pattern_type;
        constant patterns : pattern_array := (
            ('0', "00000000"),
            ('1', "00000001"),
            ('0', "00000010")
        );
    begin
        for k in patterns'range loop
            dmem_addr_aux <= patterns(k).addr;
            clock <= patterns(k).clock;
            wait for 1 ns;
        end loop;

        assert false report "end of test" severity note;
        wait;
    end process;
end architecture;