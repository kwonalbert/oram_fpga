
//==============================================================================
//	Section:	Includes
//==============================================================================
`include "Const.vh"
//==============================================================================

`timescale 1ps/1ps

//==============================================================================
//	Module:		TinyORAMTop_vc707
//	Desc: 		Top level module for Tiny ORAM + a traffic generator for the
//				VC707 FPGA board.
//==============================================================================
module TinyORAMTop_vc707(
			// GPIO LEDs
			output	[7:0]	led,

			// GPIO switches
			input			GPIO_SW_S,
			input			GPIO_SW_N,
			input			GPIO_SW_C,
			input			GPIO_SW_E,
			input			GPIO_SW_W,

			// System
			input			sys_clk_p,
			input			sys_clk_n,
			input			sys_rst, // SW8

	`ifndef SIMULATION
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
			output 	[0:0]	ddr3_odt,
	`endif

			// UART / Serial
			output			uart_txd,
			input			uart_rxd
	);

	//--------------------------------------------------------------------------
	//	Parameters
	//--------------------------------------------------------------------------

	/* 	Debugging.

		SlowORAMClock:		slow the ORAM controller down to make it easier to add
							ChipScope signals & meet timing */

	parameter				SlowORAMClock =			1; // NOTE: set to 0 for performance run

	parameter				ORAMB =					512,
							ORAMU =					32,
							ORAML =					`ifdef ORAML 	`ORAML 		`else 10  	`endif,
							ORAMZ =					`ifdef ORAMZ 	`ORAMZ 		`else 5 	`endif,
							FEDWidth =				`ifdef FEDWidth `FEDWidth 	`else 64	`endif,
							BEDWidth =              `ifdef BEDWidth `BEDWidth   `else 64   `endif;

	//--------------------------------------------------------------------------
	//	Constants
	//--------------------------------------------------------------------------

	`include "DDR3SDRAMLocal.vh"
	`include "CommandsLocal.vh"

	localparam				ClockFreq =				(SlowORAMClock) ? 100_000_000 : 200_000_000;

	localparam				NumValidBlock =			1 << ORAML;

	//--------------------------------------------------------------------------
	//	Wires & Regs
	//--------------------------------------------------------------------------

	// Clocking

	wire					ORAMClock; // Configurable (typically >= 100 Mhz, <= 200 Mhz)
	wire					ORAMReset;

	// Test harness

	wire					Tester_ForceHistogramDumpPre;
	reg						Tester_ForceHistogramDump;

	// ORAM

	(* mark_debug = "TRUE" *)	wire	[BECMDWidth-1:0] PathORAM_Command;
	(* mark_debug = "TRUE" *)	wire	[ORAMU-1:0] 	PathORAM_PAddr;
	(* mark_debug = "TRUE" *)	wire					PathORAM_CommandValid, PathORAM_CommandReady;

	(* mark_debug = "TRUE" *)	wire	[FEDWidth-1:0]	PathORAM_DataIn;
	(* mark_debug = "TRUE" *)	wire					PathORAM_DataInValid, PathORAM_DataInReady;

	(* mark_debug = "TRUE" *)	wire	[FEDWidth-1:0]	PathORAM_DataOut;
	(* mark_debug = "TRUE" *)	wire 					PathORAM_DataOutValid, PathORAM_DataOutReady;

	// MIG/DDR3 DRAM

	wire					DRAMCalibrationComplete;

	(* mark_debug = "TRUE" *)	wire	[DDRCWidth-1:0]	DDR3SDRAM_Command;
	(* mark_debug = "TRUE" *)	wire	[DDRAWidth-1:0]	DDR3SDRAM_Address;
	(* mark_debug = "TRUE" *)	wire	[DDRDWidth-1:0]	DDR3SDRAM_WriteData, DDR3SDRAM_ReadData;
	wire	[DDRMWidth-1:0]	DDR3SDRAM_WriteMask;

	(* mark_debug = "TRUE" *)	wire					DDR3SDRAM_CommandValid, DDR3SDRAM_CommandReady;
	(* mark_debug = "TRUE" *)	wire					DDR3SDRAM_DataInValid, DDR3SDRAM_DataInReady;
	(* mark_debug = "TRUE" *)	wire					DDR3SDRAM_DataOutValid;

	//--------------------------------------------------------------------------
	// 	GPIO
	//--------------------------------------------------------------------------

	// We wish to reset the harness first, then dump the histogram
	always @(posedge ORAMClock) begin
		Tester_ForceHistogramDump <=				Tester_ForceHistogramDumpPre;
	end

	assign	led[7] =								DRAMCalibrationComplete;
	assign	led[6:3] = 								0;
	assign	led[2] = 								DDR3SDRAM_DataOutValid;

	ButtonParse	#(			.Width(					1),
							.DebWidth(				`log2(ClockFreq / 100)), // Use a 10ms button parser (roughly)
							.EdgeOutWidth(			1))
					InBP(	.Clock(					ORAMClock),
							.Reset(					ORAMReset),
							.Enable(				1'b1),
							.In(					GPIO_SW_C),
							.Out(					Tester_ForceHistogramDumpPre));

	//--------------------------------------------------------------------------
	// 	uBlaze core & caches
	//--------------------------------------------------------------------------

	TrafficGen #(			.ORAMB(					ORAMB),
							.ORAMU(					ORAMU),
							.FEDWidth(				FEDWidth),
							.BEDWidth(              BEDWidth),
							.EnableIV(              0),
							.NumValidBlock(			NumValidBlock),
							.ClockFreq(				ClockFreq))
				traffic(	.Clock(					ORAMClock),
							.Reset(					ORAMReset | Tester_ForceHistogramDumpPre),

							.ORAMCommand(			PathORAM_Command),
							.ORAMPAddr(				PathORAM_PAddr),
							.ORAMCommandValid(		PathORAM_CommandValid),
							.ORAMCommandReady(		PathORAM_CommandReady),

							.ORAMDataIn(			PathORAM_DataIn),
							.ORAMDataInValid(		PathORAM_DataInValid),
							.ORAMDataInReady(		PathORAM_DataInReady),

							.ORAMDataOut(			PathORAM_DataOut),
							.ORAMDataOutValid(		PathORAM_DataOutValid),
							.ORAMDataOutReady(		PathORAM_DataOutReady),

							.UARTRX(				uart_rxd),
							.UARTTX(				uart_txd),

							.HWHistogramDump(		Tester_ForceHistogramDump),

							.ErrorReceiveOverflow(	led[0]),
							.ErrorReceivePattern(	led[1]),
							.ErrorSendOverflow(		));

	//--------------------------------------------------------------------------
	// 	ORAM Controller
	//--------------------------------------------------------------------------

	TinyORAMCore #(			.ORAMB(					ORAMB),
							.ORAMU(					ORAMU),
							.ORAML(					ORAML),
							.ORAMZ(					ORAMZ),
							.FEDWidth(				FEDWidth),
							.BEDWidth(              BEDWidth),
							.NumValidBlock(			NumValidBlock))
				oram(		.Clock(					ORAMClock),
							.Reset(					ORAMReset),

							.Cmd(				    PathORAM_Command),
							.PAddr(					PathORAM_PAddr),
							.CmdValid(			    PathORAM_CommandValid),
							.CmdReady(			    PathORAM_CommandReady),

							.DataIn(                PathORAM_DataIn),
							.DataInValid(           PathORAM_DataInValid),
							.DataInReady(           PathORAM_DataInReady),

							.DataOut(           	PathORAM_DataOut),
							.DataOutValid(      	PathORAM_DataOutValid),
							.DataOutReady(      	PathORAM_DataOutReady),

							.DRAMCommand(			DDR3SDRAM_Command),
							.DRAMAddress(           DDR3SDRAM_Address),
							.DRAMCommandValid(		DDR3SDRAM_CommandValid),
							.DRAMCommandReady(		DDR3SDRAM_CommandReady),

							.DRAMReadData(			DDR3SDRAM_ReadData),
							.DRAMReadDataValid(		DDR3SDRAM_DataOutValid),

							.DRAMWriteData(			DDR3SDRAM_WriteData),
							.DRAMWriteMask(			DDR3SDRAM_WriteMask),
							.DRAMWriteDataValid(	DDR3SDRAM_DataInValid),
							.DRAMWriteDataReady(	DDR3SDRAM_DataInReady));

	//--------------------------------------------------------------------------
	//	DRAM Controller
	//--------------------------------------------------------------------------

	DDR3SDRAM_mig7 #(		.SlowUserClock(			SlowORAMClock))
				dram(		.UserClock(				ORAMClock),
							.UserReset(				ORAMReset),

							.DRAMCommand(			DDR3SDRAM_Command),
							.DRAMAddress(			DDR3SDRAM_Address),
							.DRAMCommandValid(		DDR3SDRAM_CommandValid),
							.DRAMCommandReady(		DDR3SDRAM_CommandReady),
							.DRAMReadData(			DDR3SDRAM_ReadData),
							.DRAMReadDataValid(		DDR3SDRAM_DataOutValid),
							.DRAMWriteData(			DDR3SDRAM_WriteData),
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

	//--------------------------------------------------------------------------
endmodule
//------------------------------------------------------------------------------