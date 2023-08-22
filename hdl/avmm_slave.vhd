library ieee;
use ieee.std_logic_1164.all;


entity avmm_slave is

    port(
        WAIT_REQ        : out std_logic;
        READ_DATA       : out std_logic_vector(63 downto 0);
        READ_DATA_VALID : out std_logic;

        CLK             : in std_logic;
        WRITE_DATA      : in std_logic_vector(63 downto 0);
        ADDRESS         : in std_logic_vector(9 downto 0);
        WRITE_CMD       : in std_logic;
        READ_CMD        : in std_logic;
        BYTE_ENABLE     : in std_logic_vector(7 downto 0);
        DEBUG_ACCESS    : in std_logic
    );
    end avmm_slave;

architecture rtl of avmm_slave is
begin
    READ_DATA_VALID <= '1' when READ_CMD = '1' else '0';
    -- READ_DATA(63 downto 12) <= (others => '0');
    -- READ_DATA(9 downto 0) <= ADDRESS(9 downto 0);
    READ_DATA(63 downto 12) <= X"1234_5678_9ABC_D";
    READ_DATA(11 downto 0) <= X"3FF";

end rtl;
