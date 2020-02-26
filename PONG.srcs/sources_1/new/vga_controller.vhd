----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2018/10/01 10:40:50
-- Design Name: 
-- Module Name: VGA_controller - Behavioral
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

entity vga_controller is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           paddle1_up: in STD_LOGIC;
           paddle1_down: in STD_LOGIC;
           paddle2_up: in STD_LOGIC;
           paddle2_down: in STD_LOGIC;
           R : out STD_LOGIC_VECTOR (4 downto 0);
           G : out STD_LOGIC_VECTOR (5 downto 0);
           B : out STD_LOGIC_VECTOR (4 downto 0);
           h_sync : in STD_LOGIC;
           v_sync : in STD_LOGIC);
end vga_controller;

architecture Behavioral of VGA_controller is
  ---constants
    constant ball_size:integer:= 10;
    constant paddle_length:integer:=50;
    constant paddle_width:integer:=10;
    
   --declare all the components
   component vga_controller is port(
              clk : in STD_LOGIC;
              reset : in STD_LOGIC;
              paddle1_up: in STD_LOGIC;
              paddle1_down: in STD_LOGIC;
              paddle2_up: in STD_LOGIC;
              paddle2_down: in STD_LOGIC;
              R : out STD_LOGIC_VECTOR (4 downto 0);
              G : out STD_LOGIC_VECTOR (5 downto 0);
              B : out STD_LOGIC_VECTOR (4 downto 0);
              h_sync : in STD_LOGIC;
              v_sync : in STD_LOGIC
   );
   end component vga_controller;

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

    ----initial values 
  signal vga_clk : std_logic:='0';
  signal h_pos: integer range 0 to 800:=0;
  signal v_pos: integer range 0 to 600:=0;
  signal R_out: std_logic_vector (4 downto 0):= (others => '0');
  signal G_out: std_logic_vector (5 downto 0):= (others => '0');
  signal B_out: std_logic_vector (4 downto 0):= (others => '0');
  signal ball_pos_x: integer range 0 to 800 := 400;
  signal ball_pos_y: integer range 0 to 600 := 300;
  signal paddle_pos_1: integer range 5 to 545 := 275;
  signal paddle_pos_2: integer range 5 to 545 := 275;
  signal left_score : integer range 0 to 10:=0;
  signal right_score : integer range 0 to 10:=0;
  signal ball_updown: std_logic:='0';  ---0 goes up,1 goes down
  signal ball_leftright: std_logic:='0';---0 goes right,1 goes left
  signal new_frame : std_logic:='0';
  signal set_red, set_green, set_blue : std_logic_vector(3 downto 0):= (others => '0');
  signal X : integer range 0 to 1056:=0;   -- sync + active + BP + FP = 128 + 800 + 88 + 40 = 1056
  signal Y : integer range 0 to 628:=0;    -- sync + active + BP + FP = 4 + 600 + 23 + 1 = 628
  
begin
    X <= to_integer(current_h);
    u1: VGA_controller port map(clk,reset,paddle1_up,paddle1_down,paddle2_up,paddle2_down,R,G,B,h_sync,v_sync );
    u2 : X_Y port map(
        vga_clk => vga_clk,
        reset_n => reset,
        R => R,
        G => G,
        B => B,
        new_frame => new_frame,
        current_h => h_pos,
        current_v => v_pos,
        
    );
----options
    draw_paddles:process(paddle_pos_1,paddle_pos_2)
    begin
       if ((h_pos>=5 and h_pos <paddle_width) and (v_pos>= paddle_pos_1 and v_pos<(paddle_pos_1+paddle_length))) then
       R <= X"F";
       elsif((h_pos>=585 and h_pos<600) and (v_pos>= paddle_pos_2 and v_pos<(paddle_pos_2+paddle_length))) then
       R <=X"F";
       else
       R <=X"0";
       end if;
       end process;
       
       draw_ball:process(ball_pos_x,ball_pos_y)
       begin
            if( (h_pos>=ball_pos_x and h_pos<(ball_pos_x+ball_size)) and (v_pos>=ball_pos_y and v_pos<(ball_pos_y+ball_size)) ) then
            R<=X"F";
            else
            R<=X"0";
            end if;
            end process;
            
        move_paddles:process(paddle_pos_1,paddle_pos_2,paddle1_up,paddle1_down,paddle2_up,paddle2_down)
        begin
            if(paddle1_up ='1' and v_sync ='1') then
               paddle_pos_1 <=paddle_pos_1 -1;
            elsif(paddle1_down ='1' and v_sync ='1') then
               paddle_pos_1 <=paddle_pos_1 +1;
            elsif(paddle2_up ='1' and v_sync ='1') then
               paddle_pos_2 <=paddle_pos_2 -1;
            elsif(paddle2_down ='1' and v_sync ='1') then
               paddle_pos_2 <=paddle_pos_2 +1;
               end if;
        end process;
        
        move_ball: process(ball_pos_x,ball_pos_y,ball_updown,ball_leftright)
        begin
            if(ball_updown='0' )then
            ball_pos_y<=ball_pos_y-1;
            elsif(ball_updown='1')then
            ball_pos_y<=ball_pos_y+1;
            end if;
            
            if(ball_leftright='0') then
            ball_pos_x<=ball_pos_x+1;
            elsif(ball_leftright='1')then
            ball_pos_x<=ball_pos_x-1;
            end if;
        end process;
        
        bounce_ball: process(ball_pos_x,ball_pos_y,ball_updown,ball_leftright,paddle_pos_1,paddle_pos_2)
        begin
            if(((ball_pos_x+ball_size)>=(800-paddle_width) and (ball_pos_y>=paddle_pos_2 and ball_pos_y<(paddle_pos_2+paddle_length))) ----when bounce the 2 paddles
                or ((ball_pos_x<=paddle_width)and (ball_pos_y>=paddle_pos_1 and ball_pos_y<(paddle_pos_2+paddle_length))))   then
                ball_leftright<= NOT ball_leftright;
            elsif(ball_pos_x= 0 ) then
                ball_pos_x<=400;
                ball_pos_y<=300;
                right_score<=right_score+1;
             elsif(ball_pos_x= 800 ) then
                ball_pos_x<=400;
                ball_pos_y<=300;
                left_score<=left_score+1;
              elsif(ball_pos_y=0 or ball_pos_y=600) then
                ball_updown<=NOT ball_updown;
                end if;
            end process;

end Behavioral;
