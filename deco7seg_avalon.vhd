library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity deco7seg_avalon is
    port (
        clk            : in  std_logic;
        reset_n        : in  std_logic;

        -- Avalon-MM slave signals
        avs_chipselect : in  std_logic;
        avs_read       : in  std_logic;
        avs_write      : in  std_logic;
        avs_address    : in  std_logic_vector(1 downto 0);
        avs_writedata  : in  std_logic_vector(31 downto 0);
        avs_readdata   : out std_logic_vector(31 downto 0);

        -- 7段显示输出
        segment        : out std_logic_vector(7 downto 0)  -- (dp g f e d c b a)
    );
end deco7seg_avalon;

architecture rtl of deco7seg_avalon is

    -- 用来存储“要显示的数字” (0~9)
    signal sel_reg       : std_logic_vector(3 downto 0) := (others => '0');
    -- 用来返回读操作的数据
    signal read_data_reg : std_logic_vector(31 downto 0) := (others => '0');

begin

    ----------------------------------------------------------------------------
    -- 1) Avalon-MM 写读寄存器逻辑
    ----------------------------------------------------------------------------
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            sel_reg       <= (others => '0');
            read_data_reg <= (others => '0');
        elsif rising_edge(clk) then
            if avs_chipselect = '1' then
                -- 写操作
                if avs_write = '1' then
                    case avs_address is
                        when "00" =>
                            -- 仅用 avs_writedata 的低4位作为 sel_reg
                            sel_reg <= avs_writedata(3 downto 0);
                        when others =>
                            null;
                    end case;
                end if;

                -- 读操作
                if avs_read = '1' then
                    case avs_address is
                        when "00" =>
                            -- 把 sel_reg 写到 readdata(3..0) 低位
                            read_data_reg(3 downto 0) <= sel_reg;
                            read_data_reg(31 downto 4) <= (others => '0');
                        when others =>
                            read_data_reg <= (others => '0');
                    end case;
                end if;
            end if;
        end if;
    end process;

    -- 最终输出给 avalon 读口
    avs_readdata <= read_data_reg;

    ----------------------------------------------------------------------------
    -- 2) 七段译码逻辑 (共阳极示例：1=灭, 0=亮)
    ----------------------------------------------------------------------------
    process(clk, reset_n)
    begin
        if reset_n = '0' then
            -- 复位时全部熄灭
            segment <= (others => '1');
        elsif rising_edge(clk) then
            case sel_reg is
                when "0000" => segment <= "11000000"; -- 显示0
                when "0001" => segment <= "11111001"; -- 显示1
                when "0010" => segment <= "10100100"; -- 显示2
                when "0011" => segment <= "10110000"; -- 显示3
                when "0100" => segment <= "10011001"; -- 显示4
                when "0101" => segment <= "10010010"; -- 显示5
                when "0110" => segment <= "10000010"; -- 显示6
                when "0111" => segment <= "11111000"; -- 显示7
                when "1000" => segment <= "10000000"; -- 显示8
                when "1001" => segment <= "10010000"; -- 显示9
                when others => segment <= "11111111"; -- 熄灭(含dp)
            end case;
        end if;
    end process;

end architecture rtl;
