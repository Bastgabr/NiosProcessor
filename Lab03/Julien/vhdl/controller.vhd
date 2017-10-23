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
	type state_type is (FETCH1, FETCH2, DECODE, STORE, I_OP, R_OP, LOAD1, LOAD2, BREAK, BRANCH, CALL, JUMP, IR_OP, UI_OP, SHIFT);
	signal current_state, next_state : state_type;
	begin

	transition_logic :process(current_state, op, opx) 
		begin
		case current_state is 
			when FETCH1 => next_state <= FETCH2;
			when FETCH2 => next_state <= DECODE;
			when DECODE => if (op = "111010" and opx = "110100") then next_state <= BREAK;
				  elsif (op = "111010") then next_state <= R_OP;
				  elsif (op = "010111") then next_state <= LOAD1;
				  elsif (op = "010101") then next_state <= STORE;
				  elsif( op(2 downto 0) = "110") then next_state <= BRANCH;
				  elsif (op = "000000") then next_state <= CALL;
				--  elsif (op(5 downto 4) = "10") then next_state <= IR_OP;
				  else next_state <= I_OP;
				  end if;
			when BREAK => next_state <= BREAK;
			when LOAD1 => next_state <= LOAD2; 
			when others => next_state <= FETCH1;
		end case;		  
		end process;

	alu_logic: process(op, opx)
	begin	
	op_alu <= (others => '0');
		if (op = "111010") then -- R_TYPE
			case opx(2 downto 0) is 
				when "110" => op_alu <= "100" & opx(5 downto 3);
				when "000" => op_alu <= "011" & opx(5 downto 3);
				when "001" => if (op(5 downto 2) = "110") then op_alu <= "000" & opx(5 downto 3);
							else op_alu <= "001" & opx(5 downto 3); 
						end if;
				when "011"|"010" => op_alu <= "110" & opx(5 downto 3);
				when others => op_alu <= (others => '0');
				end case;
		elsif (op = "000110") then op_alu <= "011100"; --unconditionnal branch
		else case op(2 downto 0) is -- I_TYPE
			when "100" => if (op(5 downto 3) = "000") then 
						op_alu <= (others => '0'); 
				      else op_alu <= "100" & op(5 downto 3); 
				      end if;
			when "110" => op_alu <= "011" & op(5 downto 3);
			when others => null;
			end case;
		end if;
	end process;

	signal_logic: process(current_state, op, opx) begin
		ir_en <= '0'; branch_op <= '0';
		pc_add_imm <= '0'; pc_en <= '0'; pc_sel_a <= '0'; pc_sel_imm <= '0';
		rf_wren <= '0'; sel_addr <= '0'; sel_b <= '0'; sel_mem <= '0'; sel_pc <= '0'; sel_ra <= '0'; sel_rC <= '0';
		read <= '0'; write <= '0';

		case current_state is 
			when FETCH1 => read <= '1';
			when FETCH2 => ir_en <= '1'; pc_en <= '1';
			when I_OP => rf_wren <= '1';
			when R_OP => sel_b <= '1'; sel_rC <= '1'; rf_wren <= '1';
			when STORE => write <= '1'; sel_addr <= '1';
			when BREAK => rf_wren <= '0'; ir_en <= '0'; pc_en <= '0';
			when LOAD1 => read <= '1'; sel_addr <= '1';
			when LOAD2 => sel_mem <= '1'; sel_rC <= '0'; rf_wren <= '1';
			when BRANCH => branch_op <= '1';
			when CALL => pc_sel_imm <= '1';
			when JUMP => pc_en <= '1'; pc_sel_a <= '1';
			when IR_OP => imm_signed <= '0'; sel_b <= '0';
			when others => null;
		end case;		  
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
