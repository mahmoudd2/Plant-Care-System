library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY PLANT is
PORT (
	clk: in std_logic;

	start, stop: in std_logic;
  
	LED: out std_logic_vector(1 Downto 0);
  
	water_pump: out std_logic := '1';
  
	motor: out std_logic_vector (1 DOWNTO 0);
	
	SEG1 : out STD_LOGIC_VECTOR(6 downto 0);
	
	SEG2 : out STD_LOGIC_VECTOR(6 downto 0)
	
	);
 	
end PLANT;

ARCHITECTURE arch of PLANT is

Signal LT: INTEGER;
signal stage_counter: integer range 0 to 2 := 0;
signal timer: integer range 0 to 99 := 0 ;
Signal Count: Integer range 0 to 1000000000 := 1;
Signal resetState: Boolean := false;
Signal startState: Boolean := false;
Signal leftDigit: integer range 0 to 9 := 0 ;
Signal rightDigit: integer range 0 to 9 := 0 ;
--constant IDLE: integer := 0;
--constant Stage1_WATERING: integer := 1;
--constant Stage2_FERTILIZING: integer := 2;

begin

  process(clk)
  begin
    if rising_edge(clk) then
		 
		 -- stop state
		 if (stop = '0') then
			resetState <= true;
			water_pump <= '1';
			stage_counter <= 0;
			timer <= 0;
			motor <= "00";
			LED <= "00";
		 end if;
		 
		 -- start state
		 if (start = '0') then
			timer <= 10;
			startState <= true;
			water_pump <= '0';
			stage_counter <= 1;
			motor <= "00";
			LED <= "01";
		 end if;
		 
		 
		 if (Count > 50000000 ) then
		 		 
			Count <= 1;
			case stage_counter is
			  when 0 => --IDLE
				 if startState = true then
					startState <= false;
					stage_counter <= 1; --Stage1_WATERING
				 else
					stage_counter <= 0;
				 end if;
			  when 1 => --Stage1_WATERING
				 if timer = 0 then
					LED <= "10";
					water_pump <= '1';
					--timer <= 10;
					stage_counter <= 2;  --Stage2_FERTILIZING
				 else
					water_pump <= '0';
					timer <= timer - 1;
				 end if;
				 
			  when 2 => --Stage2_FERTILIZING
				 motor <= "10";
				 if resetState = true then
					resetState <= false;
					stage_counter <= 0; --IDLE
					motor <= "00";
				 end if;
			end case;
			else
				Count <= Count +1;
			end if;
		end if;
  end process;
  
  PROCESS(timer)
		BEGIN
			leftDigit <= timer / 10;
			rightDigit <= timer mod 10;

			CASE leftDigit IS
				WHEN 0 => SEG2 <= "1000000";
				WHEN 1 => SEG2 <= "1111001";
				WHEN 2 => SEG2 <= "0100100";
				WHEN 3 => SEG2 <= "0110000";
				WHEN 4 => SEG2 <= "0011001";
				WHEN 5 => SEG2 <= "0010010";
				WHEN 6 => SEG2 <= "0000010";
				WHEN 7 => SEG2 <= "1111000";
				WHEN 8 => SEG2 <= "0000000";
				WHEN 9 => SEG2 <= "0010000";
				WHEN others => SEG2 <= "1111111";
				END CASE;
			

			CASE rightDigit IS

				WHEN 0 => SEG1 <= "1000000";
				WHEN 1 => SEG1 <= "1111001";
				WHEN 2 => SEG1 <= "0100100";
				WHEN 3 => SEG1 <= "0110000";
				WHEN 4 => SEG1 <= "0011001";
				WHEN 5 => SEG1 <= "0010010";
				WHEN 6 => SEG1 <= "0000010";
				WHEN 7 => SEG1 <= "1111000";
				WHEN 8 => SEG1 <= "0000000";
				WHEN 9 => SEG1 <= "0010000";
				WHEN others => SEG1 <= "1111111";
				END CASE;
	END PROCESS;


END arch;