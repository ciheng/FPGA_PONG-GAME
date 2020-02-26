----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2018/10/01 10:19:13
-- Design Name: 
-- Module Name: VGA_PONG - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_PONG is
    Port ( clock_40 : in STD_LOGIC;
           BUTTON   : in std_logic_vector(3 downto 0);
           SW       : in STD_LOGIC;
           new_fream: in STD_LOGIC;
           current_h: in STD_LOGIC;
           current_v: in STD_LOGIC;
           VGA_HS   : out STD_LOGIC;
           VGA_VS   : out STD_LOGIC;
           VGA_R : out STD_LOGIC_VECTOR (4 downto 0);
           VGA_G : out STD_LOGIC_VECTOR (5 downto 0);
           VGA_B : out STD_LOGIC_VECTOR (4 downto 0)
    );
end entity VGA_PONG;

architecture main of VGA_PONG is

---constants
    constant ball_size:integer:= 10;
    constant paddle_length:integer:=50;
    constant paddle_width:integer:=10;

--declare all the components
component X_Y is port(
    vga_clk : in std_logic;
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
end component X_Y;

--component vga_clk_pll is port(
--    clock_in   : in  std_logic := '0';
--	reset_in   : in  std_logic := '0'; 
--	clock_out  : out std_logic  
--);
--end component vga_clk_pll;

-- VGA_signals
signal reset : std_logic := '0'; 
signal vga_clk   : std_logic := '0';
signal new_frame : std_logic := '0';
signal set_R : std_logic_vector(4 downto 0) := "00000";
signal set_G : std_logic_vector(5 downto 0) := "000000";
signal set_B : std_logic_vector(4 downto 0) := "00000";
signal X : integer range 0 to 1056 := 0;
signal Y : integer range 0 to 628 := 0;
signal X_X : std_logic_vector(11 downto 0) := (others => '0');
signal Y_Y : std_logic_vector(10 downto 0) := (others => '0');

-- paddle signals
signal paddle_L : integer range 5 to 545 := 275;
signal paddle_R : integer range 5 to 545 := 275;

-- ball signals
signal ball_X : integer range 0 to 800 := 380;
signal ball_Y : integer range 0 to 600 := 295;
signal ball_updown : std_logic := '0'; -- 0 = up, 1 = down
signal ball_rightleft : std_logic := '0'; -- 0 = right, 1 = right
-- signal ball_spd_h : std_logic := '0';
-- signal ball_spd_v : std_logic := '0';

-- score signals
signal left_score : integer range 0 to 10:=0;
signal right_score : integer range 0 to 10:=0;

begin
    reset <= SW;
    X_X <= std_logic_vector(to_unsigned(X, X_X'length));
    Y_Y <= std_logic_vector(to_unsigned(Y, Y_Y'length));
    -- pll1 : vga_clk_pll port map (clock_40, SW, vga_clk);
    vga1 : X_Y port map(
        vga_clk => vga_clk,
        reset_n => SW,
        HS => VGA_HS,
        VS => VGA_VS,
        R => VGA_R,
        G => VGA_G,
        B => VGA_B,
        new_frame => new_frame,
        current_h => X_X,
        current_v => Y_Y,
        R_in => set_R,
        G_in => set_G,
        B_in => set_B
     );

-- options
draw_paddles : process(vga_clk)
begin
if(rising_edge(vga_clk)) then
    if((X >= 5 and X < 15) and (Y >= paddle_L and Y < paddle_L + paddle_length)) then
        set_R <= "10101";
    elsif((X >= 585 and X < 595) and (Y >= paddle_R and Y < paddle_R + paddle_length)) then
        set_R <= "11011";
        else
            set_R <= "01111";
    end if;
end if;
end process;

draw_ball : process(vga_clk)
begin
if(rising_edge(vga_clk)) then 
    if((X >= ball_X and X < (ball_X + ball_size)) and (Y >= ball_Y and Y < (ball_Y + ball_size))) then
        set_R <= "11011";
    else
        set_R <="01111";
    end if;
end if;
end process;

move_paddles : process(vga_clk)
begin
if(rising_edge(vga_clk) and new_frame = '1') then
    -- left paddle button(0) up, button(1) down
    if(BUTTON(0) = '1') then
        if(paddle_L > 0) then 
            paddle_L <= paddle_L - 1;
        else 
            paddle_L <= paddle_L;
        end if;
    elsif(BUTTON(1) = '1') then
        if(paddle_L < 545) then
            paddle_L <= paddle_L + 1;
        else 
            paddle_L <= paddle_L;
        end if;
    end if;
    
    -- right paddle button(2) up, button(3)down
    if(BUTTON(2) = '1') then
        if(paddle_R > 0) then 
            paddle_R <= paddle_R - 1;
        else 
            paddle_R <= paddle_R;
        end if;
    elsif(BUTTON(3) = '1') then
        if(paddle_R < 545) then
            paddle_R <= paddle_R + 1;
        else 
            paddle_R <= paddle_R;
        end if;
    end if;
end if;
end process;

move_ball : process(vga_clk)
begin
if(rising_edge(vga_clk) and new_frame = '1') then
    if(reset = '1') then
        ball_X <= 380;
        ball_Y <= 295;
    else
        -- ball travels up but not at top
        if(ball_Y > 0 and ball_updown = '0') then
            ball_Y <= ball_Y - 1;
        -- when the ball reaches top
        elsif(ball_updown = '0') then 
            ball_updown <= '1';
        -- ball travels down but not at bottom
        elsif(ball_Y < 585 and ball_updown = '1') then
            ball_Y <= ball_Y + 1;
        -- when the ball reaches bottom
        elsif(ball_updown = '1') then
            ball_updown <= '0';
        end if;
        
        if(ball_rightleft = '0') then
            ball_X <= ball_X + 1;
        elsif(ball_rightleft = '1')then
            ball_X <= ball_X - 1;
        end if;
            
        if(((ball_X + ball_size) >= (800 - paddle_width) and (ball_Y >= paddle_R and ball_Y < (paddle_R + paddle_length))) ----when bounce the 2 paddles
                        or ((ball_X <= paddle_width)and (ball_Y >= paddle_L and ball_Y < (paddle_R + paddle_length)))) then
            ball_rightleft <= NOT ball_rightleft;
        elsif(ball_X = 0 ) then
            ball_X <= 400;
            ball_X <= 300;
            right_score <= right_score + 1;
        elsif(ball_X = 800 ) then
            ball_X <= 400;
            ball_Y <= 300;
            left_score <= left_score + 1;
        elsif(ball_Y = 0 or ball_Y = 600) then
            ball_updown <= NOT ball_updown;
        end if;
    end if;
end if;
end process;

end main;
