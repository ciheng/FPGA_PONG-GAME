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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_controller is PORT(
    vga_clk	: in std_logic;
    reset_n : in std_logic;
	--Outputs to VGA port
	HS 	: out std_logic; --horiztonal sync pulse
	VS 	: out std_logic; --vertical sync pulse
	R	: out std_logic_vector(4 downto 0);
	G	: out std_logic_vector(5 downto 0);
	B	: out std_logic_vector(4 downto 0);

	--Inputs from other modules to set display
	PADDLE_L_Y : in std_logic_vector(9 downto 0);
    PADDLE_R_Y : in std_logic_vector(9 downto 0);
    BALL_X : in std_logic_vector(10 downto 0);
    BALL_Y : in std_logic_vector(9 downto 0);
    SCORE_L:in std_logic_vector(3 downto 0);
    SCORE_R:in std_logic_vector(3 downto 0)
	);

end entity VGA_controller;

architecture Behavioral of VGA_controller is

constant ball_size:integer:= 20;
constant paddle_width:integer:=20;
constant paddle_length:integer:=80;
--store current postion
signal X : integer range 0 to 1056:=0;   -- sync + active + BP + FP = 128 + 800 + 88 + 40 = 1056
signal Y : integer range 0 to 628:=0;	-- sync + active + BP + FP = 4 + 600 + 23 + 1 = 628

begin


vga_timing:	process(vga_clk)
begin
        
		if rising_edge(vga_clk) then
            --the whole scan procedure
                if(X < 1056) then
                   
                    X <= X + 1;
                else
                    X <= 0;
                    if(Y < 628) then 
                        Y <= Y + 1;
                    else
                        Y <= 0;
                      
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
                ----start to draw the screen
                --the "invisible" part of the screen (during FP sync and BP)
                if( (X >= 800 and X < 1056) or (Y >= 600 and Y < 628) ) then
                    R <= "00000";
                    G <= "000000";
                    B <= "00000";
                --within the actual screen 
                else
                    --print the boarder of the PONG game desk
                    if( (X >= 0 and X < 10 ) or (X >= 790 and X < 800) or (Y >= 0 and Y < 10) or (Y >= 590 and Y < 600) or (X>=395 and X<=405)) then
                        R <= "11111";
                        G <= "111111";
                        B <= "11111";
                        
                 else 
                 -----seven segment part
                        if((X>=328 and X<368 and Y>=40 and Y< 120) or (X> 432 and X<472 and Y>=40 and Y<120)) then
                       case CONV_INTEGER(SCORE_L) is
                             when 0 =>
                                if((X >= 328 and X < 338 ) or (X >= 358 and X < 368) or (Y >= 40 and Y < 50) or (Y >= 110 and Y < 120)) then
                                  R <= "11111";
                                  G <= "111111";
                                  B <= "11111";
                                
                                end if;
                             when 1 =>
                                if((X >= 358 and X < 368) and (Y >= 40 and Y < 120)) then
                                    R <= "11111";
                                    G <= "111111";
                                    B <= "11111";
                                 end if;
                             when 2 =>
                                if(((X >= 328 and X < 368) and ((Y >= 40 and Y < 50) or (Y >= 75 and Y < 85) or (Y >= 110 and Y < 120))) and ((Y >= 80 and Y < 120) and (X >= 328 and X < 338 )) and ((Y >= 40 and Y < 80) and (X >= 358 and X < 368))) then
                                    R <= "11111";
                                    G <= "111111";
                                    B <= "11111";
                                end if;
                             when 3 =>
                                if(((X >= 328 and X < 368) and ((Y >= 40 and Y < 50) or (Y >= 75 and Y < 85) or (Y >= 110 and Y < 120))) and ((Y >= 40 and Y < 120) and (X >= 358 and X < 368)) ) then 
                                    R <= "11111";
                                    G <= "111111";
                                    B <= "11111";
                                end if;
                             when 4 =>
                                if(((X >= 358 and X < 368) and (Y >= 40 and Y < 120)) and ((X >= 328 and X < 368) and (Y >= 40 and Y < 80)) and ((X >= 328 and X < 368) and (Y >= 75 and Y < 85))) then
                                         R <= "11111";
                                         G <= "111111";
                                         B <= "11111";
                                end if;
                             when 5 =>
                                if(((X >= 328 and X < 368) and ((Y >= 40 and Y < 50) or (Y >= 75 and Y < 85) or (Y >= 110 and Y < 120)) and ((Y >= 40 and Y < 80) and (X >= 328 and X < 338 )) and ((Y >= 80 and Y < 120) and (X >= 358 and X < 368))) ) then
                                    R <= "11111";
                                    G <= "111111";
                                    B <= "11111";
                                end if;
                             when 6 =>
                                if(((X >= 328 and X < 368) and ((Y >= 40 and Y < 50) or (Y >= 75 and Y < 85) or (Y >= 110 and Y < 120)) and ((Y >= 40 and Y < 120) and (X >= 328 and X < 338 )) and ((Y >= 80 and Y < 120) and (X >= 358 and X < 368))) ) then
                                    R <= "11111";
                                    G <= "111111";
                                    B <= "11111";
                                end if;
                             when 7 =>
                                if((X >= 358 and X < 368) and (Y >= 40 and Y < 120) and ((X >= 328 and X < 368) and (Y >= 10 and Y < 20))) then
                                    R <= "11111";
                                    G <= "111111";
                                    B <= "11111";
                                end if;
                             when 8 =>
                                if(((X >= 328 and X < 338 ) or (X >= 358 and X < 368) or (Y >= 40 and Y < 50) or (Y >= 110 and Y < 120)) and ((X >= 328 and X < 368) and (Y >= 75 and Y < 85)))then
                                    R <= "11111";
                                    G <= "111111";
                                    B <= "11111";
                                end if;
                             when 9 =>
                                if(((X >= 328 and X < 368) and ((Y >= 40 and Y < 50) or (Y >= 75 and Y < 85) or (Y >= 110 and Y < 120)) and ((Y >= 40 and Y < 120) and (X >= 358 and X < 368 )) and ((Y >= 40 and Y < 80) and (X >= 328 and X < 338))) ) then
                                    R <= "11111";
                                    G <= "111111";
                                    B <= "11111";
                                end if;
                             when others =>
                                     R <= "00000";
                                       G<="111111";
                                       B<="00000";
                            end case;
                        case CONV_INTEGER(SCORE_R) is
                                         when 0 =>
                                            if((X >= 432 and X < 442 ) or (X >= 362 and X < 372) or (Y >= 40 and Y < 50) or (Y >= 110 and Y < 120)) then
                                              R <= "11111";
                                              G <= "111111";
                                              B <= "11111";
                                            end if;
                                         when 1 =>
                                            if((X >= 462 and X < 472) and (Y >= 40 and Y < 120)) then
                                                R <= "11111";
                                                G <= "111111";
                                                B <= "11111";
                                             end if;
                                         when 2 =>
                                            if(((X >= 432 and X < 472) and ((Y >= 40 and Y < 50) or (Y >= 75 and Y < 85) or (Y >= 110 and Y < 120)) and ((Y >= 80 and Y < 120) and (X >= 432 and X < 442 )) and ((Y >= 40 and Y < 80) and (X >= 462 and X < 472))) ) then
                                                R <= "11111";
                                                G <= "111111";
                                                B <= "11111";
                                            end if;
                                         when 3 =>
                                            if(((X >= 432 and X < 472) and ((Y >= 40 and Y < 50) or (Y >= 75 and Y < 85) or (Y >= 110 and Y < 120))) and ((Y >= 40 and Y < 120) and (X >= 462 and X < 472)) ) then 
                                                R <= "11111";
                                                G <= "111111";
                                                B <= "11111";
                                            end if;
                                         when 4 =>
                                            if(((X >= 462 and X < 472) and (Y >= 40 and Y < 120)) and ((X >= 432 and X < 472) and (Y >= 40 and Y < 80)) and ((X >= 432 and X < 472) and (Y >= 75 and Y < 85))) then
                                                     R <= "11111";
                                                     G <= "111111";
                                                     B <= "11111";
                                            end if;
                                         when 5 =>
                                            if(((X >= 432 and X < 472) and ((Y >= 40 and Y < 50) or (Y >= 75 and Y < 85) or (Y >= 110 and Y < 120)) and ((Y >= 40 and Y < 80) and (X >= 432 and X < 442 )) and ((Y >= 80 and Y < 120) and (X >= 462 and X < 472))) ) then
                                                R <= "11111";
                                                G <= "111111";
                                                B <= "11111";
                                            end if;
                                         when 6 =>
                                            if(((X >= 432 and X < 472) and ((Y >= 40 and Y < 50) or (Y >= 75 and Y < 85) or (Y >= 110 and Y < 120)) and ((Y >= 40 and Y < 120) and (X >= 432 and X < 442 )) and ((Y >= 80 and Y < 120) and (X >= 462 and X < 472))) ) then
                                                R <= "11111";
                                                G <= "111111";
                                                B <= "11111";
                                            end if;
                                         when 7 =>
                                            if((X >= 462 and X < 472) and (Y >= 40 and Y < 120) and ((X >= 432 and X < 472) and (Y >= 10 and Y < 20))) then
                                                R <= "11111";
                                                G <= "111111";
                                                B <= "11111";
                                            end if;
                                         when 8 =>
                                            if(((X >= 432 and X < 442 ) or (X >= 462 and X < 472) or (Y >= 40 and Y < 50) or (Y >= 110 and Y < 120)) and ((X >= 432 and X < 472) and (Y >= 75 and Y < 85)))then
                                                R <= "11111";
                                                G <= "111111";
                                                B <= "11111";
                                            end if;
                                         when 9 =>
                                            if(((X >= 432 and X < 472) and ((Y >= 40 and Y < 50) or (Y >= 75 and Y < 85) or (Y >= 110 and Y < 120)) and ((Y >= 40 and Y < 120) and (X >= 462 and X < 472 )) and ((Y >= 40 and Y < 80) and (X >= 432 and X < 442))) ) then
                                                R <= "11111";
                                                G <= "111111";
                                                B <= "11111";
                                            end if;
                                         when others =>
                                                R <= "00000";
                                                G<="111111";
                                                B<="00000";
                                        end case;
                                        
                       
                    else 
                    -------paddles and ball
                        if((X >= 10 and X < (10+paddle_width)) and (Y >= CONV_INTEGER(PADDLE_L_Y) and Y <(  CONV_INTEGER(PADDLE_L_Y) + paddle_length))) then
                           R <= "11111";
                           G<="111111";
                           B<="11111";
                           
                       elsif((X >= (590-paddle_width) and X < 590) and (Y >=  CONV_INTEGER(PADDLE_R_Y) and Y < CONV_INTEGER( PADDLE_R_Y) + paddle_length)) then
                           R <= "11111";
                           G<="111111";
                           B<="11111";
                   
--                       elsif((X >=  CONV_INTEGER(BALL_X) and X < ( CONV_INTEGER(BALL_X) + ball_size)) and (Y >=  CONV_INTEGER(BALL_Y) and Y < ( CONV_INTEGER(BALL_Y) + ball_size))) then
                         elsif(((X- CONV_INTEGER(BALL_X)-10)*(X- CONV_INTEGER(BALL_X)-10)+(Y- CONV_INTEGER(BALL_Y)-10)*(Y- CONV_INTEGER(BALL_Y)-10))<100) then
                                 R <= "11111";
                                 G<="111111";
                                 B<="11111";
                           else
                               R <= "00000";
                               G<="111111";
                               B<="00000";
                       
                        end if;
                    end if;
                end if;
            end if;
            end if;
          
end process;

end Behavioral;

