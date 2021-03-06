
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
signal reg : std_logic_vector(15 downto 0);
begin
	process(clk, reg, reset_n)
	begin
                   if(reset_n = '0') then
				reg <= (others =>'0');
                    end if;


		if(rising_edge(clk)) then
			if(en = '1' and reset_n='1') then
				if (add_imm = '1') then
					reg <= std_logic_vector(unsigned(reg) + unsigned(imm(15 downto 2) & "00"));
				
				elsif (sel_imm = '1') then
                                      reg <= imm(13 downto 0) & "00";

				elsif (sel_a = '1') then
                                       
					reg(15 downto 0) <= a(15 downto 2) & "00";

				 else  reg <= std_logic_vector(unsigned(reg) + "100");
				end if;
                        end if;
                 end if;
	   
			
		
	end process;

       addr <= x"0000" & reg;
end synth;
