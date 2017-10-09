library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
    port(
        clk     : in  std_logic;
        cs      : in  std_logic;
        read    : in  std_logic;
        address : in  std_logic_vector(9 downto 0);
        rddata  : out std_logic_vector(31 downto 0)
    );
end ROM;

architecture synth of ROM is
begin
ROM_Block : ENTITY work.ROM_Block port map(
            address      => address,
             clock  => clk,
             q   =>  rddata);


process(cs)
begin
if(cs = '0')
then rddata <= (others => 'Z');
end if;
end process;
end synth;
