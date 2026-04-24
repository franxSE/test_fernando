__METADATA__
{
  "v3Meta": {
    "objectGuid": "9cd0e5ca-9d0f-4225-be3b-030ba0986fc9",
    "objectTypeGuid": "f8a58466-d7f6-439f-bbb8-d4600e41d099",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
      "3b83b776-fb25-43b8-99f2-3c507c9143fc"
    ],
    "properties": {},
    "subObjects": {}
  }
}
__DECLARATION__
/// This method is used to set the RealTimeClock of the controller.

METHOD SetRtc
VAR_INPUT
	i_ldtTimestamp : LDATE_AND_TIME; //Timestamp to set
	i_xWriteAsUtc    : BOOL := TRUE; //If TRUE the timestamp is converted to UTC before writing, else it is written as it is to the RTC.
END_VAR
VAR_OUTPUT
	q_xError     : BOOL; //Indicates that an error was detected during execution
	q_udiResult  : SysTimeRtc.SysTypes.RTS_IEC_RESULT; // Provides diagnostic and status information as a numeric value
	q_sResultMsg : STRING; //Provides additional diagnostic and status information as a text message
END_VAR
VAR
	udiResult  : SysTimeRtc.SysTypes.RTS_IEC_RESULT;
	
	uliTimestamp : ULINT;
	stDate       : SysTimeRtc.SYSTIMEDATE;
END_VAR
__IMPLEMENTATION__
//Convert LDT to ULINT
uliTimestamp := TO_ULINT(i_ldtTimestamp)/1000000;

IF i_xWriteAsUtc THEN
	//Convert timestamp to local time
	udiResult := SysTimeRtc.SysTimeRtcConvertHighResToDate(pTimestamp := uliTimestamp, pDate := stDate);
	
	IF udiResult <> CmpErrors.Errors.ERR_OK THEN
		q_xError := TRUE;		
		q_udiResult := udiResult;
		q_sResultMsg := CONCAT('Function SysTimeRtcConvertHighResToDate failed with result ', TO_STRING(udiResult));
		RETURN;
	END_IF
		
	udiResult := SysTimeRtc.SysTimeRtcConvertLocalToHighRes(pDate := stDate, pTimestamp := uliTimestamp);
	
	IF udiResult <> CmpErrors.Errors.ERR_OK THEN
		q_xError := TRUE;	
		q_udiResult := udiResult;
		q_sResultMsg := CONCAT('Function SysTimeRtcConvertLocalToHighRes failed with result ', TO_STRING(udiResult));
		RETURN;
	END_IF

END_IF

//Set RTC to PLC
udiResult := SysTimeRtc.SysTimeRtcHighResSet(pTimestamp := uliTimestamp);

//Set outputs
IF udiResult <> CmpErrors.Errors.ERR_OK THEN
	q_xError := TRUE;
	q_udiResult := udiResult;
	q_sResultMsg := CONCAT('Function SysTimeRtc failed with result ', TO_STRING(udiResult));
	RETURN;
END_IF

q_xError := FALSE;
q_udiResult := CmpErrors.Errors.ERR_OK;
q_sResultMsg := 'RTC successfully set';
