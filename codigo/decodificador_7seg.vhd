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
            when "0000" => salida7seg <= "1000000"; -- Muestra 0
            when "0001" => salida7seg <= "1111001"; -- Muestra 1
            when "0010" => salida7seg <= "0100100"; -- Muestra 2
            when "0011" => salida7seg <= "0110000"; -- Muestra 3
            when "0100" => salida7seg <= "0011001"; -- Muestra 4
            when "0101" => salida7seg <= "0010010"; -- Muestra 5
            when "0110" => salida7seg <= "0000010"; -- Muestra 6
            when "0111" => salida7seg <= "1111000"; -- Muestra 7
            when "1000" => salida7seg <= "0000000"; -- Muestra 8
            when "1001" => salida7seg <= "0010000"; -- Muestra 9
            when others => salida7seg <= "1111111"; -- Apagado total
        end case;
    end process;
end architecture;