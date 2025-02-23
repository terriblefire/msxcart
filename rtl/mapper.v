
/*	clocks.v

	Copyright (c) 2023, Stephen J. Leary
	All rights reserved.

	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
		 * Redistributions of source code must retain the above copyright
			notice, this list of conditions and the following disclaimer.
		 * Redistributions in binary form must reproduce the above copyright
			notice, this list of conditions and the following disclaimer in the
			documentation and/or other materials provided with the distribution.
		 * Neither the name of the Stephen J. Leary nor the
			names of its contributors may be used to endorse or promote products
			derived from this software without specific prior written permission.

	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
	DISCLAIMED. IN NO EVENT SHALL STEPHEN J. LEARY BE LIABLE FOR ANY
	DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
	ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
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