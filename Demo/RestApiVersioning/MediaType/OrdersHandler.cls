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
    File        : Demo.RestApiVersioning.MediaType.OrdersHandler
    Purpose     : The Orders API without a version in the URI - the media
                  type selects the version
    Syntax      :
    Description : Registered for /Orders and /Orders/{Ordernum}.
                  Accept       --> version of the response
                  Content-Type --> version of the request body
                  Both may differ: send v1, receive v2
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : Every response carries "Vary: Accept" - caches must not
                  serve a v1 response to a v2 client
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Adapters.*  from propath.
using Demo.RestApiVersioning.Errors.*    from propath.
using Demo.RestApiVersioning.MediaType.* from propath.
using Demo.RestApiVersioning.Web.*       from propath.
using OpenEdge.Net.HTTP.*                from propath.
using OpenEdge.Web.*                     from propath.

class Demo.RestApiVersioning.MediaType.OrdersHandler
    inherits OrderHandlerBase:

    define private variable oNegotiator as MediaTypeNegotiator no-undo .

    /**
     * Purpose: Constructor of the OrdersHandler class
     * Notes  :
     */
    constructor public OrdersHandler ():

        super () .

        assign oNegotiator = new MediaTypeNegotiator () .

    end constructor.

    /**
     * Purpose: Returns the reader and the writer of the negotiated versions
     * Notes  : Accept selects the writer, Content-Type the reader
     * @param poRequest The web request
     * @param poReader OUTPUT The reader for the request body (? without body)
     * @param poWriter OUTPUT The writer for the response
     */
    method override protected void SelectVersion (poRequest as IWebRequest,
                                                  output poReader as IOrderReader,
                                                  output poWriter as IOrderWriter):

        define variable cAccept as character no-undo .

        if poRequest:HasHeader ("Accept":u) then
            assign cAccept = poRequest:GetHeader ("Accept":u):Value .

        /* the response: the version the client accepts */
        case oNegotiator:SelectResponseVersion (cAccept):
            when "v0":u then
                undo, throw new VersionGoneException ("v0":u,
                                                      this-object:RecordUri (poRequest, "/Orders":u),
                                                      "application/vnd.sports2000.order.v2+json":u) .
            when "v1":u then
                assign poWriter = new OrderV1Writer () .
            when "v2":u then
                assign poWriter = new OrderV2Writer () .
        end case.

        if not this-object:HasBody (poRequest) then
            return .

        /* the request body: the version the client sent */
        case oNegotiator:SelectRequestVersion (poRequest:ContentType):
            when "v0":u then
                undo, throw new VersionGoneException ("v0":u,
                                                      this-object:RecordUri (poRequest, "/Orders":u),
                                                      "application/vnd.sports2000.order.v2+json":u) .
            when "v1":u then
                assign poReader = new OrderV1Reader () .
            when "v2":u then
                assign poReader = new OrderV2Reader () .
        end case.

    end method.

    /**
     * Purpose: Returns the Content-Type of the responses
     * Notes  : The negotiated media type
     * @param poWriter The writer of the response version
     * @return The Content-Type
     */
    method override protected character ResponseContentType (poWriter as IOrderWriter):

        return poWriter:MediaType .

    end method.

    /**
     * Purpose: Adds the headers of the response version plus Vary: Accept
     * Notes  : On every response - success and error
     * @param poResponse The response
     * @param poWriter The writer of the response version (may be ?)
     */
    method override protected void AddResponseHeaders (poResponse as IHttpResponse,
                                                       poWriter as IOrderWriter):

        super:AddResponseHeaders (poResponse, poWriter) .

        poResponse:SetHeader (HttpHeaderBuilder:Build ("Vary":u):Value ("Accept":u):Header) .

    end method.

    /**
     * Purpose: Handles GET requests
     * Notes  :
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method override protected integer HandleGet (poRequest as IWebRequest):

        return this-object:ProcessGet (poRequest) .

    end method.

    /**
     * Purpose: Handles POST requests
     * Notes  :
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method override protected integer HandlePost (poRequest as IWebRequest):

        return this-object:ProcessPost (poRequest) .

    end method.

    /**
     * Purpose: Handles PUT requests
     * Notes  :
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method override protected integer HandlePut (poRequest as IWebRequest):

        return this-object:ProcessPut (poRequest) .

    end method.

    /**
     * Purpose: Handles PATCH requests
     * Notes  :
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method override protected integer HandlePatch (poRequest as IWebRequest):

        return this-object:ProcessPatch (poRequest) .

    end method.

    /**
     * Purpose: Handles DELETE requests - 405 Method Not Allowed
     * Notes  :
     * @param poRequest The web request
     * @return Never returns
     */
    method override protected integer HandleDelete (poRequest as IWebRequest):

        return this-object:ProcessDelete (poRequest) .

    end method.

    /**
     * Purpose: Returns if the request carries a body to read
     * Notes  :
     * @param poRequest The web request
     * @return Logical value indicating if the request has a body
     */
    method private logical HasBody (poRequest as IWebRequest):

        return lookup (poRequest:Method, "POST,PUT,PATCH":u) > 0 .

    end method.

end class.
