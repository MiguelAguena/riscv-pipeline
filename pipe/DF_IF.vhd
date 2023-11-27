-- FILEPATH: /pipe/DF_EX.vhd

library ieee;
use ieee.std_logic_1164.all;

entity DF_IF is
    port (
        Clock : in std_logic;
        Reset : in std_logic;
        PCTargetE : in std_logic_vector(31 downto 0);
        PCSrcE : in std_logic;
        StallIF : in std_logic;

        PCF : out std_logic_vector(31 downto 0);
        PCPlus4 : out std_logic_vector(31 downto 0)
    );
end entity DF_IF;

architecture rtl of DF_IF is
    signal s_pc : std_logic_vector(31 downto 0);

    component register_d is
        generic (
            constant N : integer := 8
        );
        port (
            clock : in std_logic;
            clear : in std_logic;
            enable : in std_logic;
            D : in std_logic_vector (N - 1 downto 0);
            Q : out std_logic_vector (N - 1 downto 0)
        );
    end component;

    component alu is
        generic (
            size : natural := 64
        );

        port (
            A, B : in std_logic_vector(size - 1 downto 0);
            F : out std_logic_vector(size - 1 downto 0);
            S : in std_logic_vector(2 downto 0);
            Z : out std_logic;
            Ov : out std_logic;
            Co : out std_logic
        );
    end component alu;

    signal pc_in, s_pcplus4 : std_logic_vector(31 downto 0);
    signal pc_enable : std_logic;

    constant number_4_aux : std_logic_vector(31 downto 0) := (2 => '1', others => '0');
begin
    -- Adicione aqui a lógica do componente

    with PCSrcE select
        pc_in <= PCTargetE when '1',
        s_pcplus4 when others;

    pc_enable <= not StallIF;

    PC_REG : register_d generic map(
        N => 32) port map (
        clock => clock,
        clear => reset,
        enable => pc_enable,
        D => pc_in,
        Q => s_pc
    );

    PCF <= s_pc;

    PC_PLUS_4 : alu generic map(
        size => 32) port map (
        A => s_pc,
        B => number_4_aux,
        F => s_pcplus4,
        S => "000"
    );

    PCPlus4 <= s_pcplus4;
end architecture rtl;