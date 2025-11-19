/*	mapper.v

	Copyright (C) 2023-2025 Stephen J. Leary

	This file is part of MSX Cartridge (msxcart).

	MSX Cartridge is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	MSX Cartridge is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with MSX Cartridge.  If not, see <http://www.gnu.org/licenses/>.
*/

module mapper (

	// z80 bus interface
	input  			SLOTCLK, // CLKSLOT is 1/8th Master clock 
	input 			RESET,
	
	input	[15:12]	A,
    input   [7:0] 	D,

	input   		RD, 
    input  			WR, 
    
    input   		MREQ, 
    input   		IORQ, 
    input   		M1, 
    input   		RFSH,

    input   		BDIR, 

	// select lines
    input   		EXSLTSLX,

	// CART Specific lines 

	output [16:13]  ROMA 
);

reg [3:0] slot_register_1 = 1;
reg [3:0] slot_register_2 = 2;
reg [3:0] slot_register_3 = 3;

wire page0_n = EXSLTSLX | A[14:13] != 2'b10; // 0x4000 to 0x5FFF | 0xC000 to 0xDFFF
wire page1_n = EXSLTSLX | A[14:13] != 2'b11; // 0x6000 to 0x7FFF | 0xE000 to 0xFFFF
wire page2_n = EXSLTSLX | A[14:13] != 2'b00; // 0x0000 to 0x1FFF | 0x8000 to 0x9FFF
wire page3_n = EXSLTSLX | A[14:13] != 2'b01; // 0x2000 to 0x3FFF | 0xA000 to 0xBFFF

wire slot1_write = page1_n | WR | MREQ | ~M1; 
wire slot2_write = page2_n | WR | MREQ | ~M1;
wire slot3_write = page3_n | WR | MREQ | ~M1;

always @(posedge SLOTCLK) begin 

	if (RESET == 1'b0) begin 
	
		slot_register_1 <= 4'd1;
	
	end else begin 

		if (slot1_write == 1'b0) begin 

			slot_register_1 <= D[3:0];
	
		end

		if (slot2_write == 1'b0) begin 

			slot_register_2 <= D[3:0];
	
		end

		if (slot3_write == 1'b0) begin 

			slot_register_3 <= D[3:0];
	
		end

	end	

end

assign ROMA =   !page0_n ? 4'b0 :
			    !page1_n ? slot_register_1 :
			    !page2_n ? slot_register_2 : 
				  		   slot_register_3;
	
endmodule