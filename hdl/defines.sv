// indicate that we are using Quartus for compilation
`define QUARTUS_ENV

// Enable mSGDMA slave (system_top_level.sv)
// `define mSGDMA_ENABLE

// Enable old RGB driver (VHDL); found in system_top_level.sv
// `define TEST_PATTERN

// Enable the test pixel source; found in hdmi_pixel_driver.sv
// `define ENABLE_TEST_PIXEL