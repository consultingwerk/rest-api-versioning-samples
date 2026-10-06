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
    File        : Demo.RestApiVersioning.Errors.VersionGoneException
    Purpose     : 410 Gone - the requested version of the API has been
                  switched off
    Syntax      :
    Description : When the request addresses a record, the response links
                  to the same record in the successor version:
                  Link: </web/v2/Orders/6>; rel="successor-version"
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.OERA.JsdoGenericService.WebHandler.* from propath.
using Demo.RestApiVersioning.Errors.*                     from propath.
using OpenEdge.Net.HTTP.*                                 from propath.

class Demo.RestApiVersioning.Errors.VersionGoneException
    inherits ApiException
    implements IHttp410Error
    serializable:

    /**
     * Purpose: Gets the URI of the addressed record in the successor
     *          version ("" when no record is addressed)
     * Notes  :
     */
    define public property SuccessorUri as character no-undo
    get.
    private set.

    /**
     * Purpose: Gets the media type of the successor version ("" for the
     *          URI based variants)
     * Notes  :
     */
    define public property SuccessorMediaType as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the VersionGoneException class
     * Notes  :
     * @param pcVersion The version that was requested, e.g. "v0"
     * @param pcSuccessorUri The URI of the addressed record in the successor version or ""
     * @param pcSuccessorMediaType The media type of the successor version or ""
     */
    constructor public VersionGoneException (pcVersion as character,
                                             pcSuccessorUri as character,
                                             pcSuccessorMediaType as character):

        super ("Gone":u,
               substitute ("Version &1 of the Orders API has been switched off. Please use version v2.":u,
                           pcVersion)) .

        assign this-object:SuccessorUri       = pcSuccessorUri
               this-object:SuccessorMediaType = pcSuccessorMediaType .

    end constructor.

    /**
     * Purpose: Adds the Link to the successor version to the error response
     * Notes  : RFC 5829 link relation "successor-version"
     * @param poResponse The error response
     */
    method override public void AddResponseHeaders (poResponse as IHttpResponse):

        define variable cLink as character no-undo .

        if this-object:SuccessorUri = "":u then
            return .

        assign cLink = substitute ("<&1>; rel=~"successor-version~"":u, this-object:SuccessorUri) .

        if this-object:SuccessorMediaType > "":u then
            assign cLink = cLink + substitute ("; type=~"&1~"":u, this-object:SuccessorMediaType) .

        poResponse:SetHeader (HttpHeaderBuilder:Build ("Link":u):Value (cLink):Header) .

    end method.

end class.
