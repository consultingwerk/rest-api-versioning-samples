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
    File        : Demo.RestApiVersioning.Errors.NotAcceptableException
    Purpose     : 406 Not Acceptable - the API cannot produce any of the
                  media types in the Accept header
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

class Demo.RestApiVersioning.Errors.NotAcceptableException
    inherits ApiException
    implements IHttp406Error
    serializable:

    /**
     * Purpose: Constructor of the NotAcceptableException class
     * Notes  :
     * @param pcAccept The Accept header of the request
     * @param pcSupported The media types the API produces
     */
    constructor public NotAcceptableException (pcAccept as character,
                                               pcSupported as character):

        super ("Not Acceptable":u,
               substitute ("None of the media types &1 is supported. Supported media types: &2":u,
                           pcAccept,
                           pcSupported)) .

    end constructor.

end class.
