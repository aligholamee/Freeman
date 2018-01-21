--Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2015.4 (win64) Build 1412921 Wed Nov 18 09:43:45 MST 2015
--Date        : Sun Jan 21 02:16:09 2018
--Host        : aligholamee running 64-bit major release  (build 9200)
--Command     : generate_target PWSBD_wrapper.bd
--Design      : PWSBD_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity PWSBD_wrapper is
  port (
    main_alarm_enable_p_p : out STD_LOGIC;
    main_data_p_p : in STD_LOGIC_VECTOR ( 31 downto 0 );
    main_detector_input_p : in STD_LOGIC_VECTOR ( 31 downto 0 );
    main_detector_ready_p : in STD_LOGIC;
    main_door_sense_p_p : in STD_LOGIC;
    main_key_sense_p : in STD_LOGIC;
    main_lamp_vector_p : out STD_LOGIC_VECTOR ( 5 downto 0 );
    main_temp_p_p : in STD_LOGIC_VECTOR ( 31 downto 0 );
    main_watering_enable_p : out STD_LOGIC;
    main_window_sense_p_p : in STD_LOGIC;
    reset : in STD_LOGIC;
    sys_diff_clock_clk_n : in STD_LOGIC;
    sys_diff_clock_clk_p : in STD_LOGIC
  );
end PWSBD_wrapper;

architecture STRUCTURE of PWSBD_wrapper is
  component PWSBD is
  port (
    sys_diff_clock_clk_n : in STD_LOGIC;
    sys_diff_clock_clk_p : in STD_LOGIC;
    reset : in STD_LOGIC;
    main_detector_input_p : in STD_LOGIC_VECTOR ( 31 downto 0 );
    main_detector_ready_p : in STD_LOGIC;
    main_temp_p_p : in STD_LOGIC_VECTOR ( 31 downto 0 );
    main_data_p_p : in STD_LOGIC_VECTOR ( 31 downto 0 );
    main_window_sense_p_p : in STD_LOGIC;
    main_door_sense_p_p : in STD_LOGIC;
    main_key_sense_p : in STD_LOGIC;
    main_lamp_vector_p : out STD_LOGIC_VECTOR ( 5 downto 0 );
    main_watering_enable_p : out STD_LOGIC;
    main_alarm_enable_p_p : out STD_LOGIC
  );
  end component PWSBD;
begin
PWSBD_i: component PWSBD
     port map (
      main_alarm_enable_p_p => main_alarm_enable_p_p,
      main_data_p_p(31 downto 0) => main_data_p_p(31 downto 0),
      main_detector_input_p(31 downto 0) => main_detector_input_p(31 downto 0),
      main_detector_ready_p => main_detector_ready_p,
      main_door_sense_p_p => main_door_sense_p_p,
      main_key_sense_p => main_key_sense_p,
      main_lamp_vector_p(5 downto 0) => main_lamp_vector_p(5 downto 0),
      main_temp_p_p(31 downto 0) => main_temp_p_p(31 downto 0),
      main_watering_enable_p => main_watering_enable_p,
      main_window_sense_p_p => main_window_sense_p_p,
      reset => reset,
      sys_diff_clock_clk_n => sys_diff_clock_clk_n,
      sys_diff_clock_clk_p => sys_diff_clock_clk_p
    );
end STRUCTURE;
