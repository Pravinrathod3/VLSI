
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alu_4bit is
end tb_alu_4bit;

architecture Behavioral of tb_alu_4bit is

    component alu_4bit is
        Port (
            A        : in STD_LOGIC_VECTOR(3 downto 0);
            B        : in STD_LOGIC_VECTOR(3 downto 0);
            Sel      : in STD_LOGIC_VECTOR(2 downto 0);
            Result   : out STD_LOGIC_VECTOR(3 downto 0);
            CarryOut : out STD_LOGIC
        );
    end component;

    signal A        : STD_LOGIC_VECTOR(3 downto 0);
    signal B        : STD_LOGIC_VECTOR(3 downto 0);
    signal Sel      : STD_LOGIC_VECTOR(2 downto 0);
    signal Result   : STD_LOGIC_VECTOR(3 downto 0);
    signal CarryOut : STD_LOGIC;

begin

    uut: alu_4bit
        port map (
            A        => A,
            B        => B,
            Sel      => Sel,
            Result   => Result,
            CarryOut => CarryOut
        );

    stim_proc: process
    begin

        A <= "1010";
        B <= "0011";

        Sel <= "000";
        wait for 20 ns;

        Sel <= "001";
        wait for 20 ns;

        Sel <= "010";
        wait for 20 ns;

        Sel <= "011";
        wait for 20 ns;

        Sel <= "100";
        wait for 20 ns;

        Sel <= "101";
        wait for 20 ns;

        Sel <= "110";
        wait for 20 ns;

        Sel <= "111";
        wait for 20 ns;

        A <= "0101";
        B <= "0101";

        Sel <= "110";
        wait for 20 ns;

        Sel <= "000";
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
