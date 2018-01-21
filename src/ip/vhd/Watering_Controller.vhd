----------------------------------------------------------------------------------
-- Company: Amirkabir University of Technology
-- Engineer: Ali Gholami (aligholamee) % Mehdi Safaee (mxii1994)
-- 
-- Create Date: 01/16/2018 02:49:33 PM
-- Design Name: 
-- Module Name: Watering_Controller - Behavioral
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
use ieee.numeric_std.ALL;

entity WateringController is
    port(
        temp_p: in std_logic_vector(31 downto 0);
        data_p: in std_logic_vector(31 downto 0);
        watering_command: in std_logic_vector(31 downto 0);
        watering_enable: out std_logic;
        clk: in std_logic
    );
end WateringController;

architecture RTL of WateringController is

    -- TYPES FOR TIME AND STATE
    type STATE_TYPE is (OFF_MODE, ON_MODE, RECOVERY);
    subtype TIME_TYPE is integer range 0 to 24;
    
    -- STATE SIGNAL
    signal STATE: STATE_TYPE := OFF_MODE;

    -- IMPLEMENTS THE SAFE FSM CREDINTIALS
    attribute safe_recovery_state: string;
    attribute safe_recovery_state of STATE: signal is "RECOVERY";

    -- SIGNAL DENOTING THE TIME
    signal TIME_S: TIME_TYPE := 24;
    
    -- ALL ONES SIGNAL FOR COMPARE PURPOSES
    signal ALL_ONES_VECTOR: std_logic_vector(31 downto 0) := (others => '1');
 
begin
    W_C: process(clk)
    begin 
        if(rising_edge(clk)) then
            if(watering_command = ALL_ONES_VECTOR) then
                case STATE is
                    when OFF_MODE =>
                        if((TIME_S >= 6) and (TIME_S < 12) and (to_integer(unsigned(data_p)) <= 25) and (to_integer(unsigned(temp_p)) > 35)) then
                            STATE <= ON_MODE;
                            watering_enable <= '1';
                        elsif((TIME_S >= 12) and (TIME_S < 16) and (to_integer(unsigned(data_p)) <= 20) and (to_integer(unsigned(temp_p)) > 50)) then
                            STATE <= ON_MODE;
                            watering_enable <= '1';
                        elsif((TIME_S >= 16) and (TIME_S < 19) and (to_integer(unsigned(data_p)) <= 35) and (to_integer(unsigned(temp_p)) < 30)) then
                            STATE <= ON_MODE;
                            watering_enable <= '1';
                        elsif((TIME_S >=  19) and (TIME_S < 6) and (to_integer(unsigned(data_p)) <= 70)) then
                            STATE <= ON_MODE;
                            watering_enable <= '1';
                        elsif((to_integer(unsigned(temp_p)) < 0)) then
                            STATE <= ON_MODE;
                            watering_enable <= '1';
                        else
                            STATE <= OFF_MODE;
                            watering_enable <= '0';
                        end if;
                    
                    when ON_MODE => 
                        if((TIME_S >= 6) and (TIME_S < 12) and (to_integer(unsigned(data_p)) <= 25) and (to_integer(unsigned(temp_p)) > 35)) then
                            STATE <= ON_MODE;
                            watering_enable <= '1';
                        elsif((TIME_S >= 12) and (TIME_S < 16) and (to_integer(unsigned(data_p)) <= 20) and (to_integer(unsigned(temp_p)) > 50)) then
                            STATE <= ON_MODE;
                            watering_enable <= '1';
                        elsif((TIME_S >= 16) and (TIME_S < 19) and (to_integer(unsigned(data_p)) <= 35) and (to_integer(unsigned(temp_p)) < 30)) then
                            STATE <= ON_MODE;
                            watering_enable <= '1';
                        elsif((TIME_S >=  19) and (TIME_S < 6) and (to_integer(unsigned(data_p)) <= 70)) then
                            STATE <= ON_MODE;
                            watering_enable <= '1';
                        elsif((to_integer(unsigned(temp_p)) < 0)) then
                            STATE <= ON_MODE;
                            watering_enable <= '1';
                        else
                            STATE <= OFF_MODE;
                            watering_enable <= '0';
                        end if;
                    
                    when RECOVERY => 
                        STATE <= OFF_MODE;
                        watering_enable <= '0';
                        
                    end case;       
            else
                STATE <= OFF_MODE;
                watering_enable <= '0';
            end if;
        end if;
    end process;   
end RTL;
