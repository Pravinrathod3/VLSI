
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fifo_memory is
end entity;

architecture behavior of tb_fifo_memory is

  constant DATA_WIDTH : integer := 8;
  constant FIFO_DEPTH : integer := 4;

  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal wr_en : std_logic := '0';
  signal rd_en : std_logic := '0';

  signal din : std_logic_vector(DATA_WIDTH-1 downto 0)
    := (others => '0');

  signal dout : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal full : std_logic;
  signal empty : std_logic;

  constant clk_period : time := 20 ns;

begin

  -- Instantiate the Unit Under Test
  uut: entity work.fifo_memory
     generic map (
        DATA_WIDTH => DATA_WIDTH,
        FIFO_DEPTH => FIFO_DEPTH
     )
     port map (
        clk => clk,
        rst => rst,
        wr_en => wr_en,
        rd_en => rd_en,
        din => din,
        dout => dout,
        full => full,
        empty => empty
     );

  -- Clock Process
  clk_process : process
  begin
     clk <= '0';
     wait for clk_period/2;
     clk <= '1';
     wait for clk_period/2;
  end process;

  -- Stimulus Process
  stim_proc: process
  begin

     -- Step 1: Active Reset
     rst <= '1';
     wait for clk_period*2;
     rst <= '0';
     wait for clk_period;

     -- Step 2: Write Data until Full
     wr_en <= '1';

     din <= x"AA";
     wait for clk_period;

     din <= x"BB";
     wait for clk_period;

     din <= x"CC";
     wait for clk_period;

     din <= x"DD";
     wait for clk_period;

     wr_en <= '0';
     wait for clk_period*2;

     -- Step 3: Read Data until Empty
     rd_en <= '1';
     wait for clk_period*4;

     rd_en <= '0';

     wait;
  end process;

end architecture;
