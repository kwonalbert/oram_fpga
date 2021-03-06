// auto generated SRAM wrapper by rf2D_32soi_wrap_gen.py

module RF2DFCMN00256X008D04C064_WRAP (Clock, Read, Write, _RAddr, _WAddr, _DIn, _DOut);

	input Clock, Read, Write;
	input [8-1:0] _RAddr, _WAddr;
	input [8-1:0] _DIn;
	output [8-1:0] _DOut;

	RF2DFCMN00256X008D04C064 SRAM (
		.CLK(	Clock),
		.CER(	Read),
		.CEW(	Write),
		.DEEPSLEEP(	1'b0),

		.ABR0(	_RAddr[0]),
		.ACR0(	_RAddr[1]),
		.ADR0(	_RAddr[2]),
		.AWR0(	_RAddr[3]),
		.AWR1(	_RAddr[4]),
		.AWR2(	_RAddr[5]),
		.AWR3(	_RAddr[6]),
		.AWR4(	_RAddr[7]),

		.ABW0(	_WAddr[0]),
		.ACW0(	_WAddr[1]),
		.ADW0(	_WAddr[2]),
		.AWW0(	_WAddr[3]),
		.AWW1(	_WAddr[4]),
		.AWW2(	_WAddr[5]),
		.AWW3(	_WAddr[6]),
		.AWW4(	_WAddr[7]),

		.D0(	_DIn[0]),
		.D1(	_DIn[1]),
		.D2(	_DIn[2]),
		.D3(	_DIn[3]),
		.D4(	_DIn[4]),
		.D5(	_DIn[5]),
		.D6(	_DIn[6]),
		.D7(	_DIn[7]),
		.Q0(	_DOut[0]),
		.Q1(	_DOut[1]),
		.Q2(	_DOut[2]),
		.Q3(	_DOut[3]),
		.Q4(	_DOut[4]),
		.Q5(	_DOut[5]),
		.Q6(	_DOut[6]),
		.Q7(	_DOut[7]),
		.BW0(	1'b1),
		.BW1(	1'b1),
		.BW2(	1'b1),
		.BW3(	1'b1),
		.BW4(	1'b1),
		.BW5(	1'b1),
		.BW6(	1'b1),
		.BW7(	1'b1),


		.TABR0(	1'b0),
		.TACR0(	1'b0),
		.TADR0(	1'b0),
		.TAWR0(	1'b0),
		.TAWR1(	1'b0),
		.TAWR2(	1'b0),
		.TAWR3(	1'b0),
		.TAWR4(	1'b0),
		.TABW0(	1'b0),
		.TACW0(	1'b0),
		.TADW0(	1'b0),
		.TAWW0(	1'b0),
		.TAWW1(	1'b0),
		.TAWW2(	1'b0),
		.TAWW3(	1'b0),
		.TAWW4(	1'b0),
		.TD0(	1'b0),
		.TD1(	1'b0),
		.TD2(	1'b0),
		.TD3(	1'b0),
		.TD4(	1'b0),
		.TD5(	1'b0),
		.TD6(	1'b0),
		.TD7(	1'b0),
		.TQ0(	1'b0),
		.TQ1(	1'b0),
		.TQ2(	1'b0),
		.TQ3(	1'b0),
		.TQ4(	1'b0),
		.TQ5(	1'b0),
		.TQ6(	1'b0),
		.TQ7(	1'b0),
		.TBW0(	1'b0),
		.TBW1(	1'b0),
		.TBW2(	1'b0),
		.TBW3(	1'b0),
		.TBW4(	1'b0),
		.TBW5(	1'b0),
		.TBW6(	1'b0),
		.TBW7(	1'b0),
		.MIEMAM0(	1'b0),
		.MIEMAM1(	1'b0),
		.MIEMAT0(	1'b0),
		.MIEMAT1(	1'b0),
		.MIEMAW0(	1'b0),
		.MIEMAW1(	1'b0),
		.MIEMAWASS0(	1'b0),
		.MIEMAWASS1(	1'b0),
		.MIEMASASS0(	1'b0),
		.MIEMASASS1(	1'b0),
		.MIEMASASS2(	1'b0),
		.CR00(	1'b0),
		.CR01(	1'b0),
		.CR02(	1'b0),
		.MICLKMODE(	1'b0),
		.MIFLOOD(	1'b0),
		.MILSMODE(	1'b0),
		.MIPIPEMODE(	1'b0),
		.MISASSD(	1'b0),
		.MISTM(	1'b0),
		.MITESTM1(	1'b0),
		.MITESTM3(	1'b0),
		.MIWASSD(	1'b0),
		.MIWRTM(	1'b0),
		.TCER(	1'b0),
		.TCEW(	1'b0),
		.TDEEPSLEEP(	1'b0),
		.CRE0(	1'b0));
endmodule
