library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_lab2_3led is
    port (
        clk    : in  std_logic;
        reset_n: in  std_logic;

        seg_hund : out std_logic_vector(7 downto 0);
        seg_tens : out std_logic_vector(7 downto 0);
        seg_units: out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of top_lab2_3led is

    component lab2_led3 is
        port (
            clk_clk                              : in  std_logic;
            reset_reset_n                        : in  std_logic;
            hund_pio_external_connection_export  : out std_logic_vector(3 downto 0);
            tens_pio_external_connection_export  : out std_logic_vector(3 downto 0);
            units_pio_external_connection_export : out std_logic_vector(3 downto 0)
        );
    end component lab2_led3;


    component deco7seg is
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            sel     : in  std_logic_vector(3 downto 0);
            segment : out std_logic_vector(7 downto 0)
        );
    end component;


    signal hund_sig : std_logic_vector(3 downto 0);
    signal tens_sig : std_logic_vector(3 downto 0);
    signal units_sig: std_logic_vector(3 downto 0);

begin


    u0 : lab2_led3
        port map (
            clk_clk         => clk,
            reset_reset_n   => reset_n,
            hund_pio_external_connection_export  => hund_sig,
            tens_pio_external_connection_export  => tens_sig,
            units_pio_external_connection_export => units_sig
        );



    u_hund : deco7seg
        port map (
            clk     => clk,
            reset   => reset_n,
            sel     => hund_sig,
            segment => seg_hund
        );


    u_tens : deco7seg
        port map (
            clk     => clk,
            reset   => reset_n,
            sel     => tens_sig,
            segment => seg_tens
        );


    u_units : deco7seg
        port map (
            clk     => clk,
            reset   => reset_n,
            sel     => units_sig,
            segment => seg_units
        );

end architecture rtl;