library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is
    port(
        address : in  std_logic_vector(15 downto 0);
        cs_LEDS : out std_logic;
        cs_RAM  : out std_logic;
        cs_ROM  : out std_logic;
	cs_buttons : out std_logic
    );
end decoder;

architecture synth of decoder is
begin
process(address)
variable address_int : integer;
begin
cs_RAM <= '0'; cs_LEDS <= '0'; cs_ROM <= '0'; cs_buttons <= '0';
address_int := to_integer(unsigned(address));
case address_int is
when 0 to 4092 => cs_ROM <= '1'; 
when 4096 to 8188 => cs_RAM <= '1';
when 8192 to 8204 => cs_LEDS <='1';
when 8240 to 8244 => cs_buttons <= '1';

when others => null;
end case;
end process;
end synth;
