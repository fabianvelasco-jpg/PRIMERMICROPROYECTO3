library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sistema_top is
    port (
        reloj50Mhz   : in  std_logic;
        boton_unico  : in  std_logic; 
        
        dispMinutos  : out std_logic_vector(6 downto 0);
        dispDecenas  : out std_logic_vector(6 downto 0);
        dispUnidades : out std_logic_vector(6 downto 0);
		  salidareloj  : out std_logic
    );
end entity;

architecture estructural of sistema_top is
    -- intanciacion de componentes para poder usarlos después en el codigo
	 -- divizor de frecuencia a 1hz
    component divisor_1hz is
        port (clk_50Mhz, resed : in std_logic; clk_1Hz : out std_logic);
    end component;

    component cronometro_959 is
        port (
			   clk_50Mhz   : in  std_logic;
            relojBase   : in  std_logic;
            boton_unico : in  std_logic;
            unidadesSec : out std_logic_vector(6 downto 0);
            decenasSec  : out std_logic_vector(6 downto 0);
            unidadesMin : out std_logic_vector(6 downto 0)
        );
    end component;

    -- cables de conexión
    signal cableReloj1hz : std_logic;

begin
    salidareloj <= cableReloj1hz; --cable para el punto y se vea la division de segundos y minutos en la fpga
	 
    -- divisor de frecuencia para obtener el reloj de 1hz
    U1: divisor_1hz port map (
        clk_50Mhz => reloj50Mhz, 
        resed     => '1',
        clk_1Hz   => cableReloj1hz
    );
			-- cronometro 959 para poder tener los segunos, minuts etc
    U2: cronometro_959 port map (
		  clk_50Mhz   => reloj50Mhz,
        relojBase   => cableReloj1hz,
        boton_unico => boton_unico,
        unidadesSec => dispUnidades,
        decenasSec  => dispDecenas,
        unidadesMin => dispMinutos
    );


end architecture;