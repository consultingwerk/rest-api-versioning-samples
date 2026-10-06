/**********************************************************************
 * Copyright (c) 2026-2026 by Consultingwerk Ltd. ("CW") -            *
 * www.consultingwerk.de and other contributors as listed             *
 * below.  All Rights Reserved.                                       *
 *                                                                    *
 *  Software is distributed on an "AS IS", WITHOUT WARRANTY OF ANY    *
 *   KIND, either express or implied.                                 *
 *                                                                    *
 *  Contributors:                                                     *
 *                                                                    *
 **********************************************************************/
/*------------------------------------------------------------------------
    File        : Demo.RestApiVersioning.Adapters.JsonReader
    Purpose     : Helpers shared by the readers of all versions
    Syntax      :
    Description : Field names are paths: "CustNum" or "Customer.CustNum".
                  - CheckUnknownFields  : 400 for fields outside the schema
                  - CheckRequiredFields : 400 for missing required fields
                  - Has / Get...        : null returns the unknown value (?),
                                          a wrong JSON type raises 400
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : JSON property names are case-sensitive, so is the check
                  for unknown fields
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Errors.* from propath.
using Progress.Json.ObjectModel.*     from propath.

class Demo.RestApiVersioning.Adapters.JsonReader
    abstract:

    /**
     * Purpose: Raises 400 when the JSON object contains fields that are not
     *          part of the schema
     * Notes  : All unknown fields are reported at once
     * @param poJson The JSON object to check
     * @param pcKnownFields The comma separated list of the fields of the schema
     * @param pcPrefix The path prefix for the reported field names, e.g. "Customer."
     */
    method protected void CheckUnknownFields (poJson as JsonObject,
                                              pcKnownFields as character,
                                              pcPrefix as character):

        define variable cNames   as character no-undo extent .
        define variable cUnknown as character no-undo .
        define variable iName    as integer   no-undo .
        define variable iNames   as integer   no-undo .

        assign cNames = poJson:GetNames ()
               iNames = extent (cNames) .

        if iNames = ? then
            assign iNames = 0 .

        do iName = 1 to iNames:
            if not this-object:IsKnownField (cNames[iName], pcKnownFields) then
                assign cUnknown = cUnknown
                                + (if cUnknown = "":u then "":u else ",":u)
                                + pcPrefix + cNames[iName] .
        end.

        if cUnknown > "":u then
            undo, throw new UnknownFieldsException (cUnknown) .

    end method.

    /**
     * Purpose: Raises 400 when required fields are missing
     * Notes  :
     * @param poJson The request body
     * @param pcRequiredFields The comma separated list of the required field paths
     */
    method protected void CheckRequiredFields (poJson as JsonObject,
                                               pcRequiredFields as character):

        define variable cMissing as character no-undo .
        define variable iField   as integer   no-undo .
        define variable iFields  as integer   no-undo .

        assign iFields = num-entries (pcRequiredFields) .

        do iField = 1 to iFields:
            if not this-object:Has (poJson, entry (iField, pcRequiredFields)) then
                assign cMissing = cMissing
                                + (if cMissing = "":u then "":u else ",":u)
                                + entry (iField, pcRequiredFields) .
        end.

        if cMissing > "":u then
            undo, throw new RequiredFieldsException (cMissing) .

    end method.

    /**
     * Purpose: Returns if the payload contains a field
     * Notes  : A field sent as null is contained
     * @param poJson The request body
     * @param pcPath The field path, e.g. "Customer.CustNum"
     * @return Logical value indicating if the field is contained
     */
    method protected logical Has (poJson as JsonObject,
                                  pcPath as character):

        define variable oParent as JsonObject no-undo .
        define variable cName   as character  no-undo .

        assign oParent = this-object:ParentOf (poJson, pcPath, output cName) .

        return valid-object (oParent) and oParent:Has (cName) .

    end method.

    /**
     * Purpose: Returns the value of a character field
     * Notes  : null returns the unknown value
     * @param poJson The request body
     * @param pcPath The field path
     * @return The value
     */
    method protected character GetCharacter (poJson as JsonObject,
                                             pcPath as character):

        define variable oParent as JsonObject no-undo .
        define variable cName   as character  no-undo .

        assign oParent = this-object:ParentOf (poJson, pcPath, output cName) .

        if oParent:IsNull (cName) then
            return ? .

        return oParent:GetCharacter (cName) .

        catch err as Progress.Lang.SysError:
            undo, throw new InvalidFieldException (pcPath, substitute ("The field &1 must be a string.":u, pcPath)) .
        end catch.

    end method.

    /**
     * Purpose: Returns the value of an integer field
     * Notes  : null returns the unknown value
     * @param poJson The request body
     * @param pcPath The field path
     * @return The value
     */
    method protected integer GetInteger (poJson as JsonObject,
                                         pcPath as character):

        define variable oParent as JsonObject no-undo .
        define variable cName   as character  no-undo .

        assign oParent = this-object:ParentOf (poJson, pcPath, output cName) .

        if oParent:IsNull (cName) then
            return ? .

        return oParent:GetInteger (cName) .

        catch err as Progress.Lang.SysError:
            undo, throw new InvalidFieldException (pcPath, substitute ("The field &1 must be an integer number.":u, pcPath)) .
        end catch.

    end method.

    /**
     * Purpose: Returns the value of a date field (ISO 8601, YYYY-MM-DD)
     * Notes  : null returns the unknown value
     * @param poJson The request body
     * @param pcPath The field path
     * @return The value
     */
    method protected date GetDate (poJson as JsonObject,
                                   pcPath as character):

        define variable oParent as JsonObject no-undo .
        define variable cName   as character  no-undo .

        assign oParent = this-object:ParentOf (poJson, pcPath, output cName) .

        if oParent:IsNull (cName) then
            return ? .

        return oParent:GetDate (cName) .

        catch err as Progress.Lang.SysError:
            undo, throw new InvalidFieldException (pcPath, substitute ("The field &1 must be a date (YYYY-MM-DD).":u, pcPath)) .
        end catch.

    end method.

    /**
     * Purpose: Returns the nested JSON object of a field path
     * Notes  : Raises 400 when the nested field is not an object
     * @param poJson The request body
     * @param pcName The name of the nested object, e.g. "Customer"
     * @return The nested JSON object or ? when it is missing or null
     */
    method protected JsonObject GetObject (poJson as JsonObject,
                                           pcName as character):

        if not poJson:Has (pcName) or poJson:IsNull (pcName) then
            return ? .

        if poJson:GetType (pcName) <> JsonDataType:OBJECT then
            undo, throw new InvalidFieldException (pcName, substitute ("The field &1 must be an object.":u, pcName)) .

        return poJson:GetJsonObject (pcName) .

    end method.

    /**
     * Purpose: Returns if a field name is part of a list - case-sensitive
     * Notes  : LOOKUP alone is case-insensitive, JSON is not
     * @param pcName The field name
     * @param pcKnownFields The comma separated list of the known fields
     * @return Logical value indicating if the field is known
     */
    method private logical IsKnownField (pcName as character,
                                         pcKnownFields as character):

        define variable iIndex as integer no-undo .

        assign iIndex = lookup (pcName, pcKnownFields) .

        return iIndex > 0 and compare (entry (iIndex, pcKnownFields), "EQ":u, pcName, "CASE-SENSITIVE":u) .

    end method.

    /**
     * Purpose: Resolves a field path to the JSON object holding the field
     * Notes  : "CustNum" --> the request body, "Customer.CustNum" --> the
     *          nested Customer object
     * @param poJson The request body
     * @param pcPath The field path
     * @param pcName OUTPUT The name of the field inside the returned object
     * @return The JSON object holding the field or ? when it does not exist
     */
    method private JsonObject ParentOf (poJson as JsonObject,
                                        pcPath as character,
                                        output pcName as character):

        if num-entries (pcPath, ".":u) = 1 then do:
            assign pcName = pcPath .
            return poJson .
        end.

        assign pcName = entry (2, pcPath, ".":u) .

        return this-object:GetObject (poJson, entry (1, pcPath, ".":u)) .

    end method.

end class.
