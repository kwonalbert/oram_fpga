
//==============================================================================
//	Section:	Includes
//==============================================================================
`include "Const.vh"
//==============================================================================

`timescale		1 ns/1 ps		// Display things in ns, compute them in ps

//==============================================================================
//	Module:		testORAMSystem
//	Desc:		Tests TinyORAMCore, DDR3SDRAM_mig7, and TrafficGen.
//==============================================================================
module testORAMSystem;
	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------

	// We need to declare these to make the local.vh files happy
	// NOTE: we don't want to pass params to CUT ... we want this to simulate 
	// TinyORAMTop.v as accurately as possible
	parameter				ORAML = 				cut.oram.ORAML;
	parameter				ORAMB = 				cut.oram.ORAMB;
	parameter				ORAMU =					cut.oram.ORAMU;
	parameter				FEDWidth =				cut.oram.FEDWidth;
	parameter               BEDWidth =              cut.oram.BEDWidth;
	parameter               EnableIV =              cut.oram.EnableIV;
	parameter               EnableAES =             cut.oram.EnableAES;
	
	`include "CommandsLocal.vh"
	`include "TrafficGenLocal.vh"

	localparam				Freq =				200_000_000,
							Cycle = 			1000000000/Freq;	
	
	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------	
	
	reg						sys_rst;
	wire					sys_clk_p, sys_clk_n;
	wire					uart_txd, uart_rxd;
	
	wire	[UARTWidth-1:0]	UARTDataIn;
	wire					UARTDataInValid, UARTDataInReady;
	
	wire	[TimeWidth-1:0]	CmdCount;
	wire	[THPWidth-1:0]	UARTShftDataIn;
	wire					UARTShftDataInValid, UARTShftDataInReady;
	
	wire	[UARTWidth-1:0]	UARTDataOut;
	wire					UARTDataOutValid, UARTDataOutReady;
	
	wire	[DBaseWidth-1:0] RecvData;
	wire					RecvDataValid;

	reg		[31:0]			InitWait = 0;
	reg						Start = 1'b0;
	
	//--------------------------------------------------------------------------
	//	Clocking & Reset
	//--------------------------------------------------------------------------

	ClockSource #(Freq) ClockF200Gen(.Enable(1'b1), .Clock(sys_clk_p));
	assign	sys_clk_n = 							~sys_clk_p;

	initial begin
		sys_rst = 1'b1;
		#(Cycle*150);
		sys_rst = 1'b0;
	end

	//--------------------------------------------------------------------------
	//	Send commands
	//--------------------------------------------------------------------------

	always @(posedge sys_clk_p) begin
		InitWait <= InitWait + 1;
		if (InitWait == 250) Start <= 1'b1;
	end
	
	Counter		#(			.Width(					TimeWidth))
				rd_ret_cnt(	.Clock(					sys_clk_p),
							.Reset(					sys_rst),
							.Set(					1'b0),
							.Load(					1'b0),
							.Enable(				UARTShftDataInValid & UARTShftDataInReady),
							.In(					{TimeWidth{1'bx}}),
							.Count(					CmdCount));
							
													// CRUD Format:			Cmd   					PAddr			DataBase			TimeDelay
													// Seed Format:			Cmd						Seed			AccessCount			Offset
	assign	UARTShftDataIn =						(CmdCount == 0) ? 	{	TCMD_Fill,				32'd0,			32'd100,			32'd0} :
													(CmdCount == 1) ? 	{	TCMD_CmdLin_AddrLin,	32'd0,			32'd100,			32'd0} :
													(CmdCount == 2) ? 	{	TCMD_CmdRnd_AddrLin,	32'd0,			32'd100,			32'd0} :
													(CmdCount == 3) ? 	{	TCMD_CmdLin_AddrRnd,	32'd1,			32'd100,			32'd0} :
													(CmdCount == 4) ? 	{	TCMD_CmdRnd_AddrRnd, 	32'd2, 			32'd100, 			32'd0} :
																		{	TCMD_Start, 			32'd0,	 		32'd0,	 			32'd0};

	assign	UARTShftDataInValid =					Start & CmdCount < 6;
	
	FIFOShiftRound #(		.IWidth(				THPWidth),
							.OWidth(				UARTWidth),
							.Reverse(				1))
				uart_I_shft(.Clock(					sys_clk_p),
							.Reset(					sys_rst),
							.InData(				UARTShftDataIn),
							.InValid(				UARTShftDataInValid),
							.InAccept(				UARTShftDataInReady),
							.OutData(				UARTDataIn),
							.OutValid(				UARTDataInValid),
							.OutReady(				UARTDataInReady));
	
	UART		#(			.ClockFreq(				200_000_000), // this much match sys_clk_p freq
							.Baud(					UARTBaud),
							.Width(					UARTWidth))
				uart(		.Clock(					sys_clk_p), 
							.Reset(					sys_rst), 
							.DataIn(				UARTDataIn), 
							.DataInValid(			UARTDataInValid), 
							.DataInReady(			UARTDataInReady), 
							.DataOut(				UARTDataOut), 
							.DataOutValid(			UARTDataOutValid), 
							.DataOutReady(			UARTDataOutReady), 
							.SIn(					uart_txd), 
							.SOut(					uart_rxd));
				
	FIFOShiftRound #(		.IWidth(				UARTWidth),
							.OWidth(				DBaseWidth))
				uart_O_shft(.Clock(					sys_clk_p),
							.Reset(					sys_rst),
							.InData(				UARTDataOut),
							.InValid(				UARTDataOutValid),
							.InAccept(				UARTDataOutReady),
							.OutData(				RecvData),
							.OutValid(				RecvDataValid),
							.OutReady(				1'b1));		
				
	always @(posedge sys_clk_p) begin
		if (RecvDataValid)
			$display("[%m @ %t] Received data = %x", $time, RecvData);
	end
	
	//--------------------------------------------------------------------------
	//	Circuit under test
	//--------------------------------------------------------------------------
	
	TinyORAMTop_vc707 cut(	.sys_clk_p(				sys_clk_p),
							.sys_clk_n(				sys_clk_n),

							.sys_rst(				sys_rst),

							.uart_txd(				uart_txd),
							.uart_rxd(				uart_rxd));

	//--------------------------------------------------------------------------
endmodule
//--------------------------------------------------------------------------
