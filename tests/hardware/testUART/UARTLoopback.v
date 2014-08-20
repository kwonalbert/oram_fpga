
//==============================================================================
//	Section:	Includes
//==============================================================================
`include "Const.vh"
//==============================================================================

//==============================================================================
//	Module:		UARTLoopback
//	Desc:		Simple board-independent UART loopback test that displays the 
//				character last typed on (perhaps) some GPIO LEDs.
//==============================================================================
module UARTLoopback(
  	Clock, Reset,

	UARTTX,	UARTRX,
	LastWord
	);
	
	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------

	parameter				Width =					8,
`ifdef SIMULATION
							Baud =					1500000;
`else
							Baud =					9600;
`endif
	
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
		
  	input 					Clock, Reset;

	//--------------------------------------------------------------------------
	//	UART/status interface
	//-------------------------------------------------------------------------- 

	output					UARTTX;
	input					UARTRX;
	
	output	[Width-1:0]		LastWord;
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//-------------------------------------------------------------------------- 

    (* mark_debug = "TRUE" *) wire	[Width-1:0]			Data;
    (* mark_debug = "TRUE" *) wire						DataValid;
    (* mark_debug = "TRUE" *) wire  					DataReady;

	//--------------------------------------------------------------------------
	//	Loopback core
	//-------------------------------------------------------------------------- 
	
    UART		#(			.ClockFreq(				200000000),
							.Baud(					Baud),
							.Width(					Width),
							.Parity(				0),
							.StopBits(				1))
				uart(		.Clock(					Clock),
							.Reset(					Reset),
							.DataIn(				Data),
							.DataInValid(			DataValid),
							.DataInReady(			DataReady),
							.DataOut(				Data),
							.DataOutValid(			DataValid),
							.DataOutReady(			DataReady),
							.SIn(					UARTRX),
							.SOut(					UARTTX));			
		
	Register	#(			.Width(					Width))
				led_dis(	.Clock(					Clock),
							.Reset(					Reset),
							.Set(					1'b0),
							.Enable(				DataValid && DataReady),
							.In(					Data),
							.Out(					LastWord));	
		
	//--------------------------------------------------------------------------
endmodule
//--------------------------------------------------------------------------
