----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2018/09/28 13:36:24
-- Design Name: 
-- Module Name: X_Y - Behavioral
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
-- This block generates the essential horizontal and vertical sync signal that are needed by the VGA.
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity X_Y is PORT(
    vga_clk	: in std_logic;
    reset_n : in std_logic;
	--Outputs to VGA port
	HS 	: out std_logic; --horiztonal sync pulse
	VS 	: out std_logic; --vertical sync pulse
	R	: out std_logic_vector(4 downto 0);
	G	: out std_logic_vector(5 downto 0);
	B	: out std_logic_vector(4 downto 0);
	
	--Outputs to other modules know where on the screen we are
	new_frame : out std_logic;
	current_h : out std_logic_vector(11 downto 0); --sync + active + BP + FP = total number of pixel clocks in a row
	current_v : out std_logic_vector(10 downto 0); --sync + active + BP + FP = total number of pixel clocks in a colomn

	--Inputs from other modules to set display
	R_in	 : in std_logic_vector(4 downto 0);
	G_in     : in std_logic_vector(5 downto 0);
	B_in	 : in std_logic_vector(4 downto 0)
	);

end entity X_Y;

architecture Behavioral of X_Y is
--store current postion
signal X : integer range 0 to 1056:=0;   -- sync + active + BP + FP = 128 + 800 + 88 + 40 = 1056
signal Y : integer range 0 to 628:=0;	-- sync + active + BP + FP = 4 + 600 + 23 + 1 = 628

begin

current_h <= std_logic_vector(to_unsigned(X, current_h'length));
current_v <= std_logic_vector(to_unsigned(Y, current_v'length));

vga_timing:	process(vga_clk, reset_n)
begin
        if(reset_n = '0') then		--reset asserted
			X <= 0;				--reset horizontal counter
			Y <= 0;				--reset vertical counter
			HS <= '0';		--deassert horizontal sync
			VS <= '0';		--deassert vertical sync

		elsif rising_edge(vga_clk) then
            --the whole scan procedure
                if(X < 1056) then
                    new_frame <= '0';
                    X <= X + 1;
                else
                    X <= 0;
                    if(Y < 628) then 
                        Y <= Y + 1;
                    else
                        Y <= 0;
                        new_frame <= '1';
                    end if;
                end if;
             
                --generate horizontal sync
                if(X >= 840 and X < 968) then
                    HS <= '1'; --sync signal active high
                else 
                    HS <= '0';
                end if;
            
                --generate vertical sync
                if(Y >= 601 and Y < 605) then 
                    VS <= '1';
                else
                    VS <= '0';
                end if;
                
                --the "invisible" part of the screen (during FP sync and BP)
                if( (X >= 800 and X < 1056) or (Y >= 600 and Y < 628) ) then
                    R <= "00000";
                    G <= "000000";
                    B <= "00000";
                --within the actual screen 
                else
                    --print the boarder of the PONG game desk
                    if( (X >= 0 and X < 5 ) or (X >= 795 and X < 800) or (Y >= 0 and Y < 5) or (Y >= 595 and Y < 600)) then
                        R <= "11111";
                        G <= "111111";
                        B <= "11111";
                    else 
                        R <= R_in;
                        G <= G_in;
                        B <= B_in;
                    end if;
                end if;
            end if;
          
end process;

end Behavioral;
