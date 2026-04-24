__METADATA__
{
  "v3Meta": {
    "objectGuid": "e8aaef47-7ef2-4276-9095-487b702279d3",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "get": {
        "objectGuid": "f0acb608-740a-4465-8f33-a81d3e16d75c",
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
PROPERTY ldtRtc : LDATE_AND_TIME
__GETTERDECLARATION__
VAR
	uliRtc: ULINT;
END_VAR
__GETTERIMPLEMENTATION__
//Get RTC from PLC
udiLastResultGetRtc := SysTimeRtc.SysTimeRtcHighResGet(pTimestamp := uliRtc);

IF udiLastResultGetRtc <> CmpErrors.Errors.ERR_OK THEN
	RETURN;
END_IF

//Return as LDT
ldtRtc := TO_LDT(uliRtc*1000000);
