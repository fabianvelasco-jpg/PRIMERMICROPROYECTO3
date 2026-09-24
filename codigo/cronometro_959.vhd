library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cronometro_959 is
    port (
        relojBase   : in  std_logic;
        boton_unico : in  std_logic;
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
    
   
    signal cuenta_boton : integer range 0 to 3 := 0;
begin
    process (relojBase,boton_unico)
    begin
        
      -- if general      
		if boton_unico = '0' then -- empiza a evaluar si mi botón ya fue precionado o no
            if cuenta_boton = 0 then
                estadoActivo <= not estadoActivo;
                cuenta_boton <= 1;
            elsif cuenta_boton = 1 then
                cuentaUniSec <= (others => '0');
                cuentaDecSec <= (others => '0');
                cuentaMin    <= (others => '0');
                estadoActivo <= '0';
                cuenta_boton <= 2;
            end if;
			-- contador 959, empieza evaluando si el reloj está en un flanco de subida
        elsif relojBase'event and relojBase = '1' then
            if estadoActivo = '1' then
                if cuentaMin = 9 and cuentaDecSec = 5 and cuentaUniSec = 9 then
                    estadoActivo <= '0'; 	-- evalua si el estado activo es cero (activo)
                else
                    if cuentaUniSec = 9 then		-- mira si hemos llegado al limite de las unidades y 
																-- suma una decena, y si hemos llegado al limite de las decenas entonces se agrega un
																-- minuto, y si no se cumple ninguna entonces solo se añade una unidad
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
            
            cuenta_boton <= 0; -- al final la cuenta del botón se hace cero para evitar reconteos indeseados
        end if;
    end process;
    
    unidadesSec <= std_logic_vector(cuentaUniSec);
    decenasSec  <= std_logic_vector(cuentaDecSec);
    unidadesMin <= std_logic_vector(cuentaMin);
end architecture;