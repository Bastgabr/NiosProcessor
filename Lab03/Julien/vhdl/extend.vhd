library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
        process
        variable temp : integer;
        begin
        if(signed = '0') then
        imm_extended (15 downto 0) <= imm16;
	imm_extended (31 downto 16) <= (others => '0');
	imm32 <= imm_extended;
        else 
        temp := to_integer(unsigned(imm16));
        imm32 <= std_logic_vector(to_signed(temp, 32));
        end if;
        end process;
        
end synth;
