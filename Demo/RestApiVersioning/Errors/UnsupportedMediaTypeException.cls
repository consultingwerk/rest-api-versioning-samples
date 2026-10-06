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
    File        : Demo.RestApiVersioning.Errors.UnsupportedMediaTypeException
    Purpose     : 415 Unsupported Media Type - the API cannot read the
                  Content-Type of the request body
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

class Demo.RestApiVersioning.Errors.UnsupportedMediaTypeException
    inherits ApiException
    implements IHttp415Error
    serializable:

    /**
     * Purpose: Constructor of the UnsupportedMediaTypeException class
     * Notes  :
     * @param pcContentType The Content-Type of the request
     * @param pcSupported The media types the API consumes
     */
    constructor public UnsupportedMediaTypeException (pcContentType as character,
                                                      pcSupported as character):

        super ("Unsupported Media Type":u,
               substitute ("The media type &1 is not supported. Supported media types: &2":u,
                           pcContentType,
                           pcSupported)) .

    end constructor.

end class.
