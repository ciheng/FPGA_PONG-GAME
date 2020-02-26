--VGA driver for 1680 x 1050 60Hz monitor
 
library ieee; use ieee.std_logic_1164.all;
 
entity vga_driver is port (
	vga_clk	: in std_logic;
	--Outputs to VGA port
	h_sync 	: out std_logic;
	v_sync 	: out std_logic;
	red	: out std_logic_vector(3 downto 0);
	green	: out std_logic_vector(3 downto 0);
	blue	: out std_logic_vector(3 downto 0);
	
	--Outputs so other modules know where on the screen we are
	new_frame : out std_logic;
	current_h : out integer range 0 to 2256:=0;
	current_v : out integer range 0 to 1087:=0;

	--Inputs from other modules to set display
	red_in	 : in std_logic_vector(3 downto 0);
	green_in  : in std_logic_vector(3 downto 0);
	blue_in	 : in std_logic_vector(3 downto 0)

  
);
 
end entity vga_driver;
 
architecture main of vga_driver is

--Store current position within screen
signal h_pos : integer range 0 to 2256:=0;   --FP+SYNC+BP+Visible = 104 + 184 + 288 + 1680 = 2256
signal v_pos : integer range 0 to 1087:=0;	--FP+SYNC+BP+Visible = 1 + 3 + 33 + 1050 = 1087

 
begin

current_h <= h_pos;
current_v <= v_pos;
 
vga_timing : process(vga_clk)

begin
	if rising_edge(vga_clk) then
		
		--Count up pixel position
		if (h_pos < 2256) then
		
			new_frame <= '0';
			
			h_pos <= h_pos + 1;
		else
			h_pos <= 0;  --Reset position at end of line
			
			--Count up line position
			if (v_pos < 1087) then
				v_pos <= v_pos + 1;
			else 
				v_pos <= 0;  --Reset position at end of frame
				
				new_frame <= '1';
				
			end if;
		end if;
		
		--Generate horizontal sync signal (negative pulse)
		if (h_pos > 103 and h_pos < 288) then
			h_sync <= '0';
		else
			h_sync <= '1';
		end if;
		--Generate vertical sync signal (positive pulse)
		if (v_pos > 0 and v_pos < 4) then
			v_sync <= '1';
		else
			v_sync <= '0';
		end if;
		
		--Blank screen during FP, BP and Sync
		if ( (h_pos >= 0 and h_pos < 576) or (v_pos >= 0 and v_pos < 37) ) then
				red <= (others => '0');
				green <= (others => '0');
				blue <= (others => '0');
				
		--In visible range of screen		
		else
			--Print white screen boarder
			if ( (h_pos >= 576 and h_pos < 586 ) or (v_pos >= 37 and v_pos < 47 ) or (h_pos >= 2246 and h_pos < 2256 ) or (v_pos >= 1077 and v_pos < 1087 ) ) then
					red <= (others => '1');
					green <= (others => '1');
					blue <= (others => '1');
			else
					--Within the boarder other modules can write to the screen
					red <= red_in;
					green <= green_in;
					blue <= blue_in;
			end if;
		
		end if;
	
	end if;
	
end process;
 
end main;
 