library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decodificador_7seg is
    port (
        entradaBCD : in  std_logic_vector(3 downto 0);
        salida7seg : out std_logic_vector(6 downto 0)
    );
end decodificador_7seg;

architecture comportamiento of decodificador_7seg is
begin
    process(entradaBCD)
    begin
        case entradaBCD is
            when "0000" => salida7seg <= "1000000"; -- 0
            when "0001" => salida7seg <= "1111001"; -- 1
            when "0010" => salida7seg <= "0100100"; -- 2
            when "0011" => salida7seg <= "0110000"; -- 3
            when "0100" => salida7seg <= "0011001"; -- 4
            when "0101" => salida7seg <= "0010010"; -- 5
            when "0110" => salida7seg <= "0000010"; -- 6
            when "0111" => salida7seg <= "1111000"; -- 7
            when "1000" => salida7seg <= "0000000"; -- 8
            when "1001" => salida7seg <= "0010000"; -- 9
            when others => salida7seg <= "1111111"; -- 0 para otro caso
        end case;
    end process;
end architecture;