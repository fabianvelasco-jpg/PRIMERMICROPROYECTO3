library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sistema_top is
    port (
        reloj50Mhz   : in  std_logic;
        boton_unico  : in  std_logic; 
        
        dispMinutos  : out std_logic_vector(6 downto 0);
        dispDecenas  : out std_logic_vector(6 downto 0);
        dispUnidades : out std_logic_vector(6 downto 0)
    );
end entity;

architecture estructural of sistema_top is
    
    component divisor_1hz is
        port (clk_50Mhz, resed : in std_logic; clk_1Hz : out std_logic);
    end component;

    component cronometro_959 is
        port (
            relojBase   : in  std_logic;
            boton_unico : in  std_logic;
            unidadesSec : out std_logic_vector(3 downto 0);
            decenasSec  : out std_logic_vector(3 downto 0);
            unidadesMin : out std_logic_vector(3 downto 0)
        );
    end component;

    component decodificador_7seg is
        port (
            entradaBCD : in std_logic_vector(3 downto 0);
            salida7seg : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Cables de interconexión interna
    signal cableReloj1hz : std_logic;
    signal cableUniSec   : std_logic_vector(3 downto 0);
    signal cableDecSec   : std_logic_vector(3 downto 0);
    signal cableMin      : std_logic_vector(3 downto 0);

begin
    
    -- El divisor recibe '0' constante en resed para no detenerse jamás
    U1: divisor_1hz port map (
        clk_50Mhz => reloj50Mhz,
        resed     => '0',
        clk_1Hz   => cableReloj1hz
    );

    U2: cronometro_959 port map (
        relojBase   => cableReloj1hz,
        boton_unico => boton_unico,
        unidadesSec => cableUniSec,
        decenasSec  => cableDecSec,
        unidadesMin => cableMin
    );

    U3_Minutos: decodificador_7seg port map (
        entradaBCD => cableMin, 
        salida7seg => dispMinutos
    );
    
    U4_Decenas: decodificador_7seg port map (
        entradaBCD => cableDecSec, 
        salida7seg => dispDecenas
    );
    
    U5_Unidades: decodificador_7seg port map (
        entradaBCD => cableUniSec, 
        salida7seg => dispUnidades
    );

end architecture;