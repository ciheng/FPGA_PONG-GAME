--Displays a single digit base 10 number on a seven segment display
library ieee; use ieee.std_logic_1164.all;
 
entity seven_seg_display is port (
	input   : in integer range 0 to 9;
	seg_out : out std_logic_vector(6 downto 0)
  
);
 
end entity seven_seg_display;
 
architecture main of seven_seg_display is

begin

display_output : process(input)
begin
	--LEDs are inverted so 1 = off 0 = on
	case input is
	 when 0 =>
		seg_out <= B"1000000";
	 when 1 =>
		seg_out <= B"1111001";
	 when 2 =>
		seg_out <= B"0100100";
	 when 3 =>
		seg_out <= B"0110000";
	 when 4 =>
		seg_out <= B"0011001";
	 when 5 =>
		seg_out <= B"0010010";
	 when 6 =>
		seg_out <= B"0000010";
	 when 7 =>
		seg_out <= B"1111000";
	 when 8 =>
		seg_out <= B"0000000";
	 when 9 =>
		seg_out <= B"0010000";
	 when others =>
		seg_out <= B"0000000"; 
	end case; 
	
end process;

end main;