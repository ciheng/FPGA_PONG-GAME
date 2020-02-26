--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
--Date        : Tue Oct  2 17:18:13 2018
--Host        : DESKTOP-ERR660S running 64-bit major release  (build 9200)
--Command     : generate_target design_1.bd
--Design      : design_1
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1 is
  port (
    B : out STD_LOGIC_VECTOR ( 4 downto 0 );
    BUTTON : in STD_LOGIC_VECTOR ( 3 downto 0 );
    G : out STD_LOGIC_VECTOR ( 5 downto 0 );
    HS : out STD_LOGIC;
    R : out STD_LOGIC_VECTOR ( 4 downto 0 );
    VS : out STD_LOGIC;
    clk_in1 : in STD_LOGIC;
    reset_n : in STD_LOGIC
  );
  attribute CORE_GENERATION_INFO : string;
  attribute CORE_GENERATION_INFO of design_1 : entity is "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VHDL,numBlks=3,numReposBlks=3,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=2,numPkgbdBlks=0,bdsource=USER,da_clkrst_cnt=2,da_ps7_cnt=1,synth_mode=Global}";
  attribute HW_HANDOFF : string;
  attribute HW_HANDOFF of design_1 : entity is "design_1.hwdef";
end design_1;

architecture STRUCTURE of design_1 is
  component design_1_clk_wiz_0_0 is
  port (
    reset : in STD_LOGIC;
    clk_in1 : in STD_LOGIC;
    clk_out1 : out STD_LOGIC;
    locked : out STD_LOGIC
  );
  end component design_1_clk_wiz_0_0;
  component design_1_VGA_PONG_0_1 is
  port (
    clock_40 : in STD_LOGIC;
    BUTTON : in STD_LOGIC_VECTOR ( 3 downto 0 );
    SW : in STD_LOGIC;
    new_fream : in STD_LOGIC;
    current_h : in STD_LOGIC;
    current_v : in STD_LOGIC;
    VGA_HS : out STD_LOGIC;
    VGA_VS : out STD_LOGIC;
    VGA_R : out STD_LOGIC_VECTOR ( 4 downto 0 );
    VGA_G : out STD_LOGIC_VECTOR ( 5 downto 0 );
    VGA_B : out STD_LOGIC_VECTOR ( 4 downto 0 )
  );
  end component design_1_VGA_PONG_0_1;
  component design_1_X_Y_0_2 is
  port (
    vga_clk : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    HS : out STD_LOGIC;
    VS : out STD_LOGIC;
    R : out STD_LOGIC_VECTOR ( 4 downto 0 );
    G : out STD_LOGIC_VECTOR ( 5 downto 0 );
    B : out STD_LOGIC_VECTOR ( 4 downto 0 );
    new_frame : out STD_LOGIC;
    current_h : out STD_LOGIC_VECTOR ( 11 downto 0 );
    current_v : out STD_LOGIC_VECTOR ( 10 downto 0 );
    R_in : in STD_LOGIC_VECTOR ( 4 downto 0 );
    G_in : in STD_LOGIC_VECTOR ( 5 downto 0 );
    B_in : in STD_LOGIC_VECTOR ( 4 downto 0 )
  );
  end component design_1_X_Y_0_2;
  signal BUTTON_1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal VGA_PONG_0_VGA_B : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal VGA_PONG_0_VGA_G : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal VGA_PONG_0_VGA_R : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal X_Y_0_B : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal X_Y_0_G : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal X_Y_0_HS : STD_LOGIC;
  signal X_Y_0_R : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal X_Y_0_VS : STD_LOGIC;
  signal X_Y_0_current_h : STD_LOGIC_VECTOR ( 11 downto 0 );
  signal X_Y_0_current_v : STD_LOGIC_VECTOR ( 10 downto 0 );
  signal X_Y_0_new_frame : STD_LOGIC;
  signal clk_in1_1 : STD_LOGIC;
  signal clk_wiz_0_clk_out1 : STD_LOGIC;
  signal reset_n_1 : STD_LOGIC;
  signal NLW_VGA_PONG_0_VGA_HS_UNCONNECTED : STD_LOGIC;
  signal NLW_VGA_PONG_0_VGA_VS_UNCONNECTED : STD_LOGIC;
  signal NLW_clk_wiz_0_locked_UNCONNECTED : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of clk_in1 : signal is "xilinx.com:signal:clock:1.0 CLK.CLK_IN1 CLK";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of clk_in1 : signal is "XIL_INTERFACENAME CLK.CLK_IN1, CLK_DOMAIN design_1_clk_in1, FREQ_HZ 125000000, PHASE 0.000";
  attribute X_INTERFACE_INFO of reset_n : signal is "xilinx.com:signal:reset:1.0 RST.RESET_N RST";
  attribute X_INTERFACE_PARAMETER of reset_n : signal is "XIL_INTERFACENAME RST.RESET_N, POLARITY ACTIVE_LOW";
begin
  B(4 downto 0) <= X_Y_0_B(4 downto 0);
  BUTTON_1(3 downto 0) <= BUTTON(3 downto 0);
  G(5 downto 0) <= X_Y_0_G(5 downto 0);
  HS <= X_Y_0_HS;
  R(4 downto 0) <= X_Y_0_R(4 downto 0);
  VS <= X_Y_0_VS;
  clk_in1_1 <= clk_in1;
  reset_n_1 <= reset_n;
VGA_PONG_0: component design_1_VGA_PONG_0_1
     port map (
      BUTTON(3 downto 0) => BUTTON_1(3 downto 0),
      SW => '0',
      VGA_B(4 downto 0) => VGA_PONG_0_VGA_B(4 downto 0),
      VGA_G(5 downto 0) => VGA_PONG_0_VGA_G(5 downto 0),
      VGA_HS => NLW_VGA_PONG_0_VGA_HS_UNCONNECTED,
      VGA_R(4 downto 0) => VGA_PONG_0_VGA_R(4 downto 0),
      VGA_VS => NLW_VGA_PONG_0_VGA_VS_UNCONNECTED,
      clock_40 => clk_wiz_0_clk_out1,
      current_h => X_Y_0_current_h(0),
      current_v => X_Y_0_current_v(0),
      new_fream => X_Y_0_new_frame
    );
X_Y_0: component design_1_X_Y_0_2
     port map (
      B(4 downto 0) => X_Y_0_B(4 downto 0),
      B_in(4 downto 0) => VGA_PONG_0_VGA_B(4 downto 0),
      G(5 downto 0) => X_Y_0_G(5 downto 0),
      G_in(5 downto 0) => VGA_PONG_0_VGA_G(5 downto 0),
      HS => X_Y_0_HS,
      R(4 downto 0) => X_Y_0_R(4 downto 0),
      R_in(4 downto 0) => VGA_PONG_0_VGA_R(4 downto 0),
      VS => X_Y_0_VS,
      current_h(11 downto 0) => X_Y_0_current_h(11 downto 0),
      current_v(10 downto 0) => X_Y_0_current_v(10 downto 0),
      new_frame => X_Y_0_new_frame,
      reset_n => reset_n_1,
      vga_clk => clk_wiz_0_clk_out1
    );
clk_wiz_0: component design_1_clk_wiz_0_0
     port map (
      clk_in1 => clk_in1_1,
      clk_out1 => clk_wiz_0_clk_out1,
      locked => NLW_clk_wiz_0_locked_UNCONNECTED,
      reset => '0'
    );
end STRUCTURE;
