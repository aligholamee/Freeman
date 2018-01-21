----------------------------------------------------------------------------------
-- Company: Amirkabir University of Technology
-- Engineer: Ali Gholami (aligholamee) % Mehdi Safaee (mxii1994)
-- 
-- Create Date: 12/27/2017 05:49:31 PM
-- Design Name: 
-- Module Name: mbpc_testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mbpc_testbench is
--  Port ( );
end mbpc_testbench;

architecture Behavioral of mbpc_testbench is
    component PWSBD_wrapper is
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
    end component PWSBD_wrapper;

    
    -- WATERING SYSTEM SIGNALS
    signal TEMP_SENSOR_S: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal HUMID_SENSOR_S: STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal WCENABLE_S: STD_LOGIC := '0';
    
    -- PARKING CONTROLLER SIGNALS
    signal DETECTOR_INP_S: STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal DETECTOR_READY_S: STD_LOGIC;
    signal LAMP_VECTOR_S: STD_LOGIC_VECTOR(5 DOWNTO 0);
    signal RST_S: STD_LOGIC := '0';
    signal CLK_N_S: STD_LOGIC := '0';
    signal CLK_P_S: STD_LOGIC := '1';
    
    -- SECURITY CONTROLLER SIGNALS
    signal WINDOW_SENSE_S: STD_LOGIC;
    signal DOOR_SENSE_S: STD_LOGIC;
    signal ALARM_ENABLE_S: STD_LOGIC;
    signal KEY_SENSE_S: STD_LOGIC;
  
begin  
    CLK_N_S <= not CLK_N_S after 50ns;
    CLK_P_S <= not CLK_P_S after 50ns;
     
    wrapper_pm: PWSBD_wrapper port map (
        main_data_p_p => HUMID_SENSOR_S,
        main_temp_p_p => TEMP_SENSOR_S,
        main_watering_enable_p => WCENABLE_S,
        main_detector_input_p => DETECTOR_INP_S,
        main_detector_ready_p => DETECTOR_READY_S,
        main_lamp_vector_p => LAMP_VECTOR_S,
        reset => RST_S,
        sys_diff_clock_clk_n => CLK_N_S,
        sys_diff_clock_clk_p => CLK_P_S,
        -- SECURITY CONTROLLER SIGNALS
        main_window_sense_p_p => WINDOW_SENSE_S,
        main_door_sense_p_p => DOOR_SENSE_S,
        main_alarm_enable_p_p => ALARM_ENABLE_S,
        main_key_sense_p => KEY_SENSE_S
    );
end Behavioral;
