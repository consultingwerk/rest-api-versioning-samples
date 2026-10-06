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
    File        : Demo.RestApiVersioning.Errors.InvalidFieldException
    Purpose     : 400 Bad Request - a field (or query parameter) has an
                  invalid value
    Syntax      :
    Description : Wrong JSON type, violated business rule, invalid paging
                  parameter. The field name is the one the client knows
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.OERA.JsdoGenericService.WebHandler.* from propath.
using Demo.RestApiVersioning.Errors.*                     from propath.

class Demo.RestApiVersioning.Errors.InvalidFieldException
    inherits ApiException
    implements IHttp400Error
    serializable:

    /**
     * Purpose: Gets the name of the invalid field
     * Notes  :
     */
    define public property FieldName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the InvalidFieldException class
     * Notes  :
     * @param pcFieldName The name of the invalid field
     * @param pcMessage The description of the problem
     */
    constructor public InvalidFieldException (pcFieldName as character,
                                              pcMessage as character):

        super ("Invalid field value":u) .

        assign this-object:FieldName = pcFieldName .

        this-object:AddFieldMessage (pcMessage, pcFieldName) .

    end constructor.

end class.
