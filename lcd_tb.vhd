
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_lcd_interface is
end tb_lcd_interface;

architecture behavior of tb_lcd_interface is

  -- UUT Signals
  signal clk : std_logic := '0';
  signal rst : std_logic := '0';

  signal lcd_e : std_logic;
  signal lcd_rs : std_logic;
  signal lcd_rw : std_logic;
  signal lcd_db : std_logic_vector(7 downto 0);

  -- Clock period: 50 MHz
  constant clk_period : time := 20 ns;

begin

  -- Instantiate the Unit Under Test
  uut: entity work.lcd_interface
     port map (
        clk => clk,
        rst => rst,
        lcd_e => lcd_e,
        lcd_rs => lcd_rs,
        lcd_rw => lcd_rw,
        lcd_db => lcd_db
     );

  -- Clock process
  clk_process : process
  begin
     clk <= '0';
     wait for clk_period/2;

     clk <= '1';
     wait for clk_period/2;
  end process;

  -- Stimulus process
  stim_proc: process
  begin
     rst <= '1';
     wait for 100 ns;

     rst <= '0';

     wait;
  end process;

end behavior;
