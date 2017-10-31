
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC is
    port(
        clk     : in  std_logic;
        reset_n : in  std_logic;
        en      : in  std_logic;
        sel_a   : in  std_logic;
        sel_imm : in  std_logic;
        add_imm : in  std_logic;
        imm     : in  std_logic_vector(15 downto 0);
        a       : in  std_logic_vector(15 downto 0);
        addr    : out std_logic_vector(31 downto 0)
    );
end PC;

architecture synth of PC is
signal reg : integer;
begin
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset_n = '1') then
				reg <= 0;

			elsif(en = '1') then
				if (add_imm = '1') then
					reg <= reg + to_integer(unsigned(imm));
				
				elsif (sel_imm = '1') then
					addr <= imm(13 downto 0) & "00";

				elsif (sel_a = '1') then
					reg <= to_integer(unsigned(a));

				else  reg <= reg + 4;
				end if;

			else addr <= std_logic_vector(to_unsigned(reg, 32));
			end if;
		end if;
	end process;
end synth;
