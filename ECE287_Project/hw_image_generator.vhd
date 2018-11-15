--------------------------------------------------------------------------------
--
--   FileName:         hw_image_generator.vhd
--   Dependencies:     none
--   Design Software:  Quartus II 64-bit Version 12.1 Build 177 SJ Full Version
--
--   HDL CODE IS PROVIDED "AS IS."  DIGI-KEY EXPRESSLY DISCLAIMS ANY
--   WARRANTY OF ANY KIND, WHETHER EXPRESS OR IMPLIED, INCLUDING BUT NOT
--   LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
--   PARTICULAR PURPOSE, OR NON-INFRINGEMENT. IN NO EVENT SHALL DIGI-KEY
--   BE LIABLE FOR ANY INCIDENTAL, SPECIAL, INDIRECT OR CONSEQUENTIAL
--   DAMAGES, LOST PROFITS OR LOST DATA, HARM TO YOUR EQUIPMENT, COST OF
--   PROCUREMENT OF SUBSTITUTE GOODS, TECHNOLOGY OR SERVICES, ANY CLAIMS
--   BY THIRD PARTIES (INCLUDING BUT NOT LIMITED TO ANY DEFENSE THEREOF),
--   ANY CLAIMS FOR INDEMNITY OR CONTRIBUTION, OR OTHER SIMILAR COSTS.
--
--   Version History
--   Version 1.0 05/10/2013 Scott Larson
--     Initial Public Release
--    
--------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY hw_image_generator IS
	GENERIC(
		lane1_s : INTEGER := 608;
		lane1_e : INTEGER := 656;
		lane2_s : INTEGER := 1264;
		lane2_e : INTEGER := 1312;
		carwidth_s : INTEGER := 202;
		carwidth_e : INTEGER := 405;
		carlength_s : INTEGER := 760;
		carlength_e : INTEGER := 1030);   --column that first color will persist until
	PORT(
		button_left :  IN		STD_LOGIC;
		button_right : IN		STD_LOGIC;
		disp_ena		:	IN		STD_LOGIC;	--display enable ('1' = display time, '0' = blanking time)
		row			:	IN		INTEGER;		--row pixel coordinate
		column		:	IN		INTEGER;		--column pixel coordinate
		red			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --red magnitude output to DAC
		green			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0');  --green magnitude output to DAC
		blue			:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0) := (OTHERS => '0')); --blue magnitude output to DAC
END hw_image_generator;

ARCHITECTURE behavior OF hw_image_generator IS
SIGNAL carstate : STD_LOGIC_VECTOR(0 to 1);
BEGIN
	PROCESS(disp_ena, row, column, button_left, button_right)
	BEGIN

		IF(disp_ena = '1') THEN		--display time
			IF (row > lane1_s AND row < lane1_e) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF (row > lane2_s AND row < lane2_e) THEN
				red <= (OTHERS => '1');
				green	<= (OTHERS => '1');
				blue <= (OTHERS => '1');
			ELSIF (button_left = '0' AND button_right = '1' AND row > carwidth_s AND row < carwidth_e AND column > carlength_s AND column < carlength_e) THEN
				red <= ("00110011");
				green	<= ("10011001");
				blue <= ("00110011");
				carstate <= "00";
			ELSIF (button_left = '1' AND button_right = '1' AND row > (carwidth_s + 658) AND row < (carwidth_e + 658) AND column > carlength_s AND column < carlength_e) THEN
				red <= ("00110011");
				green	<= ("10011001");
				blue <= ("00110011");
				carstate <= "01";
			ELSIF (button_left = '0' AND button_right = '0' AND row > (carwidth_s + 658) AND row < (carwidth_e + 658) AND column > carlength_s AND column < carlength_e) THEN
				red <= ("00110011");
				green	<= ("10011001");
				blue <= ("00110011");
				carstate <= "01";
			ELSIF (button_left = '1' AND button_right = '0' AND row > (carwidth_s + 1316) AND row < (carwidth_e + 1316) AND column > carlength_s AND column < carlength_e) THEN
				red <= ("00110011");
				green	<= ("10011001");
				blue <= ("00110011");
				carstate <= "10";
			ELSE
				red <= (OTHERS => '0');
				green	<= (OTHERS => '0');
				blue <= (OTHERS => '0');
			END IF;
		ELSE								--blanking time
			red <= (OTHERS => '0');
			green <= (OTHERS => '0');
			blue <= (OTHERS => '0');
		END IF;
	
	END PROCESS;
END behavior;