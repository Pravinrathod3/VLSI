
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_mod_n_counter is
end tb_mod_n_counter;

architecture Behavioral of tb_mod_n_counter is

  -- Component Declaration
  component mod_n_counter is
     generic (
        N : integer := 10;
        WIDTH : integer := 4
     );
     port (
        clk : in std_logic;
        rst : in std_logic;
        en : in std_logic;
        count : out std_logic_vector(WIDTH-1 downto 0);
        max_tick : out std_logic
     );
  end component;

  -- Signals
  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal en : std_logic := '0';
  signal count : std_logic_vector(3 downto 0);
  signal max_tick : std_logic;

  -- Clock period
  constant clk_period : time := 20 ns;

begin

  -- Instantiate the Unit Under Test
  uut: mod_n_counter
     generic map (
        N => 10,
        WIDTH => 4
     )
     port map (
        clk => clk,
        rst => rst,
        en => en,
        count => count,
        max_tick => max_tick
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

     -- Apply reset
     rst <= '1';
     wait for 40 ns;
     rst <= '0';
     wait for 20 ns;

     -- Enable counting
     en <= '1';
     wait for 300 ns;

     -- Disable counter
     en <= '0';
     wait for 40 ns;

     -- Re-enable counter
     en <= '1';
     wait for 100 ns;

     wait;
  end process;

end Behavioral;