
//==============================================================================
//	Section:	Includes
//==============================================================================
`include "Const.vh"
//==============================================================================

`timescale 1ns/1ns

//==============================================================================
//	Module:		testDRAMTop
//	Desc: 		
//==============================================================================
module testDRAMTop(
			// GPIO
			output	[7:0]	led,

			// System
			input			sys_clk_p,
			input			sys_clk_n,
			input			sys_rst, // SW8

			input			GPIO_SW_C,
			
			output			uart_txd
			
	`ifndef SIMULATION
			,
			// DDR3 SDRAM
			inout 	[63:0]	ddr3_dq,
			inout 	[7:0]	ddr3_dqs_n,
			inout 	[7:0]	ddr3_dqs_p,			
			output 	[13:0]	ddr3_addr,
			output 	[2:0]	ddr3_ba,
			output			ddr3_ras_n,
			output			ddr3_cas_n,
			output			ddr3_we_n,
			output			ddr3_reset_n,
			output 	[0:0]	ddr3_ck_p,
			output 	[0:0]	ddr3_ck_n,
			output 	[0:0]	ddr3_cke,
			output 	[0:0]	ddr3_cs_n,
			output 	[7:0]	ddr3_dm,
			output 	[0:0]	ddr3_odt
	`endif
	);
	
	//------------------------------------------------------------------------------
	//	Constants
	//------------------------------------------------------------------------------
	
	`include "DDR3SDRAMLocal.vh"
	
	parameter				ClockFreq =				100_000_000,
							Cycle = 				1000000000/ClockFreq;
	
	parameter				IntroduceErrors =		1;
	
	parameter				ORAMB =					512,
							ORAMU =					32,
	`ifdef SIMULATION
							ORAML =					10,
	`else
							ORAML =					20,
	`endif
							ORAMZ =					5;
	
	`ifdef SIMULATION
	localparam				DDRAWidth_Top =			27;
	`else
	localparam				DDRAWidth_Top =			DDRAWidth;
	`endif	
	
	//------------------------------------------------------------------------------
	//	Wires & Regs
	//------------------------------------------------------------------------------
	
	wire					Clock, Reset;

	// ORAM
	
	(* mark_debug = "TRUE" *)	wire	[DDRCWidth-1:0]	DDR3SDRAM_Command;
	(* mark_debug = "TRUE" *)	wire	[DDRAWidth_Top-1:0]	DDR3SDRAM_Address;
	(* mark_debug = "TRUE" *)	wire	[DDRDWidth-1:0]	DDR3SDRAM_WriteData, DDR3SDRAM_ReadData; 
	wire	[DDRMWidth-1:0]	DDR3SDRAM_WriteMask;
	
	(* mark_debug = "TRUE" *)	wire					DDR3SDRAM_CommandValid, DDR3SDRAM_CommandReady;
	(* mark_debug = "TRUE" *)	wire					DDR3SDRAM_DataInValid, DDR3SDRAM_DataInReady;
	(* mark_debug = "TRUE" *)	wire					DDR3SDRAM_DataOutValid;
	
	(* mark_debug = "TRUE" *)	wire					Error_DataMismatch, Error_MultipleBitErrors;
	
	wire					DumpStatistics;
	reg						DumpStatisticsSim;
	
	`ifdef SIMULATION
	initial begin
		DumpStatisticsSim = 1'b0;
		
		#(200 * Cycle);
		
		while (~Error_DataMismatch) #(Cycle);
		$display("[%m @ %t] INFO: starting stat ticking.", $time);
		
		#(25000 * Cycle);
		DumpStatisticsSim = 1'b1;
		#(Cycle);
		DumpStatisticsSim = 1'b0;
		$display("[%m @ %t] INFO: starting stat dump.", $time);
	end
	`else
	initial begin
		DumpStatisticsSim = 1'b0;
	end
	`endif
	
	//------------------------------------------------------------------------------
	// 	GPIO
	//------------------------------------------------------------------------------

	assign	led[7] =								DRAMCalibrationComplete;
	assign	led[6] =								DDR3SDRAM_DataOutValid;
	
	assign	led[5:2] = 								0;

	assign	led[1] =								Error_MultipleBitErrors;
	assign	led[0] =								Error_DataMismatch;

	//------------------------------------------------------------------------------
	// 	Traffic generator
	//------------------------------------------------------------------------------
	
	ButtonParse	#(			.Width(					1),
							.DebWidth(				`log2(ClockFreq / 100)),
							.EdgeOutWidth(			1))
					InBP(	.Clock(					Clock),
							.Reset(					Reset),
							.Enable(				1'b1),
							.In(					GPIO_SW_C),
							.Out(					DumpStatistics));	
	
    PathORAMSimulator #(	.ClockFreq(				ClockFreq),
							.IntroduceErrors(		IntroduceErrors),
							.ORAMB(					ORAMB),
							.ORAMU(					ORAMU),
							.ORAML(					ORAML),
							.ORAMZ(					ORAMZ))
                oram(		.Clock(					Clock),
							.Reset(					Reset),
		
							.DRAMCommand(			DDR3SDRAM_Command),
							.DRAMAddress(           DDR3SDRAM_Address),
							.DRAMCommandValid(		DDR3SDRAM_CommandValid),
							.DRAMCommandReady(		DDR3SDRAM_CommandReady),
							
							.DRAMReadData(			DDR3SDRAM_ReadData),
							.DRAMReadDataValid(		DDR3SDRAM_DataOutValid),
							
							.DRAMWriteData(			DDR3SDRAM_WriteData),
							.DRAMWriteMask(			DDR3SDRAM_WriteMask),
							.DRAMWriteDataValid(	DDR3SDRAM_DataInValid),
							.DRAMWriteDataReady(	DDR3SDRAM_DataInReady),
							
							.Error_DataMismatch(	Error_DataMismatch), 
							.Error_MultipleBitErrors(Error_MultipleBitErrors),
							
							.UARTTX(				uart_txd),
							.DumpStatistics(		DumpStatistics | DumpStatisticsSim));	
	
	//------------------------------------------------------------------------------
	// 	DRAM controller
	//------------------------------------------------------------------------------
	
	DDR3SDRAM_mig7 #(		.SlowUserClock(			1),
							.IntroduceErrors(		IntroduceErrors),
							.ErrorRate(				100),
							.ErrorRate2(			2))
				dram(		.UserClock(				Clock), 
							.UserReset(				Reset), 
                            
							.DRAMCommand(			DDR3SDRAM_Command),
							.DRAMAddress(			DDR3SDRAM_Address), 
							.DRAMCommandValid(		DDR3SDRAM_CommandValid),  
							.DRAMCommandReady(		DDR3SDRAM_CommandReady), 
							.DRAMReadData(			DDR3SDRAM_ReadData),  
							.DRAMReadDataValid(		DDR3SDRAM_DataOutValid), 
							.DRAMWriteData(			DDR3SDRAM_WriteData),  
							//.DRAMWriteMask(			DDR3SDRAM_WriteMask),  
							.DRAMWriteDataValid(	DDR3SDRAM_DataInValid),  
							.DRAMWriteDataReady(	DDR3SDRAM_DataInReady), 
							
							.sys_clk_p(				sys_clk_p),  
							.sys_clk_n(				sys_clk_n),  
							.sys_rst(				sys_rst), 
							.ddr3_dq(				ddr3_dq),  
							.ddr3_dqs_n(			ddr3_dqs_n),  
							.ddr3_dqs_p(			ddr3_dqs_p), 			
							.ddr3_addr(				ddr3_addr),  
							.ddr3_ba(				ddr3_ba), 
							.ddr3_ras_n(			ddr3_ras_n),  
							.ddr3_cas_n(			ddr3_cas_n), 
							.ddr3_we_n(				ddr3_we_n),  
							.ddr3_reset_n(			ddr3_reset_n), 
							.ddr3_ck_p(				ddr3_ck_p),  
							.ddr3_ck_n(				ddr3_ck_n), 
							.ddr3_cke(				ddr3_cke),  
							.ddr3_cs_n(				ddr3_cs_n), 
							.ddr3_dm(				ddr3_dm),  
							.ddr3_odt(				ddr3_odt), 
							
							.CalibrationComplete(	DRAMCalibrationComplete));
	
	//------------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------