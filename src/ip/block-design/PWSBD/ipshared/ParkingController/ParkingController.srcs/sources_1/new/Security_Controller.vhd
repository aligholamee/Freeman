----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2018 08:13:50 AM
-- Design Name: 
-- Module Name: SecurityController - RTL
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SecurityController is
    port(
        window_sense_p: in std_logic;
        door_sense_p: in std_logic;
        command_p: in std_logic_vector(31 downto 0);
        alarm_enable_p: out std_logic;
        key_sense: in std_logic;
        clk_p: in std_logic;
        rst_p: in std_logic
    );
end SecurityController;

architecture RTL of SecurityController is
    
    -- TYPE DECLARATION
    type STATE_TYPE is (RECOVERY, SS_OFF, SS_ON, PARTIAL_ALARM, CONSISTENT_ALARM, SS_SHARP, USER_SHARP, USER_STAR1, USER_STAR2);
                         
    -- STATE SIGNAL
    signal STATE: STATE_TYPE := SS_OFF;
    
    -- IMPLEMENTS THE SAFE FSM CREDINTIALS
    attribute safe_recovery_state: string;
    attribute safe_recovery_state of STATE: signal is "RECOVERY";
    
    -- USER DATABASE
    -- CONSISTS OF TWO INTEGERS FOR EACH USER RECORD
    -- ONE FOR ITS ID
    -- THE OTHER ONE FOR ITS PASSWORD
    -- CAR DATABASE
    -- CONSTANT FOR THE INITIAL VALUE OF THE DATABASE CELLS
    constant const_init: USER := (ID => 0, PASSWORD => 0);
    signal USER_DATA: USER_DB := (others => const_init);


    -- SOME UTILITY SIGNALS
    signal USER_NAME_LIMIT: integer := 0;
    signal PASSWORD1_LIMIT: integer := 0;
    signal PASSWORD2_LIMIT: integer := 0;

    -- USER ID | PASSWORD CONTAINERS
    signal USERID_CON: integer := 0;
    signal PASSWORD_CON1: integer := 0;
    signal PASSWORD_CON2: integer := 0;

    -- USER DOOR INPUT HANDLER
    signal USER_DOOR_INPUT: integer := 0;
    signal WRONG_PASS_COUNTER: integer := 0;
    signal USER_EXIST: std_logic := '0';
    signal DOOR_PASS_DIGIT_LIMIT: integer := 0;
    signal trys_left: integer := 0;
    signal NEW_USER: std_logic := '1';

    -- CLOCKING AND ALARM COUNTERS
    signal THIRTY_SECOND_COUNTER: integer := 0;
    signal FIVE_SECOND_COUNTER: integer := 0;
    signal TEN_SECOND_COUNTER: integer := 0;
    
    -- CLOCKING AND ALARM COUNTERS RESETS
    signal THIRTY_SEC_RESET: std_logic := '1';
    signal TEN_SEC_RESET: std_logic := '1';
    signal FIVE_SEC_RESET: std_logic := '1';
    signal resetCounters: std_logic := '1';
    signal forceResetCounters: std_logic := '1';
    

    
begin

    USR_FSM: process(command_p(0), THIRTY_SEC_RESET, TEN_SEC_RESET, FIVE_SEC_RESET, door_sense_p, window_sense_p)
    begin
        if(rst_p = '0') then
            STATE <= SS_OFF;
        else
            case STATE is 
                when SS_OFF => 
                    -- SET NEW LIMITS TO ZERO
                    USER_NAME_LIMIT <= 0;
                    PASSWORD1_LIMIT <= 0;
                    PASSWORD2_LIMIT <= 0;
                    alarm_enable_p <= '0';
                    USERID_CON <= 0;
                    PASSWORD_CON1 <= 0;
                    PASSWORD_CON2 <= 0;
                    -- Check if anything happens :D
                    if(command_p(9 downto 1) = "000100000") then
                        -- # ASCII: 32 => 00100000
                        STATE <= USER_SHARP;
                    else    
                        STATE <= STATE;
                    end if;
                
                when USER_SHARP =>
                    if(command_p(9 downto 1) = "000101010") then
                        -- * ASCII: 42 => 00101010
                        STATE <= USER_STAR1;
                    else  
                        if(not(USER_NAME_LIMIT = 1)) then
                            USERID_CON <= to_integer(unsigned(command_p(9 downto 1)));
                            USER_NAME_LIMIT <= USER_NAME_LIMIT + 1;
                        else
                            USERID_CON <= USERID_CON;
                        end if;
                        STATE <= STATE;
                    end if;
                
                when USER_STAR1 =>
                    if(command_p(9 downto 1) = "000101010") then
                        -- * ASCII: 42 => 00101010
                        STATE <= USER_STAR2;

                    elsif(command_p(9 downto 1) = "000100000") then 
                        -- # ASCII: 32 => 00100000
                        -- CHECK IF THE PASSWORD CONTAINER 1 CONTAINS 1 OR NOT
                        if(PASSWORD_CON1 = 1) then 
                            -- TURN THE SYSTEM ON
                            STATE <= SS_ON;
                        end if;
                    else
                        -- Either the password or
                        -- the single 1 input will be grabbed here
                        -- PUT EVERYTHING INSIDE THE PASSWORD1 CONTAINER 
                        -- THE RESULT WILL BE GOING THROGUH THE CONDITIONS TO CHECK THE CONDITIONS ABOVE
                        if(not(PASSWORD1_LIMIT = 4)) then
                            PASSWORD_CON1 <= PASSWORD_CON1 * 10 + to_integer(unsigned(command_p(9 downto 1)));
                            PASSWORD1_LIMIT <= PASSWORD1_LIMIT + 1;
                        else    
                            PASSWORD_CON1 <= PASSWORD_CON1;
                        end if;
                    end if;
                
                when USER_STAR2 =>
                    if(command_p(9 downto 1) = "000100000") then
                        -- # ASCII: 32 => 00100000
                        -- GET BACK TO THE SS_OFF STATE
                        -- ADD THE USER ID AND PASSWORD TO THE DATABASE
                        -- CHECK IF THE PASS1 CONTAINER EXISTS
                        for i in 0 to 3 loop
                            if(USER_DATA(i).PASSWORD = PASSWORD_CON1) then
                                -- UPDATE THE PASSWORD (PREV -> NEW)
                                USER_DATA(i).PASSWORD <= PASSWORD_CON2;
                                NEW_USER <= '0';
                            end if;
                        end loop;

                        if(NEW_USER = '1') then
                            -- ADMIN CHECK
                            if(PASSWORD_CON1 = 1234) then
                                for i in 0 to 3 loop
                                    -- FREE PLACE CHECK
                                    if(USER_DATA(i).PASSWORD = 0) then 
                                        -- ADD NEW USER
                                        USER_DATA(i).ID <= USERID_CON;
                                        USER_DATA(i).PASSWORD <= PASSWORD_CON2;
                                        exit;
                                    end if; 
                                end loop;
                            end if;
                        end if;
                        STATE <= SS_OFF;
                    else    
                        if(not(PASSWORD2_LIMIT = 4)) then
                            PASSWORD_CON2 <= PASSWORD_CON2 * 10 + to_integer(unsigned(command_p(9 downto 1)));
                            PASSWORD2_LIMIT <= PASSWORD2_LIMIT + 1;
                        else    
                            PASSWORD_CON2 <= PASSWORD_CON2;
                        end if;
                    end if;
                
                when SS_ON => 
                    trys_left <= 0;
                    DOOR_PASS_DIGIT_LIMIT <= 0;
                    if(door_sense_p = '1') then
                        STATE <= PARTIAL_ALARM;
                        resetCounters <= '0';
                    elsif(window_sense_p = '1') then
                        STATE <= CONSISTENT_ALARM;
                    else
                        STATE <= STATE;
                    end if;
                
                when PARTIAL_ALARM =>
                    -- IF THE FLAG FOR THE TRANSITION TO THE CONSISTENT ALARM MODE IS SET 
                    -- CHANGE THE STATE
                    if(THIRTY_SEC_RESET = '0') then
                        STATE <= CONSISTENT_ALARM;
                        resetCounters <= '0';
                    else
                        if(FIVE_SEC_RESET = '0') then
                            -- ENABLE THE ALARM FOR A MOMENT
                            alarm_enable_p <= '1';
                            -- TURN OF THE ALARM AFTER THAT MOMENT!
                            alarm_enable_p <= '0';
                            resetCounters <= '0';
                        elsif(command_p(9 downto 1) = "000100000") then
                            -- # ASCII: 32 => 00100000
                            STATE <= SS_SHARP;
                        else
                            STATE <= STATE;
                        end if;
                    end if;

                when SS_SHARP =>
                        if(FIVE_SEC_RESET = '0') then
                            -- ENABLE THE ALARM FOR A MOMENT 
                            alarm_enable_p <= '1';
                            -- TURN OFF THE ALARM AFTER THAT MOMENT!
                            alarm_enable_p <= '0';
                            resetCounters <= '0';
                        elsif(command_p(9 downto 1) = "000100000") then
                            for i in 0 to 3 loop
                                if(USER_DATA(i).PASSWORD = USER_DOOR_INPUT) then 
                                    USER_EXIST <= '1';
                                end if;
                            end loop;

                            if(USER_EXIST = '1') then
                                STATE <= SS_ON;
                                USER_EXIST <= '0';
                            else
                                USER_EXIST <= '0';
                                if(trys_left < 3) then
                                    STATE <= PARTIAL_ALARM;
                                        trys_left <= trys_left + 1;
                                else
                                    STATE <= CONSISTENT_ALARM;
                                end if;
                            end if;
                        elsif(not(DOOR_PASS_DIGIT_LIMIT = 4)) then
                            USER_DOOR_INPUT <= USER_DOOR_INPUT * 10 + to_integer(unsigned(command_p(9 downto 1)));
                            DOOR_PASS_DIGIT_LIMIT <= DOOR_PASS_DIGIT_LIMIT + 1;
                            -- RESET THE TEN_SECOND_COUNTER
                            STATE <= STATE;
                        else    
                            STATE <= SS_SHARP;
                        end if;

                when CONSISTENT_ALARM =>
                    alarm_enable_p <= '1';
                
                when RECOVERY => 
                    alarm_enable_p <= '1';  -- :D
                end case;
            end if;
            resetCounters <= '1';
        end process;
    
    CLOCK_INC: process(clk_p, resetCounters) 
    begin
        if(rising_edge(clk_p)) then
            if(forceResetCounters = '0') then 
                THIRTY_SECOND_COUNTER <= 0;
                TEN_SECOND_COUNTER <= 0;
                FIVE_SECOND_COUNTER <= 0;
            elsif(resetCounters = '0') then
                if(THIRTY_SEC_RESET = '0') then
                    THIRTY_SECOND_COUNTER <= 0;
                    THIRTY_SEC_RESET <= '1';
                end if;
                if(TEN_SEC_RESET = '0') then
                    TEN_SECOND_COUNTER <= 0;
                    TEN_SEC_RESET <= '1';
                end if;
                if(FIVE_SEC_RESET = '0') then       
                    FIVE_SECOND_COUNTER <= 0;
                    FIVE_SEC_RESET <= '1';
                end if;
            else
                -- CHECK IF THRESHOLDS ARE REACHED
                if(THIRTY_SECOND_COUNTER > 30) then
                    -- SET THE FLAG FOR THE CONSISTENT ALARM
                    THIRTY_SEC_RESET <= '0';
                else    
                    if(FIVE_SECOND_COUNTER > 5) then 
                        -- SET THE FLAG FOR THE DING ALARM
                        FIVE_SEC_RESET <= '0';
                    else
                        FIVE_SECOND_COUNTER <= FIVE_SECOND_COUNTER + 1;
                    end if;
                    THIRTY_SECOND_COUNTER <= THIRTY_SECOND_COUNTER + 1;
                end if;

                if(TEN_SECOND_COUNTER > 10) then 
                    TEN_SEC_RESET <= '0';
                else
                    TEN_SECOND_COUNTER <= TEN_SECOND_COUNTER + 1;
                end if;
            end if;
        end if;
    end process;
end RTL;
