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
    File        : Demo.RestApiVersioning.Errors.UnknownFieldsException
    Purpose     : 400 Bad Request - the payload contains fields that are not
                  part of the schema of the requested version
    Syntax      :
    Description : One entry in "errors" per unknown field, e.g. WarehouseNum
                  sent to version 2
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.OERA.JsdoGenericService.WebHandler.* from propath.
using Demo.RestApiVersioning.Errors.*                     from propath.

class Demo.RestApiVersioning.Errors.UnknownFieldsException
    inherits ApiException
    implements IHttp400Error
    serializable:

    /**
     * Purpose: Gets the comma separated list of the unknown fields
     * Notes  :
     */
    define public property FieldNames as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the UnknownFieldsException class
     * Notes  :
     * @param pcFieldNames The comma separated list of the unknown fields
     */
    constructor public UnknownFieldsException (pcFieldNames as character):

        define variable iField  as integer no-undo .
        define variable iFields as integer no-undo .

        super ("Unknown field":u) .

        assign this-object:FieldNames = pcFieldNames
               iFields                = num-entries (pcFieldNames) .

        do iField = 1 to iFields:
            this-object:AddFieldMessage (substitute ("The field &1 is not part of this version of the API.":u,
                                                     entry (iField, pcFieldNames)),
                                         entry (iField, pcFieldNames)) .
        end.

    end constructor.

end class.
