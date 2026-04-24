__METADATA__
{
  "v3Meta": {
    "objectGuid": "3e6b7796-f741-4565-a596-c0089cee798d",
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
PROGRAM SR_Main
VAR
	stTime: DWORD;
	presult: SysTimeRtc.RTS_IEC_RESULT;
	myDate: DATE;
	myTime: TIME;
	myDateTime: DATE_AND_TIME;
	mySetDateTime: DATE_AND_TIME;
	
	setTime: BOOL;
	
	iVar: INT;
	
END_VAR
__IMPLEMENTATION__
(*
stTime := SysTimeRtc.SysTimeRtcGet(presult);
myDate := DWORD_TO_DATE(stTime);
myTime := DWORD_TO_TIME(stTime);
myDateTime := DWORD_TO_DT(stTime);

IF setTime THEN
	setTime := FALSE;
	resultSet := sysTimeRtc.SysTimeRtcSet(DT_TO_DWORD(mySetDateTime));
END_IF
*)

iVar := 10;
