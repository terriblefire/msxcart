/*	bus_term.v

	Copyright (c) 2021, Stephen J. Leary
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

module msxcart_top(

    // clocks
    input  SLOTCLK, 
    input  RESET, 
    input  [7:0] D,
    input  [15:12] A,

    input   EXSLTSL, 

    input   RD, 
    input   WR, 
    input   MREQ, 
    input   IORQ,  
    input   M1, 
    input   RFSH,
    input   BDIR, 

    input   [1:0] SW, 

    // rom interface 
    output  [18:12] ROMA, 
    output  ROMOE 
);

wire page0_n = A[15:14] != 2'b00; // 0x0000 to 0x3FFF
wire page1_n = A[15:14] != 2'b01; // 0x4000 to 0x7FFF
wire page2_n = A[15:14] != 2'b10; // 0x8000 to 0xBFFF
wire page3_n = A[15:14] != 2'b11; // 0xC000 to 0xFFFF


mapper MAPPER (  

    .SLOTCLK    ( SLOTCLK   ),
    .RESET      ( RESET     ), 
    .A          ( A         ),
    .D          ( D         ),

    .BDIR       ( BDIR      ),
    .RD		    ( RD 		),
	.WR 	    ( WR 		),
    .MREQ       ( MREQ      ),
    .IORQ       ( IORQ      ),
    .RFSH       ( RFSH      ),
    .M1         ( M1        ),
    .EXSLTSLX   ( EXSLTSL   ),

    .ROMA       ( ROMA[16:13] )

);

assign ROMA[12] = A[12];
assign ROMA[18:17] = 2'b00;

assign ROMOE = MREQ | RD | EXSLTSL;

endmodule
