library ieee;
use ieee.std_logic_1164.all;

entity IR is
    port(
        clk    : in  std_logic;
        enable : in  std_logic;
        D      : in  std_logic_vector(31 downto 0);
        Q      : out std_logic_vector(31 downto 0)
    );
end IR;

architecture synth of IR is
	signal current_state : std_logic_vector(31 downto 0);
begin

	dff :process(clk)
	begin
		if (rising_edge(clk)) then
			if (enable = '1') then
			current_state <= D;
			end if;
		Q <= current_state;
		end if;
	end process;

end synth;
