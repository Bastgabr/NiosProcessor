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
	

begin
        process(imm16, signed)
        begin
        if(signed = '0') then
        imm32(15 downto 0) <= imm16;
	imm32(31 downto 16) <= (others => '0');
        else 
        if(imm16(15)='1') then
        imm32(15 downto 0) <= imm16;
	imm32(31 downto 16) <= (others => '1');
        else
        imm32(15 downto 0) <= imm16;
	imm32(31 downto 16) <= (others => '0');
        end if;
        end if;
        end process;
        
end synth;
