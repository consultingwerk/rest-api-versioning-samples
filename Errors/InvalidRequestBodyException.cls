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
    File        : Demo.RestApiVersioning.Errors.InvalidRequestBodyException
    Purpose     : 400 Bad Request - the request body is not a JSON object
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.OERA.JsdoGenericService.WebHandler.* from propath.
using Demo.RestApiVersioning.Errors.*                     from propath.

class Demo.RestApiVersioning.Errors.InvalidRequestBodyException
    inherits ApiException
    implements IHttp400Error
    serializable:

    /**
     * Purpose: Constructor of the InvalidRequestBodyException class
     * Notes  :
     */
    constructor public InvalidRequestBodyException ():

        super ("Invalid request body":u,
               "The request body must be a JSON object.":u) .

    end constructor.

end class.
