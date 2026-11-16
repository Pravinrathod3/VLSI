
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_Universal_Shift_Register is
end TB_Universal_Shift_Register;

architecture Behavioral of TB_Universal_Shift_Register is

    component Universal_Shift_Register
        Port (
            Clk          : in STD_LOGIC;
            Reset        : in STD_LOGIC;
            Sel          : in STD_LOGIC_VECTOR(1 downto 0);
            Serial_In    : in STD_LOGIC;
            Parallel_In  : in STD_LOGIC_VECTOR(3 downto 0);
            Parallel_Out : out STD_LOGIC_VECTOR(3 downto 0);
            Serial_Out   : out STD_LOGIC
        );
    end component;

    signal Clk          : STD_LOGIC := '0';
    signal Reset        : STD_LOGIC := '0';
    signal Sel          : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal Serial_In    : STD_LOGIC := '0';
    signal Parallel_In  : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal Parallel_Out : STD_LOGIC_VECTOR(3 downto 0);
    signal Serial_Out   : STD_LOGIC;

    constant Clk_Period : time := 10 ns;

begin

    -- Unit Under Test
    UUT: Universal_Shift_Register
        port map (
            Clk          => Clk,
            Reset        => Reset,
            Sel          => Sel,
            Serial_In    => Serial_In,
            Parallel_In  => Parallel_In,
            Parallel_Out => Parallel_Out,
            Serial_Out   => Serial_Out
        );

    -- Clock Generation
    Clk_Process : process
    begin
        Clk <= '0';
        wait for Clk_Period / 2;

        Clk <= '1';
        wait for Clk_Period / 2;
    end process;

    -- Stimulus Process
    Stim_Process : process
    begin

        -- Reset
        Reset <= '1';
        wait for 20 ns;

        Reset <= '0';

        -- 1. Parallel Load (Sel = 11)
        Sel <= "11";
        Parallel_In <= "1011";
        wait until rising_edge(Clk);
        wait for 1 ns;

        -- 2. Hold (Sel = 00)
        Sel <= "00";
        wait until rising_edge(Clk);
        wait for 1 ns;

        -- 3. Shift Right (Sel = 01)
        Sel <= "01";
        Serial_In <= '0';
        wait until rising_edge(Clk);
        wait for 1 ns;

        Serial_In <= '1';
        wait until rising_edge(Clk);
        wait for 1 ns;

        -- 4. Shift Left (Sel = 10)
        Sel <= "10";
        Serial_In <= '0';
        wait until rising_edge(Clk);
        wait for 1 ns;

        Serial_In <= '1';
        wait until rising_edge(Clk);
        wait for 1 ns;

        -- 5. Parallel Load another value
        Sel <= "11";
        Parallel_In <= "1101";
        wait until rising_edge(Clk);
        wait for 1 ns;

        -- 6. Hold
        Sel <= "00";
        wait until rising_edge(Clk);
        wait for 1 ns;

        wait;

    end process;

end Behavioral;
