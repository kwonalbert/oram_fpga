
//==============================================================================
//	Section:	Includes
//==============================================================================
`include "Const.vh"
//==============================================================================

//==============================================================================
//	Module:		TrafficGen
//	Desc:		Connect to a software routine, running on a host machine, which 
//				can send address requests directly to an attached DRAM/ORAM
//==============================================================================
module TrafficGen(
  	Clock, Reset,

	ORAMCommand, ORAMPAddr,
	ORAMCommandValid, ORAMCommandReady,
	
	ORAMDataIn, ORAMDataInValid, ORAMDataInReady,
	ORAMDataOut, ORAMDataOutValid, ORAMDataOutReady,
	
	UARTRX, UARTTX,
	
	HWHistogramDump,
	
	ErrorReceiveOverflow, ErrorReceivePattern, ErrorSendOverflow
	);
	
	//--------------------------------------------------------------------------
	//	Constants
	//-------------------------------------------------------------------------- 

	`include "PathORAM.vh"
	
	parameter				ClockFreq =				100_000_000;
	
	// Internal buffering for traffic gen FIFOs
	parameter				Buffering =				1024;
							
	// Should the test harness return confirmations that accesses completed 
	// (=0), or should it generate a histogram of access latencies (=1)?
	parameter				GenHistogram =			1;
							
	parameter				StallThreshold =		10000;

	parameter				NumValidBlock =			1 << ORAML;
							
	`include "CommandsLocal.vh"
	`include "TrafficGenLocal.vh"
	
	localparam				NVWidth =				`log2(NumValidBlock);
	
	localparam				OBUChunks = 			ORAMB / ORAMU;
	
	localparam				BlkSize_UARTChunks = 	ORAMB / UARTWidth;
	localparam				BlkUARTWidth =			`log2(BlkSize_UARTChunks);	
							
	//--------------------------------------------------------------------------
	//	System I/O
	//--------------------------------------------------------------------------
	
  	input 					Clock;
	input					Reset;

	//--------------------------------------------------------------------------
	//	CUT (ORAM) interface
	//--------------------------------------------------------------------------

	output	[BECMDWidth-1:0] ORAMCommand;
	output	[ORAMU-1:0]		ORAMPAddr;
	output					ORAMCommandValid;
	input					ORAMCommandReady;
	
	output	[FEDWidth-1:0]	ORAMDataIn;
	output					ORAMDataInValid;
	input					ORAMDataInReady;
	
	input	[FEDWidth-1:0]	ORAMDataOut;
	input					ORAMDataOutValid;
	output					ORAMDataOutReady;
	
	//--------------------------------------------------------------------------
	//	HW<->SW interface
	//--------------------------------------------------------------------------

	input					UARTRX;
	output					UARTTX;
	
	//--------------------------------------------------------------------------
	//	Status interface
	//--------------------------------------------------------------------------
	
	input					HWHistogramDump;
	
	output					ErrorReceiveOverflow;
	output					ErrorReceivePattern;
	output					ErrorSendOverflow;
	
	//------------------------------------------------------------------------------
	// 	Wires & Regs
	//------------------------------------------------------------------------------
	
	// Receive pipeline

	(* mark_debug = "FALSE" *)	wire	[ORAMB-1:0] 	DataOutActual, DataOutExpected, DataOutExpectedPre, DataInWide;
	(* mark_debug = "FALSE" *)	wire					DataOutActualValid, DataOutExpectedValid;
	
	(* mark_debug = "TRUE" *)	wire					ERROR_MismatchReceivePattern;

	// UART
	
	(* mark_debug = "FALSE" *)	wire	[UARTWidth-1:0]	UARTDataIn;
	(* mark_debug = "FALSE" *)	wire					UARTDataInValid, UARTDataInReady;

	(* mark_debug = "FALSE" *)	wire	[UARTWidth-1:0] UARTDataOut;
	(* mark_debug = "FALSE" *)	wire					UARTDataOutValid, UARTDataOutReady;
	
	// Send pipeline
	
	wire	[THPWidth-1:0]	UARTDataOut_Wide;
	wire					UARTDataOutValid_Wide, UARTDataOutReady_Wide;	
	
	(* mark_debug = "FALSE" *)	wire	[THPWidth-1:0] 	CrossBufIn_DataIn;
	(* mark_debug = "FALSE" *)	wire					CrossBufIn_DataInValid, CrossBufIn_DataInReady;	
	
	(* mark_debug = "FALSE" *)	wire	[TCMDWidth-1:0]	SendCommand;
	(* mark_debug = "FALSE" *)	wire	[ORAMU-1:0]	SendPAddr;
	(* mark_debug = "FALSE" *)	wire	[DBaseWidth-1:0] SendDataBase;
	(* mark_debug = "FALSE" *)	wire	[TimeWidth-1:0]	SendTimeDelay;
	
	(* mark_debug = "FALSE" *)	wire					TimeGate;
	(* mark_debug = "FALSE" *)	wire	[TimeWidth-1:0]	PacketAge;
	
	(* mark_debug = "FALSE" *)	wire					SWHistogramDump;
		
	(* mark_debug = "FALSE" *)	wire					ORAMRegInValid, ORAMRegInReady;
	(* mark_debug = "FALSE" *)	wire					ORAMRegOutValid, ORAMRegOutReady;
	
	(* mark_debug = "FALSE" *)	wire					ORAMCommandTransfer, ORAMDataInFunnelReady;	
	
	(* mark_debug = "FALSE" *)	wire	[DBaseWidth-1:0] ORAMDataBase;
	(* mark_debug = "FALSE" *)	wire	[TimeWidth-1:0]	ORAMTimeDelay;
	
	(* mark_debug = "FALSE" *)	wire					WriteCommandValid;

	//
	
	(* mark_debug = "FALSE" *)	wire					StartCounting, AccessInProgress, StopCounting, StopCounting_Delay;
	(* mark_debug = "FALSE" *)	wire	[HGAWidth-1:0]	AccessLatency, HistogramAddress;
	(* mark_debug = "FALSE" *)	wire					HistogramWrite;
	
	(* mark_debug = "FALSE" *)	wire	[DBaseWidth-1:0] ReceiveCrossDataIn;
	(* mark_debug = "FALSE" *)	wire					ReceiveCrossDataInValid, ReceiveCrossDataInReady;
	
	(* mark_debug = "FALSE" *)	wire	[DBaseWidth-1:0] HistogramInData, HistogramOutData;
	(* mark_debug = "FALSE" *)	wire					HistogramOutValid, HistogramOutReady;
	
	(* mark_debug = "FALSE" *)	wire	[HGAWidth-1:0]	DumpAddress;
	(* mark_debug = "FALSE" *)	wire					DumpHistogram;
			
	(* mark_debug = "FALSE" *)	wire	[DBaseWidth-1:0] ReceiveCrossDataOut;
	(* mark_debug = "FALSE" *)	wire					ReceiveCrossDataOutValid, ReceiveCrossDataOutReady;

	// Traffic generator
	
	localparam				STWidth =					2,
							ST_Idle =					2'd0,		
							ST_PrepSeed =				2'd1,
							ST_Seed =					2'd2,
							ST_Access =					2'd3;
	
	(* mark_debug = "FALSE" *)	wire	[THPWidth-1:0]	CrossBufIn_DataInPre;
	(* mark_debug = "TRUE" *)	wire					CrossBufIn_DataInValidPre, CrossBufIn_DataInReadyPre;
	
	(* mark_debug = "TRUE" *)	reg		[STWidth-1:0]	CS, NS;	
	(* mark_debug = "FALSE" *)	wire					CSAccess, CSSeed;
	
	(* mark_debug = "FALSE" *)	wire	[TCMDWidth-1:0]	SlowCommand;
	(* mark_debug = "FALSE" *)	wire	[ORAMU-1:0]		SlowAddress; 
	(* mark_debug = "FALSE" *)	wire	[DBaseWidth-1:0] SlowDataBase;
	(* mark_debug = "FALSE" *)	wire	[TimeWidth-1:0]	SlowTime;
	
	(* mark_debug = "TRUE" *)	wire	[TCMDWidth-1:0]	SeedCommand;
	(* mark_debug = "TRUE" *)	wire	[ORAMU-1:0]		SeedAddress;
	(* mark_debug = "TRUE" *)	wire	[DBaseWidth-1:0] SeedDataBase; 
	(* mark_debug = "TRUE" *)	wire	[TimeWidth-1:0]	SeedTime;
	
	(* mark_debug = "TRUE" *)	wire	[DBaseWidth-1:0] SeedAccessCount;
	
	(* mark_debug = "FALSE" *)	wire					ResetPRNG, PRNGOutValid;
	(* mark_debug = "FALSE" *)	wire	[ORAMU-1:0]		PRNGOutData;
	
	(* mark_debug = "FALSE" *)	wire	[ORAMU-1:0]		RandomAddress, ScanAddress, FillAddress;
	(* mark_debug = "FALSE" *)	wire	[TCMDWidth-1:0]	RandomCommand, ScanCommand, FillCommand;
	
	(* mark_debug = "TRUE" *)	wire					AccessHalfThresholdReached, AccessThresholdReached;
	
	(* mark_debug = "TRUE" *)	wire					CMD_RND, CMD_FILL;
	(* mark_debug = "TRUE" *)	wire					ADDR_RND, ADDR_FILL;	
	
	//------------------------------------------------------------------------------
	// 	Simulation checks
	//------------------------------------------------------------------------------	

	integer					StallCount, NumWriteSent, NumReadSent, NumReadReceived, CheckForStalls, StopGapPeriod;
	
	`ifdef SIMULATION
		initial begin
			StallCount = 0;
			NumWriteSent = 0;
			NumReadSent = 0;
			NumReadReceived = 0;
			CheckForStalls = 0;
			StopGapPeriod = 0;
			
			if (GenHistogram == 0) begin
				$display("[%m] ERROR: GenHistogram == 0 not supported anymore.");
				$finish;
			end
			
			if (ERROR_MismatchReceivePattern) begin
				$display("[%m] WARNING: Traffic gen data mismatch (%x != %x)", DataOutExpected, DataOutActual);
				if (DataOutActual != {(ORAMB/32){32'hdeaf1234}}) begin
					$finish;
				end
			end
		end
		
		always @(posedge Clock) begin
			if (ORAMDataOutValid) CheckForStalls = 1;
			if (DataOutActualValid) NumReadReceived = NumReadReceived + 1;
		
			if (DumpHistogram) StopGapPeriod = StopGapPeriod + 1;
			if (StopGapPeriod == StallThreshold) begin
				if (NumReadSent == NumReadReceived) begin
					$display("ALL TESTS PASSED");
					$finish;
				end else begin
					$display("[%m] ERROR: Test finished; received %d reads (expected %d)", NumReadReceived, NumReadSent);
					$finish;				
				end
			end
		
			if (ORAMCommandValid && ORAMCommandReady) begin
				StallCount = 0;
				
				if (ORAMCommand == TCMD_Update) NumWriteSent = NumWriteSent + 1;
				else							NumReadSent = NumReadSent + 1;
				
				$display("[%m @ %t] Traffic gen sent request: command=%x, addr=0x%x :: num writes = %d, num reads = %d", $time, ORAMCommand, ORAMPAddr, NumWriteSent, NumReadSent);
			end 
			else if (~ORAMCommandReady && CheckForStalls) begin
				StallCount = StallCount + 1;
				if (StallCount >= StallThreshold) begin
					$display("[%m] ERROR: ORAM has stalled.", $time);
					$finish;					
				end
			end
		end
	`endif
	
	//------------------------------------------------------------------------------
	// 	[Send/Receive path] HW<->SW Bridge (UART)
	//------------------------------------------------------------------------------	
	
	UART		#(			.ClockFreq(				ClockFreq),
							.Baud(					UARTBaud),
							.Width(					UARTWidth))
				uart(		.Clock(					Clock), 
							.Reset(					Reset), 
							.DataIn(				UARTDataIn), 
							.DataInValid(			UARTDataInValid), 
							.DataInReady(			UARTDataInReady), 
							.DataOut(				UARTDataOut), 
							.DataOutValid(			UARTDataOutValid), 
							.DataOutReady(			UARTDataOutReady), 
							.SIn(					UARTRX), 
							.SOut(					UARTTX));				
	
	FIFOShiftRound #(		.IWidth(				UARTWidth),
							.OWidth(				THPWidth),
							.Reverse(				1))
			tst_shift(		.Clock(					Clock),
							.Reset(					Reset),
							.InData(				UARTDataOut),
							.InValid(				UARTDataOutValid),
							.InAccept(				UARTDataOutReady),
							.OutData(				UARTDataOut_Wide),
							.OutValid(				UARTDataOutValid_Wide),
							.OutReady(				UARTDataOutReady_Wide));

	FIFORAM		#(			.Width(					THPWidth),
							.Buffering(				Buffering))
				send_fifo(	.Clock(					Clock),
							.Reset(					Reset),
							.InData(				UARTDataOut_Wide),
							.InValid(				UARTDataOutValid_Wide),
							.InAccept(				UARTDataOutReady_Wide),
							.OutData(				CrossBufIn_DataInPre),
							.OutSend(				CrossBufIn_DataInValidPre),
							.OutReady(				CrossBufIn_DataInReadyPre));	
	
	//------------------------------------------------------------------------------
	// 	[Send path] Hardware command generation
	//------------------------------------------------------------------------------
	
	initial begin
		CS = ST_Idle;
	end
	
	assign	AccessTransfer =						CrossBufIn_DataInValid & CrossBufIn_DataInReady;
	
	assign	CrossBufIn_DataInValid =				(CSAccess) ? 	CrossBufIn_DataInValidPre : 
													(CSSeed) ? 		PRNGOutValid : 1'b0;
	assign	CrossBufIn_DataInReadyPre =				(CSAccess) ? 	CrossBufIn_DataInReady : 
													(CSSeed) ? 		AccessThresholdReached : 1'b0;
	
	assign	ResetPRNG =								CS == ST_PrepSeed;
	
	assign	{SlowCommand, SlowAddress, SlowDataBase, SlowTime} = CrossBufIn_DataInPre;
		
	assign	CrossBufIn_DataIn =						(CSAccess) ? 	{SlowCommand, SlowAddress, SlowDataBase, SlowTime} : 
																	{SeedCommand, SeedAddress, SeedDataBase, SeedTime};

	assign	CSAccess =								CS == ST_Access;
	assign	CSSeed =								CS == ST_Seed;
	
	always @(posedge Clock) begin
		if (Reset) CS <= 						ST_Idle;
		else CS <= 									NS;
	end
	
	always @( * ) begin
		NS = 										CS;
		case (CS)
			ST_Idle : 
				if (CrossBufIn_DataInValidPre && (SlowCommand == TCMD_Update || SlowCommand == TCMD_Read || SlowCommand == TCMD_Start))
					NS =							ST_Access;
				else if (CrossBufIn_DataInValidPre)
					NS =							ST_PrepSeed;
			ST_PrepSeed :
				NS =								ST_Seed;
			ST_Seed :
				if (AccessThresholdReached)
					NS =							ST_Idle;
			ST_Access :
				if (AccessTransfer)
					NS =							ST_Idle;
		endcase
	end
	
	Counter		#(			.Width(					DBaseWidth))
				access_cnt(	.Clock(					Clock),
							.Reset(					Reset | AccessThresholdReached),
							.Set(					1'b0),
							.Load(					1'b0),
							.Enable(				CSSeed & AccessTransfer),
							.In(					{DBaseWidth{1'bx}}),
							.Count(					SeedAccessCount));					
	assign	AccessHalfThresholdReached =			SeedAccessCount >= (SlowDataBase >> 1);
	assign	AccessThresholdReached =				SeedAccessCount == SlowDataBase;

	PRNG 		#(			.RandWidth(				ORAMU))
				addr_gen(	.Clock(					Clock),
							.Reset(					Reset | ResetPRNG),
							.RandOutReady(			CSSeed & CrossBufIn_DataInReady),
							.RandOutValid(			PRNGOutValid),
							.RandOut(				PRNGOutData),
							.SecretKey(				{ {AESWidth-TimeWidth{1'b0}}, SlowAddress} ));

	assign	RandomAddress =							PRNGOutData;
	assign	ScanAddress =							((AccessHalfThresholdReached) ?  SeedAccessCount - (SlowDataBase >> 1) : SeedAccessCount) + SlowTime;
	assign	FillAddress =							SeedAccessCount;
	
	assign	RandomCommand =							(PRNGOutData[ORAMU-1]) ? TCMD_Update : TCMD_Read;
	assign	ScanCommand =							(AccessHalfThresholdReached) ? TCMD_Read : TCMD_Update;
	assign	FillCommand =							TCMD_Update;
	
	assign	CMD_RND =								SlowCommand == TCMD_CmdRnd_AddrLin || SlowCommand == TCMD_CmdRnd_AddrRnd;
	assign	CMD_FILL =								SlowCommand == TCMD_Fill;
	
	assign	ADDR_RND =								SlowCommand == TCMD_CmdLin_AddrRnd || SlowCommand == TCMD_CmdRnd_AddrRnd;
	assign	ADDR_FILL =								SlowCommand == TCMD_Fill;
	
	assign	SeedCommand =							(CMD_RND) ? 	RandomCommand : 
													(CMD_FILL) ? 	FillCommand :
																	ScanCommand;
																	
	assign	SeedAddress =							(ADDR_RND) ? 	RandomAddress[NVWidth-1:0] : 
													(ADDR_FILL) ? 	FillAddress[NVWidth-1:0] : 
																	ScanAddress[NVWidth-1:0]; 
	
	assign	SeedDataBase =							{DBaseWidth{1'b0}};
	assign	SeedTime =								{TimeWidth{1'b0}};
	
	assign	SWHistogramDump =						CSAccess && SlowCommand == TCMD_Start && CrossBufIn_DataInValid & CrossBufIn_DataInReady;
	
	//------------------------------------------------------------------------------
	// 	[Send path] Next command staging
	//------------------------------------------------------------------------------

	assign	{SendCommand, SendPAddr, SendDataBase, SendTimeDelay} =	CrossBufIn_DataIn;
	
	assign	ORAMRegInValid =						CrossBufIn_DataInValid & SendCommand != TCMD_Start;
	assign	CrossBufIn_DataInReady =				ORAMRegInReady;	
	
	FIFORegister #(			.Width(					BECMDWidth + ORAMU + DBaseWidth + TimeWidth))
				oram_freg(	.Clock(					Clock),
							.Reset(					Reset),
							.InData(				{SendCommand[BECMDWidth-1:0], 	SendPAddr, SendDataBase, SendTimeDelay}),
							.InValid(				ORAMRegInValid),
							.InAccept(				ORAMRegInReady),
							.OutData(				{ORAMCommand, 					ORAMPAddr, ORAMDataBase, ORAMTimeDelay}),
							.OutSend(				ORAMRegOutValid),
							.OutReady(				ORAMRegOutReady));

	//------------------------------------------------------------------------------
	// 	[Send path] Data generation & write gating
	//------------------------------------------------------------------------------		

	assign	WriteCommandValid =						ORAMRegOutValid & ((ORAMCommand == BECMD_Update) | (ORAMCommand == BECMD_Append));
		
	genvar i;
	generate for (i = 0; i < OBUChunks; i = i + 1) begin
		assign	DataInWide[(i+1)*ORAMU-1:i*ORAMU] = ORAMPAddr + i;
	end endgenerate			
		
	FIFOShiftRound #(		.IWidth(				ORAMB),
							.OWidth(				FEDWidth))
				I_dta_shft(	.Clock(					Clock),
							.Reset(					Reset),
							.InData(				DataInWide),
							.InValid(				ORAMCommandTransfer & WriteCommandValid),
							.InAccept(				ORAMDataInFunnelReady),
							.OutData(				ORAMDataIn),
							.OutValid(				ORAMDataInValid),
							.OutReady(				ORAMDataInReady));
							
	//------------------------------------------------------------------------------
	// 	[Send path] Time gating
	//------------------------------------------------------------------------------
					
	Counter		#(			.Width(					TimeWidth))
				time_cnt(	.Clock(					Clock),
							.Reset(					Reset | (TimeGate & ORAMCommandValid & ORAMCommandReady)),
							.Set(					1'b0),
							.Load(					1'b0),
							.Enable(				ORAMRegOutValid & ~TimeGate),
							.In(					{TimeWidth{1'bx}}),
							.Count(					PacketAge));
	assign	TimeGate =								(GenHistogram) ? 1'b1 : PacketAge >= ORAMTimeDelay;							
							
	assign	ORAMCommandValid =						TimeGate & ORAMDataInFunnelReady & ORAMRegOutValid & ~AccessInProgress;
	assign	ORAMRegOutReady =						TimeGate & ORAMDataInFunnelReady & ORAMCommandReady & ~AccessInProgress;
	
	assign	ORAMCommandTransfer =					ORAMCommandValid & ORAMCommandReady;

	//------------------------------------------------------------------------------
	// 	Access latency histogram generation
	//------------------------------------------------------------------------------				
	
	// TODO add support for multiple SWHistogramDump w/o reprogramming the board
	
	Register	#(			.Width(					1))
				stop_reg(	.Clock(					Clock),
							.Reset(					Reset),
							.Set(					SWHistogramDump | HWHistogramDump),
							.Enable(				1'b0),
							.In(					1'bx),
							.Out(					DumpHistogram));	
	
	assign	StopCounting =							DataOutActualValid;
	
	wire	[2-1:0]			Stopping;
	ShiftRegister #(		.PWidth(				2),
							.SWidth(				1))
				ro_L_shft(	.Clock(					Clock), 
							.Reset(					Reset), 
							.Load(					1'b0),
							.Enable(				1'b1), 
							.SIn(					StopCounting),
							.SOut(					StopCounting_Delay),
							.POut(					Stopping));
							
	assign	StartCounting = 						ORAMCommandTransfer & ORAMCommand == BECMD_Read;

	Register	#(			.Width(					1))
				lat_control(.Clock(					Clock),
							.Reset(					Reset | StopCounting_Delay),
							.Set(					StartCounting),
							.Enable(				1'b0),
							.In(					1'bx),
							.Out(					AccessInProgress));
				
	Counter		#(			.Width(					DBaseWidth))
				latency(	.Clock(					Clock),
							.Reset(					Reset | StartCounting),
							.Set(					1'b0),
							.Load(					1'b0),
							.Enable(				AccessInProgress & ~|Stopping),
							.In(					{DBaseWidth{1'bx}}),
							.Count(					AccessLatency));
	
	assign	HistogramAddress =						(DumpHistogram) ? DumpAddress : AccessLatency;			
	assign	HistogramWrite =						StopCounting_Delay; // Wait for HistogramOutData to become accurate
	assign	HistogramInData =						HistogramOutData + 1;
	
	RAM			#(			.DWidth(				DBaseWidth),
							.AWidth(				HGAWidth),
							.EnableInitial(			1),
							.Initial(				{1 << HGAWidth{{DBaseWidth{1'b0}}}}))
				histogram(	.Clock(					Clock),
							.Reset(					1'b0),
							.Enable(				1'b1),
							.Write(					HistogramWrite),
							.Address(				HistogramAddress),
							.DIn(					HistogramInData),
							.DOut(					HistogramOutData));

	Counter		#(			.Width(					HGAWidth),
							.Limited(				1))
				dump_addr(	.Clock(					Clock),
							.Reset(					Reset),
							.Set(					1'b0),
							.Load(					1'b0),
							.Enable(				DumpHistogram),
							.In(					{HGAWidth{1'bx}}),
							.Count(					DumpAddress));	
	
	Register	#(			.Width(					1))
				h_O_valid(	.Clock(					Clock),
							.Reset(					Reset),
							.Set(					1'b0),
							.Enable(				1'b1),
							.In(					DumpHistogram & ~&DumpAddress),
							.Out(					HistogramOutValid));
				
	//------------------------------------------------------------------------------
	// 	[Receive path] Shifts & buffers
	//------------------------------------------------------------------------------	

	`ifdef SIMULATION
		initial begin
			if ( (UARTWidth > DBaseWidth) | (DBaseWidth > FEDWidth) ) begin
				$display("[%m @ %t] Illegal parameter settings", $time);
				$finish;
			end
			
			if (GenHistogram & HGAWidth > 12) begin
				$display("[%m @ %t] recv_fifo may overflow --- make it deeper.", $time);
				$finish;
			end			
		end
	`endif

	FIFOShiftRound #(		.IWidth(				FEDWidth),
							.OWidth(				ORAMB),
							.Register(				1))
				O_check(	.Clock(					Clock),
							.Reset(					Reset),
							.InData(				ORAMDataOut),
							.InValid(				ORAMDataOutValid),
							.InAccept(				ORAMDataOutReady),
							.OutData(				DataOutActual),
							.OutValid(				DataOutActualValid),
							.OutReady(				1'b1));
			
	generate for (i = 0; i < OBUChunks; i = i + 1) begin
		assign	DataOutExpectedPre[(i+1)*ORAMU-1:i*ORAMU] = ORAMPAddr + i;
	end endgenerate	
							
	FIFORegister #(			.Width(					ORAMB))
				I_check(	.Clock(					Clock),
							.Reset(					Reset),
							.InData(				DataOutExpectedPre),
							.InValid(				ORAMCommandTransfer & ~WriteCommandValid),
							.InAccept(				),
							.OutData(				DataOutExpected),
							.OutSend(				DataOutExpectedValid),
							.OutReady(				DataOutActualValid));								
			
	assign	ERROR_MismatchReceivePattern =			(DataOutActual != DataOutExpected) & DataOutActualValid; 
	
	//------------------------------------------------------------------------------
	// 	[Receive path] Funnels & crossing
	//------------------------------------------------------------------------------	
	
	assign	HistogramOutReady =						ReceiveCrossDataInReady;
	
	assign	ReceiveCrossDataIn =					HistogramOutData;
	assign	ReceiveCrossDataInValid =				HistogramOutValid; 

	FIFORAM		#(			.Width(					DBaseWidth),
							.Buffering(				1 << HGAWidth))
				recv_fifo(	.Clock(					Clock),
							.Reset(					Reset),
							.InData(				ReceiveCrossDataIn),
							.InValid(				ReceiveCrossDataInValid),
							.InAccept(				ReceiveCrossDataInReady),
							.OutData(				ReceiveCrossDataOut),
							.OutSend(				ReceiveCrossDataOutValid),
							.OutReady(				ReceiveCrossDataOutReady));						
							
	FIFOShiftRound #(		.IWidth(				DBaseWidth),
							.OWidth(				UARTWidth))
				O_db_shft(	.Clock(					Clock),
							.Reset(					Reset),
							.InData(				ReceiveCrossDataOut),
							.InValid(				ReceiveCrossDataOutValid),
							.InAccept(				ReceiveCrossDataOutReady),
							.OutData(				UARTDataIn),
							.OutValid(				UARTDataInValid),
							.OutReady(				UARTDataInReady));				
				
	//------------------------------------------------------------------------------
	//	Error messages
	//------------------------------------------------------------------------------

	assign	ErrorReceiveOverflow =					1'b0;
	
	Register	#(			.Width(					1))
				send_ovflw(	.Clock(					Clock),
							.Reset(					Reset),
							.Set(					~CrossBufIn_DataInReady & CrossBufIn_DataInValid),
							.Enable(				1'b0),
							.In(					1'bx),
							.Out(					ErrorSendOverflow));	

	Register	#(			.Width(					1))
				error(		.Clock(					Clock),
							.Reset(					Reset),
							.Set(					ERROR_MismatchReceivePattern),
							.Enable(				1'b0),
							.In(					1'bx),
							.Out(					ErrorReceivePattern));	
	
	//------------------------------------------------------------------------------	
	//	Old traffic gen code (simulation only)
	//------------------------------------------------------------------------------
	
	/*
	`ifdef SIMULATION
		localparam			Rounds = 				500,
							AccessesPerRound =		20,
							
							RandomRounds =			5000,
							
							SingleLocRounds =		20,

							WaitThreshold =			100000, // Set to 2000 or something for a performance bug run
							
							Cycle = 				1000000000/SlowClockFreq;
		
		reg		[THPWidth-1:0] CrossBufIn_DataIn_Reg;
		reg					CrossBufIn_DataInValid_Reg;	
		integer 			i, nr, total_expected;
		integer				FinishedInput;
		integer				NumSent, NumReceived;
		integer				Gap;
		
		wire	[31:0]		RandOut;
		wire				RandOutValid;
		
		task TASK_Command;
			input	[BECMDWidth-1:0] 	In_Command;
			input	[ORAMU-1:0]			In_PAddr;
			integer 					CyclesWaited;
			begin
				CrossBufIn_DataInValid_Reg = 		1'b1;
				CrossBufIn_DataIn_Reg =				{In_Command, { {ORAMU-NVWidth{1'b0}}, In_PAddr[NVWidth-1:0] }, {DBaseWidth{1'b0}}, {TimeWidth{1'b0}}};
				CyclesWaited =						0;
				
				while (~CrossBufIn_DataInReady) begin
					CyclesWaited = CyclesWaited + 1;
					if (CyclesWaited > WaitThreshold) begin
						$display("[%m] ERROR: ORAM has stalled.");
						$finish;
					end
					#(Cycle);
				end
				#(Cycle);
				
				NumSent = NumSent + 1;
				$display("[%m @ %t] Test harness sent (op=%d, addr=%x)", $time, In_Command, In_PAddr[NVWidth-1:0]);
				$display("(read #%d)", NumSent);
				
				CrossBufIn_DataInValid_Reg = 		1'b0;
			end
		endtask
		
		assign	UARTDataOutReady =					1'b1;
		assign	CrossBufIn_DataInValid =			CrossBufIn_DataInValid_Reg;
		assign	CrossBufIn_DataIn =					CrossBufIn_DataIn_Reg;
		
		PRNG 	#(			.RandWidth(				ORAMU)) // TODO make dynamic
				leaf_gen(	.Clock(					Clock),
							.Reset(					Reset),
							.RandOutReady(			CrossBufIn_DataInValid & CrossBufIn_DataInReady),
							.RandOutValid(			RandOutValid),
							.RandOut(				RandOut),
							.SecretKey(				128'hd8_40_e1_a8_dc_ca_e7_ec_d9_1f_61_48_7a_f2_cb_00));
		
		initial begin
			FinishedInput = 						0;
			NumSent =								0;
			NumReceived =							0;
									
			Gap = 									1;
			
			CrossBufIn_DataInValid_Reg = 			1'b0;
			
			#(Cycle*1000);
		
			while (1) begin
			
				//
				// Random accesses
				//
				i = 0;
				while (i < RandomRounds) begin
					while (~RandOutValid) #(Cycle);
					
					TASK_Command(BECMD_Read, RandOut);
					#(Cycle*Gap);
						
					while (~RandOutValid) #(Cycle);
					
					if (RandOut[0]) begin
						TASK_Command(BECMD_Update, RandOut);
						#(Cycle*Gap);
					end
					
					i = i + 1;
				end
				
				//
				// Mimic Albert's access pattern
				//
				i = 0;
				while (i < SingleLocRounds) begin
					nr = 0;
					while (nr < AccessesPerRound) begin
						TASK_Command(BECMD_Read, i);
						TASK_Command(BECMD_Update, i);
						nr = nr + 1;
						#(Cycle*Gap);
					end
					i = i + 1;
				end
				
				//
				// Write -> Read groups of incrementing addrs
				//
				i = 0;
				while (i < Rounds) begin
					nr = 0;
					while (nr < AccessesPerRound) begin
						TASK_Command(BECMD_Update, i * AccessesPerRound + nr);
						nr = nr + 1;
						#(Cycle*Gap);
					end
					
					nr = 0;
					while (nr < AccessesPerRound) begin
						TASK_Command(BECMD_Read, i * AccessesPerRound + nr);
						nr = nr + 1;
						#(Cycle*Gap);
					end
					i = i + 1;
				end
				
				Gap = Gap * 64;
			end
			
			#(Cycle*WaitThreshold);
			FinishedInput =							1;
		end
		
		always @(posedge Clock) begin
			if (HistogramWrite) begin
				NumReceived = NumReceived + 1;
				$display("[%m @ %t] Test harness received read response #%d.", $time, NumReceived);
			end
			
			if (FinishedInput && NumSent == NumReceived) begin
				$display("ALL TESTS PASSED!");
				$finish;
			end
		end
		
		assign	SlowStartSignal =					1'b0;
	`endif
	*/	
	
	//------------------------------------------------------------------------------
endmodule
//--------------------------------------------------------------------------