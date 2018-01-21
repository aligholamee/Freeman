----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2017 01:30:42 PM
-- Design Name: 
-- Module Name:  - 
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

package Common is
    type PLATE is record
        NUMBER: integer;
        LOCATION: integer;
    end record PLATE;
    
    type USER is record
        ID: integer;
        PASSWORD: integer;
    end record USER;

    type USER_DB is array(3 downto 0) of USER;
    type PLATE_DB is array(99 downto 0) of PLATE;
end Common;
