library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cronometro_959 is
    port (
		  clk_50Mhz   : in  std_logic;
        relojBase   : in  std_logic;
        boton_unico : in  std_logic;
        unidadesSec : out std_logic_vector(6 downto 0);
        decenasSec  : out std_logic_vector(6 downto 0);
        unidadesMin : out std_logic_vector(6 downto 0)
    );
end entity;

architecture logica of cronometro_959 is
    signal cuentaUniSec : unsigned(3 downto 0) := (others => '0');
    signal cuentaDecSec : unsigned(3 downto 0) := (others => '0');
    signal cuentaMin    : unsigned(3 downto 0) := (others => '0');
    signal estadoActivo : std_logic := '0';
	 signal orden_reset  : std_logic := '0';
    signal filtro_ruido : integer range 0 to 100000005 := 0;
begin
-- función sntirrebote
process (clk_50Mhz)
    begin	 
        if clk_50Mhz'event and clk_50Mhz = '1' then -- bloque antirrebote, se evalua cada flanco de subida de reloj
            if boton_unico = '0' then -- evalua el estado del botón
                
                if filtro_ruido < 50000 then         -- este primer condicional hace que no se tomen como validos toques menores a 1mS, eliminando el ruido de los rebotes
                    filtro_ruido <= filtro_ruido + 1; -- que por lo general no duran más de 1mS
                    
                elsif filtro_ruido = 50000 then-- cuando ya se haya mantenido por 1mS, se toma como valida la pulsación y se niega el estadoActivo 
                    estadoActivo <= not estadoActivo; 
                    filtro_ruido <= filtro_ruido + 1;
                    
                elsif filtro_ruido < 100000000 then  -- este bloque sigue contando para ver si se sigue manteniendo el botón, sin hacer ningun cambio
                    filtro_ruido <= filtro_ruido + 1;
                    
                elsif filtro_ruido = 100000000 then -- ya cuando pasen 2 segundos o 100Mhz, es entonces que tomarán cambios para el resed
                    orden_reset <= '1';              
                    estadoActivo <= '0';
                    filtro_ruido <= 100000001;     
                end if;               
            else
                filtro_ruido <= 0;	-- aquí se reinia todo para una siguiente pulsación 
                orden_reset  <= '0';
            end if;
        end if;
    end process;
	 
    process (relojBase,orden_reset)
    begin
        
      -- if general      
		if orden_reset = '1' then --primero se evalua el resed, si está activo simplemente todo se va a cero
            cuentaUniSec <= (others => '0');
            cuentaDecSec <= (others => '0');
            cuentaMin    <= (others => '0');
			-- contador 959, empieza evaluando si el reloj está en un flanco de subida
        elsif relojBase'event and relojBase = '1' then
            if estadoActivo = '1' then
                if cuentaMin = 9 and cuentaDecSec = 5 and cuentaUniSec = 9 then
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
        end if;
    end process;
	 -- decodificador
	  process(cuentaUniSec)
    begin
        case std_logic_vector(cuentaUniSec) is
            when "0000" => unidadesSec <= "1000000"; 
            when "0001" => unidadesSec <= "1111001"; 
            when "0010" => unidadesSec <= "0100100"; 
            when "0011" => unidadesSec <= "0110000"; 
            when "0100" => unidadesSec <= "0011001";
            when "0101" => unidadesSec <= "0010010";
            when "0110" => unidadesSec <= "0000010";
            when "0111" => unidadesSec <= "1111000"; 
            when "1000" => unidadesSec <= "0000000"; 
            when "1001" => unidadesSec <= "0010000"; 
            when others => unidadesSec <= "1000000";
        end case;
    end process;

    -- Decodificador interno para Decenas de Segundo
    process(cuentaDecSec)
    begin
        case std_logic_vector(cuentaDecSec) is
            when "0000" => decenasSec <= "1000000"; 
            when "0001" => decenasSec <= "1111001"; 
            when "0010" => decenasSec <= "0100100"; 
            when "0011" => decenasSec <= "0110000"; 
            when "0100" => decenasSec <= "0011001"; 
            when "0101" => decenasSec <= "0010010"; 
            when others => decenasSec <= "1000000"; 
        end case;
    end process;

    -- Decodificador interno para Unidades de Minuto
    process(cuentaMin)
    begin
        case std_logic_vector(cuentaMin) is
            when "0000" => unidadesMin <= "1000000"; 
            when "0001" => unidadesMin <= "1111001"; 
            when "0010" => unidadesMin <= "0100100"; 
            when "0011" => unidadesMin <= "0110000"; 
            when "0100" => unidadesMin <= "0011001"; 
            when "0101" => unidadesMin <= "0010010"; 
            when "0110" => unidadesMin <= "0000010"; 
            when "0111" => unidadesMin <= "1111000"; 
            when "1000" => unidadesMin <= "0000000"; 
            when "1001" => unidadesMin <= "0010000"; 
            when others => unidadesMin <= "1000000"; 
        end case;
    end process;
end architecture;