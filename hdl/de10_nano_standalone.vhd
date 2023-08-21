LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.numeric_std.all;

-- name of top level entity must match top level vhdl file name otherwise
-- compiler returns error "top level entity undefined"

entity de10_nano_standalone is
    port(
        FPGA_CLK1_50            : in std_logic;
        RST_N                   : in std_logic;
        HPS_DDR3_ADDR           : out std_logic_vector(14 downto 0);
        HPS_DDR3_BA             : out std_logic_vector(2 downto 0);
        HPS_DDR3_CAS_N          : out std_logic;
        HPS_DDR3_CK_N           : out std_logic;
        HPS_DDR3_CK_P           : out std_logic;
        HPS_DDR3_CKE            : out std_logic;
        HPS_DDR3_CS_N           : out std_logic;
        HPS_DDR3_DM             : out std_logic_vector(3 downto 0);
        HPS_DDR3_DQ             : inout std_logic_vector(31 downto 0);
        HPS_DDR3_DQS_N          : inout std_logic_vector(3 downto 0);
        HPS_DDR3_DQS_P          : inout std_logic_vector(3 downto 0);
        HPS_DDR3_ODT            : out std_logic;
        HPS_DDR3_RAS_N          : out std_logic;
        HPS_DDR3_RESET_N        : out std_logic;
        HPS_DDR3_RZQ            : in std_logic;
        HPS_DDR3_WE_N           : out std_logic
    );
end entity de10_nano_standalone;


architecture rtl of de10_nano_standalone is

-- COMPONENT DECLARATIONS --

    component soc_system is
        -- these lines below are copied from the soc_system.vhd that is generated from the Platform Designer
        -- ideally just update these lines any time the platform designer is updated

        port (
            clk_clk                  : in    std_logic                     := '0';             --             clk.clk
            hps_0_h2f_reset_reset_n  : out   std_logic;                                        -- hps_0_h2f_reset.reset_n
            hps_bridge_waitrequest   : in    std_logic                     := '0';             --      hps_bridge.waitrequest
            hps_bridge_readdata      : in    std_logic_vector(63 downto 0) := (others => '0'); --                .readdata
            hps_bridge_readdatavalid : in    std_logic                     := '0';             --                .readdatavalid
            hps_bridge_burstcount    : out   std_logic_vector(0 downto 0);                     --                .burstcount
            hps_bridge_writedata     : out   std_logic_vector(63 downto 0);                    --                .writedata
            hps_bridge_address       : out   std_logic_vector(9 downto 0);                     --                .address
            hps_bridge_write         : out   std_logic;                                        --                .write
            hps_bridge_read          : out   std_logic;                                        --                .read
            hps_bridge_byteenable    : out   std_logic_vector(7 downto 0);                     --                .byteenable
            hps_bridge_debugaccess   : out   std_logic;                                        --                .debugaccess
            memory_mem_a             : out   std_logic_vector(14 downto 0);                    --          memory.mem_a
            memory_mem_ba            : out   std_logic_vector(2 downto 0);                     --                .mem_ba
            memory_mem_ck            : out   std_logic;                                        --                .mem_ck
            memory_mem_ck_n          : out   std_logic;                                        --                .mem_ck_n
            memory_mem_cke           : out   std_logic;                                        --                .mem_cke
            memory_mem_cs_n          : out   std_logic;                                        --                .mem_cs_n
            memory_mem_ras_n         : out   std_logic;                                        --                .mem_ras_n
            memory_mem_cas_n         : out   std_logic;                                        --                .mem_cas_n
            memory_mem_we_n          : out   std_logic;                                        --                .mem_we_n
            memory_mem_reset_n       : out   std_logic;                                        --                .mem_reset_n
            memory_mem_dq            : inout std_logic_vector(31 downto 0) := (others => '0'); --                .mem_dq
            memory_mem_dqs           : inout std_logic_vector(3 downto 0)  := (others => '0'); --                .mem_dqs
            memory_mem_dqs_n         : inout std_logic_vector(3 downto 0)  := (others => '0'); --                .mem_dqs_n
            memory_mem_odt           : out   std_logic;                                        --                .mem_odt
            memory_mem_dm            : out   std_logic_vector(3 downto 0);                     --                .mem_dm
            memory_oct_rzqin         : in    std_logic                     := '0';             --                .oct_rzqin
            reset_reset_n            : in    std_logic                     := '0'              --           reset.reset_n
        );
    end component;

--******************* GLUE LOGIC BEGIN **********************--

begin

-- instantiate any ip/component blocks and map their I/O to top level I/O for pin assignments
soc0 : component soc_system
    port map (
        -- global generic
        clk_clk             => FPGA_CLK1_50,
        reset_reset_n       => RST_N,

        -- DDR3
        memory_mem_a        => HPS_DDR3_ADDR,
        memory_mem_ba       => HPS_DDR3_BA,
        memory_mem_cas_n    => HPS_DDR3_CAS_N,
        memory_mem_ck_n     => HPS_DDR3_CK_N,
        memory_mem_ck       => HPS_DDR3_CK_P,
        memory_mem_cke      => HPS_DDR3_CKE,
        memory_mem_cs_n     => HPS_DDR3_CS_N,
        memory_mem_dm       => HPS_DDR3_DM,
        memory_mem_dq       => HPS_DDR3_DQ,
        memory_mem_dqs_n    => HPS_DDR3_DQS_N,
        memory_mem_dqs      => HPS_DDR3_DQS_P,
        memory_mem_odt      => HPS_DDR3_ODT,
        memory_mem_ras_n    => HPS_DDR3_RAS_N,
        memory_mem_reset_n  => HPS_DDR3_RESET_N,
        memory_oct_rzqin    => HPS_DDR3_RZQ,
        memory_mem_we_n     => HPS_DDR3_WE_N
    );
end architecture rtl;
