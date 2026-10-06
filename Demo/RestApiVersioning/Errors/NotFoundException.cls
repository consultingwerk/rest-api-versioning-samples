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
    File        : Demo.RestApiVersioning.Errors.NotFoundException
    Purpose     : 404 Not Found - unknown order or unknown API version
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

class Demo.RestApiVersioning.Errors.NotFoundException
    inherits ApiException
    implements IHttp404Error
    serializable:

    /**
     * Purpose: Constructor of the NotFoundException class
     * Notes  :
     * @param pcDetail The explanation of what was not found
     */
    constructor public NotFoundException (pcDetail as character):

        super ("Not Found":u, pcDetail) .

    end constructor.

end class.
