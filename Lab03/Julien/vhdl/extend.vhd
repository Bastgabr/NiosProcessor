library ieee;
use ieee.std_logic_1164.all;

entity extend is
    port(
        imm16  : in  std_logic_vector(15 downto 0);
        signed : in  std_logic;
        imm32  : out std_logic_vector(31 downto 0)
    );
end extend;

architecture synth of extend is
	signal imm_extended : std_logic_vector(31 downto 0);

begin
	imm_extended (15 downto 0) <= imm16;
	imm_extended (16) <= signed;
	imm_extended (31 downto 17) <= (others => '0');
	imm32 <= imm_extended;
end synth;
