/**********************************************************************
 MIT License

 Copyright (c) 2026 Consultingwerk - Software Architecture and Development

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
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
