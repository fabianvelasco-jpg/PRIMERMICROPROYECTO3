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
    signal estadoActivo : std_logic := '0';
    
    -- Memoria de tiempo de pulsación (cuenta latidos de 1Hz)
    signal cuenta_boton : integer range 0 to 3 := 0;
begin
    process (relojBase)
    begin
        if relojBase'event and relojBase = '1' then
            
            -- 1. LÓGICA DEL BOTÓN PRESIONADO ('0')
            if boton_unico = '0' then
                
                if cuenta_boton = 2 then
                    -- Al llegar a 2 segundos exactos, aplica RESET
                    cuentaUniSec <= (others => '0');
                    cuentaDecSec <= (others => '0');
                    cuentaMin    <= (others => '0');
                    estadoActivo <= '0';
                else
                    -- Mientras lo mantengas, suma 1 latido por segundo
                    cuenta_boton <= cuenta_boton + 1;
                end if;
                
            -- 2. LÓGICA DEL BOTÓN SUELTO ('1')
            else
                
                -- Verificamos si fue un clic corto (se soltó en el primer segundo)
                if cuenta_boton > 0 and cuenta_boton < 2 then
                    if estadoActivo = '1' then
                        estadoActivo <= '0';
                    else
                        estadoActivo <= '1';
                    end if;
                end if;
                
                -- Se borra la memoria del botón
                cuenta_boton <= 0;
                
                -- 3. LÓGICA MATEMÁTICA DEL CRONÓMETRO
                -- Solo avanza si está activo y no estás tocando el botón
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
                
            end if; -- Fin IF boton
            
        end if;
    end process;
    
    -- Traducción a vectores lógicos
    unidadesSec <= std_logic_vector(cuentaUniSec);
    decenasSec  <= std_logic_vector(cuentaDecSec);
    unidadesMin <= std_logic_vector(cuentaMin);
end architecture;