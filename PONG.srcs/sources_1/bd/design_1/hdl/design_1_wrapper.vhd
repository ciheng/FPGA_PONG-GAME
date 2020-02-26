--Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2018.2 (win64) Build 2258646 Thu Jun 14 20:03:12 MDT 2018
--Date        : Tue Oct  2 17:18:13 2018
--Host        : DESKTOP-ERR660S running 64-bit major release  (build 9200)
--Command     : generate_target design_1_wrapper.bd
--Design      : design_1_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_wrapper is
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
end design_1_wrapper;

architecture STRUCTURE of design_1_wrapper is
  component design_1 is
  port (
    clk_in1 : in STD_LOGIC;
    R : out STD_LOGIC_VECTOR ( 4 downto 0 );
    G : out STD_LOGIC_VECTOR ( 5 downto 0 );
    B : out STD_LOGIC_VECTOR ( 4 downto 0 );
    BUTTON : in STD_LOGIC_VECTOR ( 3 downto 0 );
    HS : out STD_LOGIC;
    VS : out STD_LOGIC;
    reset_n : in STD_LOGIC
  );
  end component design_1;
begin
design_1_i: component design_1
     port map (
      B(4 downto 0) => B(4 downto 0),
      BUTTON(3 downto 0) => BUTTON(3 downto 0),
      G(5 downto 0) => G(5 downto 0),
      HS => HS,
      R(4 downto 0) => R(4 downto 0),
      VS => VS,
      clk_in1 => clk_in1,
      reset_n => reset_n
    );
end STRUCTURE;
