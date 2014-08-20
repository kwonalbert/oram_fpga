//==============================================================================
//	File:		$URL: svn+ssh://repositorypub@repository.eecs.berkeley.edu/public/Projects/GateLib/branches/dev/Firmware/DRAM/Hardware/SynthesizedDRAM/SynthesizedDRAM.v $
//	Version:	$Revision: 26904 $
//	Author:		Greg Gibeling (http://www.gdgib.com)
//	Copyright:	Copyright 2005-2010 UC Berkeley
//==============================================================================

//==============================================================================
//	Section:	License
//==============================================================================
//	Copyright (c) 2005-2010, Regents of the University of California
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without modification,
//	are permitted provided that the following conditions are met:
//
//		- Redistributions of source code must retain the above copyright notice,
//			this list of conditions and the following disclaimer.
//		- Redistributions in binary form must reproduce the above copyright
//			notice, this list of conditions and the following disclaimer
//			in the documentation and/or other materials provided with the
//			distribution.
//		- Neither the name of the University of California, Berkeley nor the
//			names of its contributors may be used to endorse or promote
//			products derived from this software without specific prior
//			written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//	ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//	WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
//	ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//	(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//	LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
//	ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//	(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//	SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//==============================================================================

//==============================================================================
//	Includes
//==============================================================================
`include "Const.vh"
//==============================================================================

//------------------------------------------------------------------------------
//	Module:		SynthesizedDRAM
//	Desc:		This is a general synthesized RAM implementation of the DRAM
//				interface.  The RAM module upon which it is based it more
//				flexible and can have more ports, so this implementation of the
//				DRAM interface is intended primarily for testing, verification
//				and compatibility purposes.
//
//	Params:		UWidth:	The maskabale and addressable unit of memory.  Typically
//						this would be 8b for normal DRAM based designs, but it is
//						variable for this module.
//				AWidth:	The width of the CommandAddress input, which determines
//						the amount of addressable memory.  There are
//						(2^AWidth) * UWidth total bits of memory.
//				DWidth:	The width of the data input and output.  Note that
//						this may be smaller than a single burst transfer.
//				BurstLen: The number of DWidth wide words per DRAM operation.
//				Class1:	Should this implementation use class1 FIFO interfaces?
//						This will reduce the memory bandwidth to 50% when
//						reading, as the inputs must be registered in a FIFO to
//						accomplish this.
//	Author:		<a href="http://www.gdgib.com/">Greg Gibeling</a>
//	Version:	$Revision: 26904 $
//------------------------------------------------------------------------------
module	SynthesizedRandDRAM(
			//------------------------------------------------------------------
			//	System I/O
			//------------------------------------------------------------------
			Clock,
			Reset,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Status Outputs
			//------------------------------------------------------------------
			Initialized,
			PoweredUp,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Command Interface
			//------------------------------------------------------------------
			CommandAddress,
			Command,
			CommandValid,
			CommandReady,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Data Input (Write) Interface
			//------------------------------------------------------------------
			DataIn,
			DataInMask,
			DataInValid,
			DataInReady,
			//------------------------------------------------------------------
	
			//------------------------------------------------------------------
			//	Data Output (Read) Interface
			//------------------------------------------------------------------
			DataOut,
			DataOutErrorChecked,
			DataOutErrorCorrected,
			DataOutValid,
			DataOutReady
			//------------------------------------------------------------------
		);
	//--------------------------------------------------------------------------
	//	Per-Instance Constants
	//--------------------------------------------------------------------------
	parameter		    InBufDepth =            6,
						InDataBufDepth =		16,
	                    OutInitLat =            30,    // model dram latency
	                    OutBandWidth =          79,    // percent
	                         
                        UWidth =				9, // 9b units matches XCV5 BRAM
                        AWidth =				12,	// 36Kb
                        DWidth =				UWidth, // 9b transfers
                        BurstLen =				1,	// 9b total burst
                        EnableMask =			1,
                        Class1 =				1,
                        RLatency =				1,
                        WLatency =				1;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Fixed Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
	localparam				UCount =				DWidth / UWidth,
							MWidth =				EnableMask ? UCount : 0, // Per-unit (byte) masks
							CommandMask =			7'b0000011, // Read & Write only
							ECheck =				0,	// No error checking
							ECorrect =				0,	// No error correction
							EHWidth =				`max(`log2(ECheck+1), 1),
							ERWidth =				`max(`log2(ECorrect+1), 1);
	`endif
	`include "DRAM.constants"
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Internal Constants
	//--------------------------------------------------------------------------
	`ifdef MACROSAFE
		localparam			UAWidth =				`log2(UCount-1), // Unused lower address bits
							BCWidth =				`log2(BurstLen),
	`else
		localparam			UAWidth =				UCount,
							BCWidth =				BurstLen,
	`endif
							RAWidth =				AWidth-UAWidth;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	input					Clock, Reset;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Status Outputs
	//--------------------------------------------------------------------------
	output					Initialized;
	output					PoweredUp;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Command Interface
	//--------------------------------------------------------------------------
	input	[AWidth-1:0]	CommandAddress;
	input	[DRAMCMD_CWidth-1:0] Command;
	input					CommandValid;
	output					CommandReady;
	
	//--------------------------------------------------------------------------
	//	Data Input (Write) Interface
	//--------------------------------------------------------------------------
	input	[DWidth-1:0]	DataIn;
	input	[MWidth-1:0]	DataInMask;
	input					DataInValid;
	output					DataInReady;
	//--------------------------------------------------------------------------
	
	//--------------------------------------------------------------------------
	//	Data Output (Read) Interface
	//--------------------------------------------------------------------------
	output	[DWidth-1:0]	DataOut;
	output	[EHWidth-1:0]	DataOutErrorChecked;
	output	[ERWidth-1:0]	DataOutErrorCorrected;
	output					DataOutValid;
	input					DataOutReady;
	//--------------------------------------------------------------------------
    
    //--------------------------------------------------------------------------
    //	Internal signals
    //--------------------------------------------------------------------------
    wire	[AWidth-1:0]	CommandAddress_Internal;
    wire	[DRAMCMD_CWidth-1:0] Command_Internal;
    wire					CommandValid_Internal;
    wire					CommandReady_Internal;
    
    wire	[DWidth-1:0]	DataIn_Internal;
    wire	[MWidth-1:0]	DataInMask_Internal;
    wire					DataInValid_Internal;
    wire					DataInReady_Internal;
    
    wire	[DWidth-1:0]	DataOut_Internal;
    wire	[EHWidth-1:0]	DataOutErrorChecked_Internal;
    wire	[ERWidth-1:0]	DataOutErrorCorrected_Internal;
    wire					DataOutValid_Internal;
    wire					DataOutReady_Internal;
		
    FIFORAM	#(				.Width(					DRAMCMD_CWidth + AWidth),
                            .Buffering(				InBufDepth))
                cmd_buf(	.Clock(					Clock),
                            .Reset(					Reset),
                            .InData(				{Command, CommandAddress}),
                            .InValid(				CommandValid),
                            .InAccept(				CommandReady),
                            .OutData(				{Command_Internal, CommandAddress_Internal}),
                            .OutSend(				CommandValid_Internal),
                            .OutReady(				CommandReady_Internal));	

    FIFORAM	#(				.Width(					DWidth + MWidth),
                            .Buffering(				InDataBufDepth))
                din_buf(	.Clock(					Clock),
                            .Reset(					Reset),
                            .InData(				{DataIn, DataInMask}),
                            .InValid(				DataInValid),
                            .InAccept(				DataInReady),
                            .OutData(				{DataIn_Internal, DataInMask_Internal}),
                            .OutSend(				DataInValid_Internal),
                            .OutReady(				DataInReady_Internal));	

    			
    SynthesizedDRAM	#(		.UWidth(				UWidth),
                            .AWidth(				AWidth),
                            .DWidth(				DWidth),
                            .BurstLen(				BurstLen), 
                            .EnableMask(			EnableMask),
                            .Class1(				Class1),
                            .RLatency(				RLatency),
                            .WLatency(				WLatency)) 
             synth_dram(	.Clock(					Clock),
                            .Reset(					Reset),

                            .Initialized(			Initialized),
                            .PoweredUp(				PoweredUp),

                            .CommandAddress(		CommandAddress_Internal),
                            .Command(				Command_Internal),
                            .CommandValid(			CommandValid_Internal),
                            .CommandReady(			CommandReady_Internal),

                            .DataIn(				DataIn_Internal),
                            .DataInMask(			DataInMask_Internal),
                            .DataInValid(			DataInValid_Internal),
                            .DataInReady(			DataInReady_Internal),

                            .DataOut(				DataOut_Internal),
                            .DataOutErrorChecked(	DataOutErrorChecked_Internal),
                            .DataOutErrorCorrected(	DataOutErrorCorrected_Internal),
                            .DataOutValid(			DataOutValid_Internal),
                            .DataOutReady(			DataOutReady_Internal)
                );
	
    wire        Stall, DataOutValid_Rand, DataOutReady_Rand;
    reg  [7:0]  RandModulator;
	
    FIFORAM #(				.Width(					DWidth + EHWidth + ERWidth),
							.FWLatency(				OutInitLat),
							.Buffering(				2 * OutInitLat))
                dout_buf(	.Clock(					Clock),
                			.Reset(					Reset),
                			.InData(				{DataOut_Internal, 	DataOutErrorChecked_Internal, 	DataOutErrorCorrected_Internal}),
                			.InValid(				DataOutValid_Internal),
                			.InAccept(				DataOutReady_Internal),
                			.OutData(				{DataOut, 			DataOutErrorChecked, 			DataOutErrorCorrected}),
                			.OutSend(				DataOutValid_Rand),
                			.OutReady(				DataOutReady_Rand));	
	
 
    
    always @ (posedge Clock)
        RandModulator <= $random % 100;
	
	assign Stall = RandModulator > OutBandWidth;
	assign DataOutValid = DataOutValid_Rand && !Stall;
	assign DataOutReady_Rand = DataOutReady && !Stall;
	
endmodule
//------------------------------------------------------------------------------
