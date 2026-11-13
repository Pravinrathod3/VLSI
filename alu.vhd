
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_4bit is
    Port (
        A        : in  STD_LOGIC_VECTOR(3 downto 0);
        B        : in  STD_LOGIC_VECTOR(3 downto 0);
        Sel      : in  STD_LOGIC_VECTOR(2 downto 0);
        Result   : out STD_LOGIC_VECTOR(3 downto 0);
        CarryOut : out STD_LOGIC
    );
end alu_4bit;

architecture Behavioral of alu_4bit is
begin

    process(A, B, Sel)

        variable temp_A   : unsigned(4 downto 0);
        variable temp_B   : unsigned(4 downto 0);
        variable temp_Res : unsigned(4 downto 0);

    begin

        temp_A := unsigned('0' & A);
        temp_B := unsigned('0' & B);

        CarryOut <= '0';

        case Sel is

            when "000" =>
                temp_Res := temp_A + temp_B;
                Result <= std_logic_vector(temp_Res(3 downto 0));
                CarryOut <= temp_Res(4);

            when "001" =>
                temp_Res := temp_A - temp_B;
                Result <= std_logic_vector(temp_Res(3 downto 0));

            when "010" =>
                temp_Res := temp_A + 1;
                Result <= std_logic_vector(temp_Res(3 downto 0));
                CarryOut <= temp_Res(4);

            when "011" =>
                temp_Res := temp_A - 1;
                Result <= std_logic_vector(temp_Res(3 downto 0));

            when "100" =>
                Result <= A and B;

            when "101" =>
                Result <= A or B;

            when "110" =>
                Result <= A xor B;

            when "111" =>
                Result <= not A;

            when others =>
                Result <= "0000";

        end case;

    end process;

end Behavioral;
