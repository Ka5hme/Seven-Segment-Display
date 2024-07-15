----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Likashmi 
-- 
-- Create Date: 04/06/2024 11:59:41 PM
-- Design Name: 
-- Module Name: counter - Behavioral
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
use IEEE.std_logic_unsigned.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
    Port ( clk : in STD_LOGIC;
            -- 100 MHz clk
           reset : in STD_LOGIC;
           --reset
           an : out STD_LOGIC_VECTOR (7 downto 0);
           --anode choose which display
           seg : out STD_LOGIC_VECTOR (6 downto 0);
           --cathode
           en : in STD_LOGIC_VECTOR(63 downto 0);
           
           data : in STD_LOGIC_VECTOR(31 downto 0));
end SSD;

architecture Behavioral of SSD is
    signal seven_seg : STD_LOGIC_VECTOR (3 downto 0);
    
    signal refresh_counter: STD_LOGIC_VECTOR (19 downto 0);
    --10 ms
  
    signal led_counter : STD_LOGIC_VECTOR (2 downto 0);
    --when anodes change
    
    --signal decimal : STD_LOGIC_VECTOR (31 downto 0);
    --output to 7seg
    
        begin
            process(seven_seg)
                begin
                    case seven_seg is
                        when "0000" => 
                            seg <= "1000000";      -- 0 
                        when "0001" => 
                            seg <= "1111001";     -- 1
                        when "0010" => 
                            seg <= "0100100";     -- 2 
                        when "0011" => 
                            seg <= "0110000";     -- 3 
                        when "0100" => 
                            seg <= "0011001";     -- 4 
                        when "0101" => 
                            seg <= "0010010";     -- 5     
                        when "0110" => 
                            seg <= "0000010";     -- 6 
                        when "0111" => 
                            seg <= "1111000";     -- 7 
                        when "1000" =>
                             seg <= "0000000";     --8 
                        when "1001" => 
                             seg <= "0010000";     -- 9 
                        when "1010" => 
                            seg <= "0100000";     -- a 
                        when "1011" => 
                            seg <= "0000011";     -- b 
                        when "1100" => 
                            seg <= "1000110";     -- c 
                        when "1101" => 
                            seg <= "0100001";     -- d 
                        when "1110" => 
                            seg <= "0000110";     -- e
                        when "1111" => 
                            seg <= "0001110";     -- f
                        when others =>            
                            seg <= "1111111";     -- null
                    end case;
            end process;
            
            process(clk, reset, en)
                begin
                    if(reset='0') then
                    -- reset unclicked is 1 
                        refresh_counter <= (others => '0');
                    elsif(rising_edge(clk) and en = '1' ) then
                        refresh_counter <= refresh_counter +1;
                    end if;
            end process;        
            
            led_counter <= refresh_counter(19 downto 17);
            --updates evey 80 ns
            -- 2^3 * 10ns(period)
            
            process(led_counter)
                begin

                    case led_counter is
                        when "0000" =>
                            an <= "11111110"; 
                            seven_seg <= data(3 downto 0);
                                      
                        when "0001" => 
                            an <= "11111101";
                            seven_seg <= data(7 downto 4);
                            
                        when "0010" =>
                            an <= "11111011";
                            seven_seg <= data(11 downto 8);
                            
                        when "0011" =>
                           an <= "11110111";
                           seven_seg <= data(15 downto 12);
                        
                        when "0100" =>
                           an <= "11101111";
                           seven_seg <= data(19 downto 16);   
                           
                        when "0101" => 
                           an <= "11011111";
                           seven_seg <= data(23 downto 20);
                                    
                        when "0110" =>
                           an <= "10111111";
                           seven_seg <= data(27 downto 24);
                                                       
                        when "0111" =>
                           an <= "01111111";
                           seven_seg <= data(31 downto 28);
                           
                        when others => 
                            an <= "00000000";
                            seven_seg <= "00000000";
                    end case;
            end process;
          

                   --decimal <= "00000001001000111010100110111111";
                    --random test number

end Behavioral;
