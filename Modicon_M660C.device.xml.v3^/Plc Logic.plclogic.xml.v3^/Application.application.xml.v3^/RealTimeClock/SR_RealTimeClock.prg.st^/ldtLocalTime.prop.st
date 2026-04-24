__METADATA__
{
  "v3Meta": {
    "objectGuid": "d8ffaea4-dd6b-4f8e-8a88-b1fa0be5aa72",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "get": {
        "objectGuid": "9e02949f-ca78-4176-9f19-348c60c7b66c",
        "objectTypeGuid": "792f2eb6-721e-4e64-ba20-bc98351056db",
        "embeddedObjectTypeGuids": [
          "a9ed5b7e-75c5-4651-af16-d2c27e98cb94",
          "3b83b776-fb25-43b8-99f2-3c507c9143fc"
        ],
        "properties": {},
        "subObjects": {}
      }
    }
  }
}
__DECLARATION__
 {attribute 'monitoring':='variable'}
PROPERTY ldtLocalTime : LDATE_AND_TIME //If local time is not supported, the return value is 0 (LDT#1970-1-1-0:0:0)
__GETTERDECLARATION__
VAR
	uliTimestamp : ULINT;
	stDate: SysTimeRtc.SYSTIMEDATE;
END_VAR
__GETTERIMPLEMENTATION__
//Get RTC from PLC
uliTimestamp := TO_ULINT(ldtRtc)/1000000;

IF udiLastResultGetRtc <> CmpErrors.Errors.ERR_OK THEN
	RETURN;
END_IF

//Convert RTC to local time
uidLastResultLocalTimeConvertToLocal := SysTimeRtc.SysTimeRtcConvertHighResToLocal(pTimestamp := uliTimestamp, pDate := stDate);

IF uidLastResultLocalTimeConvertToLocal <> CmpErrors.Errors.ERR_OK THEN
	RETURN;
END_IF

uidLastResultLocalTimeConvertToHighRes := SysTimeRtc.SysTimeRtcConvertDateToHighRes(pDate := stDate, pTimestamp := uliTimestamp);

IF uidLastResultLocalTimeConvertToHighRes <> CmpErrors.Errors.ERR_OK THEN
	RETURN;
END_IF

//Return as LDT
ldtLocalTime := TO_LDT(uliTimestamp*1000000);
