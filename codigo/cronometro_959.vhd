library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cronometro_959 is
    port (
        relojBase   : in  std_logic;
        boton_unico : in  std_logic; -- Único control (Active-Low)
        unidadesSec : out std_logic_vector(3 downto 0);
        decenasSec  : out std_logic_vector(3 downto 0);
        unidadesMin : out std_logic_vector(3 downto 0)
    );
end entity;

architecture logica of cronometro_959 is
    signal cuentaUniSec : unsigned(3 downto 0) := (others => '0');
    signal cuentaDecSec : unsigned(3 downto 0) := (others => '0');
    signal cuentaMin    : unsigned(3 downto 0) := (others => '0');
    signal estadoActivo : std_logic := '1';
    
    -- Memoria de tiempo de pulsación (cuenta latidos de 1Hz)
    signal cuenta_boton : integer range 0 to 3 := 0;
begin
    process (relojBase,boton_unico)
    begin
        
            
           if boton_unico = '0' then

                if cuenta_boton = 0 then
                    -- Primer latido con el botón: alterna start/stop YA
                    estadoActivo <= not estadoActivo;
                    cuenta_boton <= 1;

                elsif cuenta_boton = 1 then
                    -- Segundo latido seguido: RESET
                    cuentaUniSec <= (others => '0');
                    cuentaDecSec <= (others => '0');
                    cuentaMin    <= (others => '0');
                    estadoActivo <= '0';
                    cuenta_boton <= 2;
                end if;

                elsif
						if relojBase'event and relojBase = '1' then
                    -- Solo avanza si ya estaba activo desde el latido anterior
                    if estadoActivo = '1' then
                        if cuentaMin = 9 and cuentaDecSec = 5 and cuentaUniSec = 9 then
                            estadoActivo <= '0'; -- Límite máximo
                        else
                            if cuentaUniSec = 9 then
                                cuentaUniSec <= (others => '0');
                                
                                if cuentaDecSec = 5 then
                                    cuentaDecSec <= (others => '0');
                                    cuentaMin <= cuentaMin + 1;
                                else
                                    cuentaDecSec <= cuentaDecSec + 1;
                                end if;
                            else
                                cuentaUniSec <= cuentaUniSec + 1;
                           end if;
                       end if;
                  end if;
                end if;
              
                -- Se borra la memoria del botón obligatoriamente al final
                cuenta_boton <= 0;
              end if;  
            end if;
    end process;
    
    -- Traducción a vectores lógicos
    unidadesSec <= std_logic_vector(cuentaUniSec);
    decenasSec  <= std_logic_vector(cuentaDecSec);
    unidadesMin <= std_logic_vector(cuentaMin);
end architecture;