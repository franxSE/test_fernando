__METADATA__
{
  "v3Meta": {
    "objectGuid": "02ce352b-bcd4-4d4d-948d-ea1fd9b051aa",
    "objectTypeGuid": "5a3b8626-d3e9-4f37-98b5-66420063d91e",
    "embeddedObjectTypeGuids": [
      "a9ed5b7e-75c5-4651-af16-d2c27e98cb94"
    ],
    "properties": {},
    "subObjects": {
      "get": {
        "objectGuid": "d9e3bc31-8e04-4c51-8be0-6c19b9131eb9",
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
PROPERTY stTimezone : REFERENCE TO SysTimeRtc.TimezoneInformation2; //If utcOffsetSeconds is not supported, the return value of this structure element is -1
__GETTERDECLARATION__
VAR
END_VAR
__GETTERIMPLEMENTATION__
//Get timezone from PLC
udiLastResultGetTimezone := SysTimeRtc.SysTimeRtcGetTimezone2(pTZI := stTimezone_loc);

IF udiLastResultGetTimezone <> CmpErrors.Errors.ERR_OK THEN
	RETURN;
END_IF

stTimezone REF= stTimezone_loc;
