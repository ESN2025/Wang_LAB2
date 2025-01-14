library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_lab2 is
    port (
        clk       : in  std_logic;
        reset_n   : in  std_logic;
        seg_out   : out std_logic_vector(7 downto 0)
    );
end entity top_lab2;

architecture rtl of top_lab2 is


    component lab2 is
        port (
            clk_clk                            : in  std_logic;    
            reset_reset_n                      : in  std_logic;   

            segment_external_connection_export : out std_logic_vector(7 downto 0);

            sel_external_connection_export     : out std_logic_vector(3 downto 0)
        );
    end component;


    component deco7seg is
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            sel     : in  std_logic_vector(3 downto 0);
            segment : out std_logic_vector(7 downto 0)
        );
    end component;


    signal sel_from_qsys : std_logic_vector(3 downto 0);

begin

    u0 : lab2
        port map (
            clk_clk        => clk,
            reset_reset_n  => reset_n,
            segment_external_connection_export => open,
            sel_external_connection_export     => sel_from_qsys
        );

    u1 : deco7seg
        port map (
            clk     => clk,
            reset   => reset_n,
            sel     => sel_from_qsys,  
            segment => seg_out         
        );

end architecture rtl;
