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
    File        : Demo.RestApiVersioning.Errors.IProvidesResponseHeaders
    Purpose     : Implemented by errors that need HTTP headers on the error
                  response
    Syntax      :
    Description : 405 needs "Allow" (RFC 9110), 410 "Link" to the successor
                  version. The web handlers call AddResponseHeaders after
                  the problem details body was written
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using OpenEdge.Net.HTTP.* from propath.

interface Demo.RestApiVersioning.Errors.IProvidesResponseHeaders:

    /**
     * Purpose: Adds the headers of this error to the error response
     * Notes  :
     * @param poResponse The error response
     */
    method public void AddResponseHeaders (poResponse as IHttpResponse).

end interface.
