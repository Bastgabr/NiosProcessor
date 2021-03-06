library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add_sub is
    port(
        a        : in  std_logic_vector(31 downto 0);
        b        : in  std_logic_vector(31 downto 0);
        sub_mode : in  std_logic;
        carry    : out std_logic;
        zero     : out std_logic;
        r        : out std_logic_vector(31 downto 0)
    );
end add_sub;

architecture synth of add_sub is
	signal result : std_logic_vector(32 downto 0):= (others => '0');
begin
	adder : process(a, b, sub_mode, result)
		variable a_complete : unsigned(32 downto 0);
		variable b_complete : unsigned(32 downto 0);
	begin
		a_complete  := resize(unsigned(a), 33);
		if(sub_mode='0') then
			b_complete  := resize(unsigned(b), 33);
		else
			b_complete  := resize(unsigned(not b), 33);
			b_complete := b_complete +1;
		end if;
			result <= std_logic_vector(a_complete + b_complete);

			if(unsigned(result(31 downto 0))) = 0 then 
				zero <= '1';
			else
				zero <= '0';
			end if;
			r <= result(31 downto 0);
			carry <= result(result'left);

	end process;
end;