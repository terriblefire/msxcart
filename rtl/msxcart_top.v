/*	msxcart_top.v

	Copyright (C) 2021-2025 Stephen J. Leary

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
