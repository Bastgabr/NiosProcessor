library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    port(
        address : in  std_logic_vector(15 downto 0);
        cs_LEDS : out std_logic;
        cs_RAM  : out std_logic;
        cs_ROM  : out std_logic
    );
end decoder;

architecture synth of decoder is
begin
	
	decode : process(address) 
	variable cnt : integer;
	begin
	cnt := to_integer(unsigned(address));
	case cnt is
		when 0 to 4092 => cs_ROM <= '1';
		when 4096 to 8188 => cs_RAM <= '1';
		when 8192 to 8204 => cs_LEDS <= '1';
		when others => null;
	end case;
	end process;
	
end synth;
