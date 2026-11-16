
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lcd_interface is
  Port (
     clk : in STD_LOGIC;
     rst : in STD_LOGIC;
     lcd_e : out STD_LOGIC;
     lcd_rs: out STD_LOGIC;
     lcd_rw: out STD_LOGIC;
     lcd_db: out STD_LOGIC_VECTOR(7 downto 0)
  );
end lcd_interface;

architecture Behavioral of lcd_interface is

  -- State Machine
  type state_type is (
     ST_RESET, ST_INIT, ST_COMMAND, ST_DATA, ST_DONE
  );

  signal state : state_type := ST_RESET;

  -- Timing counter for 50 MHz clock
  signal count : unsigned(23 downto 0) :=
                 (others => '0');

  -- LCD Commands
  type rom_commands is array (0 to 5)
       of STD_LOGIC_VECTOR(7 downto 0);

  constant commands : rom_commands := (
     X"38",
     X"38",
     X"0C",
     X"01",
     X"06",
     X"80"
  );

  -- Character Data: HELLO WORLD
  type rom_data is array (0 to 10)
       of STD_LOGIC_VECTOR(7 downto 0);

  constant data_chars : rom_data := (
     X"48", X"45", X"4C", X"4C", X"4F",
     X"20", X"57", X"4F", X"52", X"4C", X"44"
  );

  signal index : integer := 0;
  signal e_state : STD_LOGIC := '0';

begin

  lcd_rw <= '0';
  lcd_e <= e_state;

  process(clk, rst)
  begin

    if rst = '1' then
       state <= ST_RESET;
       count <= (others => '0');
       index <= 0;
       e_state <= '0';
       lcd_rs <= '0';
       lcd_db <= X"00";

    elsif rising_edge(clk) then

       case state is

         -- Wait for LCD power-up
         when ST_RESET =>
            lcd_rs <= '0';

            if count < 1000000 then
               count <= count + 1;
            else
               count <= (others => '0');
               state <= ST_INIT;
            end if;

         -- Send initialization commands
         when ST_INIT =>
            lcd_rs <= '0';
            lcd_db <= commands(index);

            if count < 100000 then
               count <= count + 1;

               if count < 2000 then
                  e_state <= '0';
               elsif count < 10000 then
                  e_state <= '1';
               else
                  e_state <= '0';
               end if;

            else
               count <= (others => '0');

               if index < 5 then
                  index <= index + 1;
               else
                  index <= 0;
                  state <= ST_DATA;
               end if;
            end if;

         -- Send character data
         when ST_DATA =>
            lcd_rs <= '1';
            lcd_db <= data_chars(index);

            if count < 100000 then
               count <= count + 1;

               if count < 2000 then
                  e_state <= '0';
               elsif count < 10000 then
                  e_state <= '1';
               else
                  e_state <= '0';
               end if;

            else
               count <= (others => '0');

               if index < 10 then
                  index <= index + 1;
               else
                  state <= ST_DONE;
               end if;
            end if;

         -- Idle state
         when ST_DONE =>
            e_state <= '0';
            state <= ST_DONE;

         when others =>
            state <= ST_RESET;

       end case;
    end if;

  end process;

end Behavioral;
