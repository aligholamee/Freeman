----------------------------------------------------------------------------------
-- Company: Amirkabir University of Technology
-- Engineer: Ali Gholami (aligholamee) % Mehdi Safaee (mxii1994)
-- 
-- Create Date: 12/13/2017 01:08:19 PM
-- Design Name: 
-- Module Name: ParkingController - Behavioral
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
use work.common.all;

entity ParkingController is
    port(
        command: in std_logic_vector(31 downto 0);
        commandReady: in std_logic;
        detectorInput: in integer;
        detectorReady: in std_logic;
        lampVector: out std_logic_vector(5 downto 0);
        clk: in std_logic;
        rst: in std_logic
    );
end ParkingController;

architecture Behavioral of ParkingController is
    type STATE_TYPE is (NO_PATTERN, SHARP, STAR, RECOVERY);

    -- STATE SIGNAL
    signal STATE: STATE_TYPE := NO_PATTERN;
        
    -- LOCATION AND PLATE NUMBER CONTAINERS
    signal PLATE_NO: integer := 0;
    signal PARKING_LOCATION: integer := 0;
    
    -- IMPLEMENTS THE SAFE FSM CREDINTIALS
    attribute safe_recovery_state: string;
    attribute safe_recovery_state of STATE: signal is "RECOVERY";

    -- CONSTANT FOR THE INITIAL VALUE OF THE DATABASE CELLS
    constant const_init: PLATE := (NUMBER => 0, LOCATION => 0);

    -- CAR DATABASE
    signal CAR_DB: PLATE_DB := (others => const_init);

    -- NUMBER OF CARS
    signal NUMOFCARS: integer := 0;

begin
    -- THE PATTERN RECOGNIZER FSM PROCESS
    P_R: process(command(0))
    variable SHIFTED: PLATE_DB := (others => const_init);
    variable PLATE_DIGIT_CONTROLLER: integer := 0;
    variable LOC_DIGIT_CONTROLLER: integer := 0;
    begin
        if(rst = '0') then
            STATE <= NO_PATTERN;
        else
            case STATE is
                when NO_PATTERN =>
                    LOC_DIGIT_CONTROLLER := 0;
                    PLATE_DIGIT_CONTROLLER := 0;
                    PLATE_NO <= 0;
                    PARKING_LOCATION <= 0;
                    if(command(9 downto 1) = "000100000") then
                        -- # ASCII: 32 => 00100000
                        STATE <= SHARP;
                    else
                        STATE <= STATE; 
                    end if;

                when SHARP =>
                    if(command(9 downto 1) = "000101010") then
                        -- * ASCII: 42 => 00101010
                        STATE <= STAR;
                    else
                        if(not(PLATE_DIGIT_CONTROLLER = 5)) then
                            PLATE_NO <= PLATE_NO * 10 + to_integer(unsigned(command(9 downto 1)));
                            PLATE_DIGIT_CONTROLLER := PLATE_DIGIT_CONTROLLER + 1;
                        else
                            PLATE_NO <= PLATE_NO;
                        end if;
                        -- STAY ON THIS STATE UNTIL * OCCURS
                    end if;

                when STAR =>
                    if(command(9 downto 1) = "000100000") then
                        -- # ASCII: 32 => 00100000
                        STATE <= NO_PATTERN;
                    else
                        if(not(LOC_DIGIT_CONTROLLER = 2)) then
                            PARKING_LOCATION <= PARKING_LOCATION * 10 + to_integer(unsigned(command(9 downto 1)));
                            LOC_DIGIT_CONTROLLER := LOC_DIGIT_CONTROLLER + 1;
                        else
                            PARKING_LOCATION <= PARKING_LOCATION;
                        end if;
                        -- STAY ON THIS STATE UNTIL # OCCURS
                    end if;

                when RECOVERY =>
                    STATE <= NO_PATTERN;
            end case;

            -- CHECK IF THE LSB OF THE COMMAND PORT CHANGES :D
            -- IF SO, SAVE THE CURRENT RESULT AND SORT THE ARRAY AND WAIT FOR THE NEXT ONE. :D
            SHIFTED := (others => const_init);
            if(commandReady = '1') then
                for i in 0 to 98 loop
                    if(PLATE_NO < CAR_DB(i).NUMBER) then
                        -- SHIFT THE REST and Exit
                        for j in i to 98 loop
                            SHIFTED(j+1) := CAR_DB(j);
                        end loop;
                        exit;
                    else
                        SHIFTED(i) := CAR_DB(i);
                    end if;
                end loop;
                -- Put back the result
                CAR_DB <= SHIFTED;
                
                -- THE FIRST LOCATION WITH VALUE 0 IS YOUR DESTINY :)
                for i in 0 to 99 loop
                    if(CAR_DB(i).NUMBER = 0) then                             
                        CAR_DB(i).NUMBER <= PLATE_NO;
                        CAR_DB(i).LOCATION <= PARKING_LOCATION;
                        exit;
                    end if;
                end loop;
            end if;
        end if;
    end process;

    -- THE PLATE RECOGNIZER SYSTEM PROCESS
    C_R: process(clk)
    variable indexResult : integer := -1;
    variable lowIndex: integer := 0;
    variable highIndex: integer := 99;
    variable centerIndex: integer := 0;
    begin
        if(rising_edge(clk)) then
            if(rst = '0') then
                lampVector <= "000000";
            else
                if(detectorReady = '1') then
                    -- FIND THE DETECTOR INPUT IN THE CAR_DB
                    for i in 0 to 8 loop
                        centerIndex := (lowIndex + highIndex) / 2;
                        if(CAR_DB(centerIndex).NUMBER = 0) then
                            -- Search the left side half
                            highIndex := centerIndex;
                        elsif (CAR_DB(centerIndex).NUMBER = detectorInput) then
                            indexResult := CAR_DB(centerIndex).LOCATION;
                        elsif(CAR_DB(centerIndex).NUMBER < detectorInput) then
                            lowIndex := centerIndex;
                        else
                           highIndex := centerIndex;
                        end if;
                    end loop;
                    if(indexResult > -1) then   -- MAKE SURE WE'VE FOUND THE PLATE
                        -- LAMP(5): FLOOR 2 - LEFT
                        -- LAMP(4): FLOOR 2 - CENTER
                        -- LAMP(3): FLOOR 2 - RIGHT
                        -- LAMP(2): FLOOR 1 - LEFT
                        -- LAMP(1): FLOOR 1 - CENTER
                        -- LAMP(0): FLOOR 1 - RIGHT
                        if(indexResult > -1 and indexResult < 25) then
                            -- FLOOR 1 - RIGHT
                            lampVector <= "000011";
                        elsif(indexResult > 25 and indexResult < 50) then
                            -- FLOOR 1 - LEFT
                            lampVector <= "000110";
    
                        elsif(indexResult > 50 and indexResult < 75) then
                            -- FLOOR 2 - RIGHT
                            lampVector <= "011010";
    
                        elsif(indexResult > 75 and indexResult < 100) then
                            -- FLOOR 2 - LEFT
                            lampVector <= "110010";
                        else
                            -- NO WHERE :)
                            lampVector <= "000000";
                        end if;
                    end if;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
