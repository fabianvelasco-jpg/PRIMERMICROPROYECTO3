library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cronometro_959 is
    port (
		  clk_50Mhz   : in  std_logic;
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
    signal estadoActivo : std_logic := '0';
	 signal orden_reset  : std_logic := '0';
    
    signal filtro_ruido : integer range 0 to 100000005 := 0;
    signal cuenta_boton : integer range 0 to 3 := 0;
begin
process (clk_50Mhz)
    begin
        if clk_50Mhz'event and clk_50Mhz = '1' then
            if boton_unico = '0' then
                
                if filtro_ruido < 50000 then
                    filtro_ruido <= filtro_ruido + 1; 
                    
                elsif filtro_ruido = 50000 then
                    estadoActivo <= not estadoActivo; 
                    filtro_ruido <= filtro_ruido + 1;
                    
                elsif filtro_ruido < 100000000 then
                    filtro_ruido <= filtro_ruido + 1;
                    
                elsif filtro_ruido = 100000000 then
                    orden_reset <= '1';              
                    estadoActivo <= '0';
                    filtro_ruido <= 100000001;     
                end if;
                
            else
                filtro_ruido <= 0;
                orden_reset  <= '0';
            end if;
        end if;
    end process;
	 
    process (relojBase,orden_reset)
    begin
        
      -- if general      
		if orden_reset = '1' then
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
            
            cuenta_boton <= 0; -- al final la cuenta del botón se hace cero para evitar reconteos indeseados
        end if;
    end process;
    
    unidadesSec <= std_logic_vector(cuentaUniSec); -- asignacion de vectores a las cuentas de unidades (seg), decenas, y minutos 
    decenasSec  <= std_logic_vector(cuentaDecSec);
    unidadesMin <= std_logic_vector(cuentaMin);
end architecture;