library ieee;
use ieee.std_logic_1164.all;

entity controller is
    port(
        clk        : in  std_logic;
        reset_n    : in  std_logic;
        -- instruction opcode
        op         : in  std_logic_vector(5 downto 0);
        opx        : in  std_logic_vector(5 downto 0);
        -- activates branch condition
        branch_op  : out std_logic;
        -- immediate value sign extention
        imm_signed : out std_logic;
        -- instruction register enable
        ir_en      : out std_logic;
        -- PC control signals
        pc_add_imm : out std_logic;
        pc_en      : out std_logic;
        pc_sel_a   : out std_logic;
        pc_sel_imm : out std_logic;
        -- register file enable
        rf_wren    : out std_logic;
        -- multiplexers selections
        sel_addr   : out std_logic;
        sel_b      : out std_logic;
        sel_mem    : out std_logic;
        sel_pc     : out std_logic;
        sel_ra     : out std_logic;
        sel_rC     : out std_logic;
        -- write memory output
        read       : out std_logic;
        write      : out std_logic;
        -- alu op
        op_alu     : out std_logic_vector(5 downto 0)
    );
end controller;

architecture synth of controller is
	type state_type is (FETCH1, FETCH2, DECODE, STORE, I_OP, R_OP, LOAD1, LOAD2, BREAK);
	signal current_state, next_state : state_type;
	begin

		process(current_state) 
		begin
		-- set all outputs to 0
		branch_op <= '0'; ir_en <= '0'; 
		pc_add_imm <= '0'; pc_en <= '0'; pc_sel_a <= '0'; pc_sel_imm <= '0';
		rf_wren <= '0'; sel_addr <= '0'; sel_b <= '0'; sel_mem <= '0'; sel_pc <= '0'; sel_ra <= '0'; sel_rC <= '0';
		read <= '0'; write <= '0';
	
		case current_state is 
			when FETCH1 => next_state <= FETCH2; read <= '1';
			when FETCH2 => next_state <= DECODE;
				  ir_en <= '1';
				  pc_en <= '1';
			when DECODE => if (op = "111010" and opx = "110100") then next_state <= BREAK;
				  elsif (op = "111010") then next_state <= R_OP;
				  elsif (op = "010111") then next_state <= LOAD1;
				  elsif (op = "010101") then next_state <= STORE;
				  else next_state <= I_OP;
				  end if;
			when I_OP => if (op = "011001" or op = "011010") then 
							end if; rf_wren <= '1';
							next_state <= FETCH1;
			when R_OP => sel_b <= '1'; sel_rC <= '1'; rf_wren <= '1'; next_state <= FETCH1;
			when STORE => write <= '1'; sel_addr <= '1'; next_state <= FETCH1;
			when BREAK => rf_wren <= '0'; ir_en <= '0'; pc_en <= '0'; next_state <= BREAK;
			when LOAD1 => read <= '1'; sel_addr <= '1'; next_state <= LOAD2; 
			when LOAD2 => sel_mem <= '1'; sel_rC <= '0'; rf_wren <= '1'; next_state <= FETCH1;
			when others => null;
		end case;		  
		end process;

	alu_logic :process(op, opx)
	begin
		if (op = "111010") then
			case opx is
				when "001110" => op_alu <= "101101";
				when "011011" => op_alu <= "110011"; imm_signed <= '0';
				when others => null;
			end case;
		else case op is
			when "000100" => op_alu <= "000000"; imm_signed <= '1';
			when "010111" => imm_signed <= '1';
			when "010101" => imm_signed <= '1';
			when "000110" => branch_op <= '1';
			when "001110" => branch_op <= '1'; op_alu <= "011001";
			when "010110" => branch_op <= '1'; op_alu <= "011010";
			when "011110" => branch_op <= '1'; op_alu <= "011011";
			when "100110" => branch_op <= '1'; op_alu <= "011100";
			when "101110" => branch_op <= '1'; op_alu <= "011101";
			when "110110" => branch_op <= '1'; op_alu <= "011110";
			when others => null;
			end case;
		end if;
	
	end process;
	
	dff : process(clk, reset_n)
	begin
	if (reset_n = '0') then
	current_state <= FETCH1;
	elsif (rising_edge(clk)) then
	current_state <= next_state;
	end if;
	end process;
end synth;
