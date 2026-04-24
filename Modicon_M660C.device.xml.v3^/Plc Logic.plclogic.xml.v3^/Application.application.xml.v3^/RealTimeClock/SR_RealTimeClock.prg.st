__METADATA__
{
  "v3Meta": {
    "objectGuid": "2fe166aa-fe38-4015-b227-019aa69bbf52",
    "objectTypeGuid": "6f9dac99-8de1-4efc-8465-68ac443b7d08",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
/// This program provides the logic to control the RealTimeClock.
/// It is linked to the corresponding visualization.

PROGRAM SR_RealTimeClock
VAR_INPUT
	i_xGet           : BOOL; //Trigger to get the real time clock
	i_xGetCyclically : BOOL; //If TRUE the real time clock is get cyclically 
	i_xSet           : BOOL; //Trigger to set the real time clock
	i_xWriteAsUtc    : BOOL := TRUE; //If TRUE the timestamp is converted to UTC before writing, else it is written as it is to the RTC.
	i_ldtTimeToSet   : LDATE_AND_TIME; //Specifies the timestamp to set
END_VAR
VAR_OUTPUT
	q_ldtRtc             : LDATE_AND_TIME; //Indicates the real time clock
	q_ldtLocalTime       : LDATE_AND_TIME; //Indicates the local time
	q_stTimezone         : SysTimeRtc.TimezoneInformation2; //Indicates the timezone
	q_sOffset			 : STRING; //Indicates the offset according ISO 8601
	q_xErrorGetRtc       : BOOL; //Indicates an error detected when getting real time clock
	q_xErrorGetLocalTime : BOOL; //Indicates an error detected when getting local time
	q_xErrorGetTimezone  : BOOL; //Indicates an error detected when getting timezone
	q_xErrorSet          : BOOL; //Indicates an error detected when setting real time clock
END_VAR
VAR
	stTimezone_loc     	: SysTimeRtc.TimezoneInformation2;
	fbCyclicGetTrigger 	: TON;
	timCycle           	: TIME := T#1S;
	xInitDone          	: BOOL;
	diOffset		   	: DINT;
	diOffsetMin		   	: DINT;
	sOffset				: STRING;
	
	fbSetTrigger 		: R_TRIG;
	fbGetTrigger 		: R_TRIG;
	
	//Diagnostic values
	uidLastResultLocalTimeConvertToLocal   : SysTimeRtc.SysTypes.RTS_IEC_RESULT;
	uidLastResultLocalTimeConvertToHighRes : SysTimeRtc.SysTypes.RTS_IEC_RESULT;
	udiLastResultGetRtc                    : SysTimeRtc.SysTypes.RTS_IEC_RESULT;
	udiLastResultGetTimezone               : SysTimeRtc.SysTypes.RTS_IEC_RESULT;
	udiLastResultSetRtc                    : SysTimeRtc.SysTypes.RTS_IEC_RESULT;
	sLastResultMsgSetRtc                   : STRING;
END_VAR
__IMPLEMENTATION__
//Generate cyclic 1 second trigger
fbCyclicGetTrigger(IN := i_xGetCyclically AND NOT fbCyclicGetTrigger.Q, PT := timCycle);

//Detect rising edge at inputs Get and Set
fbGetTrigger(CLK := i_xGet);
fbSetTrigger(CLK := i_xSet);

IF fbGetTrigger.Q OR fbCyclicGetTrigger.Q OR NOT xInitDone THEN
	//Get RTC
	q_ldtRtc := ldtRtc;
	
	//Get timezone
	q_stTimezone := stTimezone;
	
	//Create ISO 8601 conforming string indicating the offset
	diOffset := stTimezone.utcOffsetSeconds/3600;
	diOffsetMin := (stTimezone.utcOffsetSeconds/60) MOD 60;
	
	IF diOffset > 9 THEN
		sOffset := CONCAT('+', TO_STRING(diOffset));
	ELSIF diOffset >= 0 THEN
		sOffset := CONCAT('+0', TO_STRING(diOffset));
	ELSIF diOffset < -9 THEN
		sOffset := TO_STRING(diOffset);
	ELSE	
		sOffset := CONCAT('-0', TO_STRING(diOffset*-1));
	END_IF
	
	sOffset := CONCAT(sOffset, ':');
	
	IF diOffsetMin > 9 THEN
		sOffset := CONCAT(sOffset, TO_STRING(diOffsetMin));
	ELSE
		sOffset := CONCAT(CONCAT(sOffset, '0'), TO_STRING(diOffsetMin));
	END_IF
	
	q_sOffset := sOffset;
	
	//Get local time
	q_ldtLocalTime       := ldtLocalTime;
	q_xErrorGetLocalTime :=
		udiLastResultGetRtc <> CmpErrors.Errors.ERR_OK OR
		uidLastResultLocalTimeConvertToLocal <> CmpErrors.Errors.ERR_OK OR
		uidLastResultLocalTimeConvertToHighRes <> CmpErrors.Errors.ERR_OK;
	q_xErrorGetRtc      := udiLastResultGetRtc <> CmpErrors.Errors.ERR_OK;
	q_xErrorGetTimezone := udiLastResultGetTimezone <> CmpErrors.Errors.ERR_OK;
	
	IF fbGetTrigger.Q OR NOT xInitDone THEN
		//Synchronize i_ldtTimeToSet with RTC on PLC for an improved usability through the
		//visualization in case no variable is assigned to i_ldtTimeToSet in the program
		i_ldtTimeToSet := q_ldtRtc;
	END_IF
	
	//Set Init flag
	xInitDone := TRUE;
END_IF

IF fbSetTrigger.Q THEN
	//Set RTC
	SetRtc(
		i_ldtTimestamp := i_ldtTimeToSet,
		i_xWriteAsUtc  := i_xWriteAsUtc,
		q_xError       => q_xErrorSet,
		q_udiResult    => udiLastResultSetRtc,
		q_sResultMsg   => sLastResultMsgSetRtc
	);
END_IF
