library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divisor_1hz is
    port (
        clk_50Mhz : in  std_logic;
        resed     : in  std_logic; 
        clk_1Hz   : out std_logic
    );
end entity;

architecture logica of divisor_1hz is
    signal cuenta : integer range 0 to 24999999 := 0;
    signal estado : std_logic := '0';
begin
    process (clk_50Mhz, resed)
    begin
        -- Reset asíncrono original del componente
        if resed = '1' then
            cuenta <= 0; 
            estado <= '0';
        elsif clk_50Mhz'event and clk_50Mhz = '1' then
            if cuenta = 24999999 then
                estado <= not estado; 
                cuenta <= 0;
            else
                cuenta <= cuenta + 1;
            end if;
        end if;
    end process;
    
    clk_1Hz <= estado;
end architecture;