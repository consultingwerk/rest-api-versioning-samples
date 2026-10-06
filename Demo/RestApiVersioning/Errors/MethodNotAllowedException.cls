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
    File        : Demo.RestApiVersioning.Errors.MethodNotAllowedException
    Purpose     : 405 Method Not Allowed - including the Allow header
    Syntax      :
    Description : RFC 9110 (15.5.6): the origin server MUST generate an
                  Allow header field in a 405 response containing a list of
                  the target resource's currently supported methods
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Exceptions.*                         from propath.
using Consultingwerk.OERA.JsdoGenericService.WebHandler.* from propath.
using Demo.RestApiVersioning.Errors.*                     from propath.
using OpenEdge.Net.HTTP.*                                 from propath.

class Demo.RestApiVersioning.Errors.MethodNotAllowedException
    inherits HttpMethodNotAllowedException
    implements IErrorTitle, IProvidesResponseHeaders
    serializable:

    /**
     * Purpose: Gets the methods the resource supports, e.g. "GET, POST"
     * Notes  : Value of the Allow header
     */
    define public property Allow as character no-undo
    get.
    private set.

    /**
     * Purpose: Gets the short, human readable summary of the problem
     * Notes  : "title" of the problem details
     */
    define public property Title as character no-undo initial "Method Not Allowed":u
    get.

    /**
     * Purpose: Constructor of the MethodNotAllowedException class
     * Notes  :
     * @param pcAllow The methods the resource supports, e.g. "GET, POST"
     */
    constructor public MethodNotAllowedException (pcAllow as character):

        super () .

        assign this-object:Allow = pcAllow .

        this-object:AddMessage (substitute ("Allowed methods: &1":u, pcAllow), 0) .

    end constructor.

    /**
     * Purpose: Adds the Allow header to the error response
     * Notes  :
     * @param poResponse The error response
     */
    method public void AddResponseHeaders (poResponse as IHttpResponse):

        poResponse:SetHeader (HttpHeaderBuilder:Build ("Allow":u):Value (this-object:Allow):Header) .

    end method.

end class.
