
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_memory is
  generic (
     DATA_WIDTH : integer := 8;
     FIFO_DEPTH : integer := 16
  );
  port (
     clk : in std_logic;
     rst : in std_logic;
     wr_en : in std_logic;
     rd_en : in std_logic;
     din : in std_logic_vector(DATA_WIDTH-1 downto 0);
     dout : out std_logic_vector(DATA_WIDTH-1 downto 0);
     full : out std_logic;
     empty : out std_logic
  );
end entity;

architecture rtl of fifo_memory is

  type ram_type is array (0 to FIFO_DEPTH-1)
    of std_logic_vector(DATA_WIDTH-1 downto 0);

  signal memory : ram_type :=
    (others => (others => '0'));

  signal wr_ptr : integer range 0 to FIFO_DEPTH-1 := 0;
  signal rd_ptr : integer range 0 to FIFO_DEPTH-1 := 0;
  signal count : integer range 0 to FIFO_DEPTH := 0;

  signal full_i : std_logic;
  signal empty_i : std_logic;

begin

  full_i <= '1' when (count = FIFO_DEPTH) else '0';
  empty_i <= '1' when (count = 0) else '0';

  full <= full_i;
  empty <= empty_i;

  -- Memory Write and Pointer Management
  process(clk, rst)
  begin
    if rst = '1' then
       wr_ptr <= 0;
       rd_ptr <= 0;
       count <= 0;
       dout <= (others => '0');

    elsif rising_edge(clk) then

       -- Write Operation
       if (wr_en = '1' and full_i = '0') then
           memory(wr_ptr) <= din;

           if wr_ptr = FIFO_DEPTH-1 then
              wr_ptr <= 0;
           else
              wr_ptr <= wr_ptr + 1;
           end if;
       end if;

       -- Read Operation
       if (rd_en = '1' and empty_i = '0') then
          dout <= memory(rd_ptr);

          if rd_ptr = FIFO_DEPTH-1 then
             rd_ptr <= 0;
          else
             rd_ptr <= rd_ptr + 1;
          end if;
       end if;

       -- Counter Tracking Element Density
       if (wr_en = '1' and full_i = '0') and
          not (rd_en = '1' and empty_i = '0') then
          count <= count + 1;

       elsif (rd_en = '1' and empty_i = '0') and
             not (wr_en = '1' and full_i = '0') then
          count <= count - 1;
       end if;

    end if;
  end process;

end architecture;
