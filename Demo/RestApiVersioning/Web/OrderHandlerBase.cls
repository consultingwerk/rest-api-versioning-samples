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
    File        : Demo.RestApiVersioning.Web.OrderHandlerBase
    Purpose     : The HTTP flow of the Orders API - written once, for all
                  versions and all addressing variants
    Syntax      :
    Description : The subclasses only decide WHICH version a request
                  addresses (SelectVersion): by a fixed URI, by a {Version}
                  path parameter or by the media type.
                  GET          : read                    --> write
                  POST         : merge into a new order  --> create --> write
                  PUT / PATCH  : read --> merge          --> update --> write
                  DELETE       : 405 in every version
                  Errors       : RFC 9457 problem details
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : SmartWebHandler (SmartComponent Library) provides the
                  mapping of the IHttp<nnn>Error interfaces to the status
                  code and the RFC 9457 error handler
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.OERA.JsdoGenericService.WebHandler.* from propath.
using Demo.RestApiVersioning.Adapters.*                   from propath.
using Demo.RestApiVersioning.Errors.*                     from propath.
using Demo.RestApiVersioning.Order.*                      from propath.
using OpenEdge.Net.HTTP.*                                 from propath.
using OpenEdge.Web.*                                      from propath.
using Progress.Json.ObjectModel.*                         from propath.

class Demo.RestApiVersioning.Web.OrderHandlerBase
    inherits SmartWebHandler
    abstract:

    define private variable oOrderService as OrderService no-undo .

    /**
     * Purpose: Constructor of the OrderHandlerBase class
     * Notes  :
     */
    constructor public OrderHandlerBase ():

        super () .

        assign oOrderService = new OrderService () .

    end constructor.

    /***********************************************************************
        Section: Implemented by the addressing variants
     ***********************************************************************/

    /**
     * Purpose: Returns the reader and the writer of the version the request
     *          addresses
     * Notes  : Raises 410 for a switched-off version, 404 for an unknown
     *          version (URI), 406 / 415 for unsupported media types
     * @param poRequest The web request
     * @param poReader OUTPUT The reader for the request body (? when the request has no body)
     * @param poWriter OUTPUT The writer for the response
     */
    method protected abstract void SelectVersion (poRequest as IWebRequest,
                                                  output poReader as IOrderReader,
                                                  output poWriter as IOrderWriter).

    /***********************************************************************
        Section: The HTTP flow
     ***********************************************************************/

    /**
     * Purpose: GET /Orders and GET /Orders/{Ordernum}
     * Notes  :
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method protected integer ProcessGet (poRequest as IWebRequest):

        define variable oReader as IOrderReader no-undo .
        define variable oWriter as IOrderWriter no-undo .

        this-object:SelectVersion (poRequest, output oReader, output oWriter) .

        if this-object:IsCollection (poRequest) then
            return this-object:Send (this-object:CreateResponse (StatusCodeEnum:OK,
                                                                 this-object:WriteCollection (poRequest, oWriter),
                                                                 oWriter)) .

        return this-object:Send (this-object:CreateResponse (StatusCodeEnum:OK,
                                                             oWriter:Write (oOrderService:GetOrder (this-object:GetOrdernum (poRequest))),
                                                             oWriter)) .

    end method.

    /**
     * Purpose: POST /Orders
     * Notes  : 201 Created with a Location header
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method protected integer ProcessPost (poRequest as IWebRequest):

        define variable oReader   as IOrderReader  no-undo .
        define variable oWriter   as IOrderWriter  no-undo .
        define variable oOrder    as OrderHeader   no-undo .
        define variable oResponse as IHttpResponse no-undo .
        define variable cLocation as character     no-undo .

        this-object:SelectVersion (poRequest, output oReader, output oWriter) .

        if not this-object:IsCollection (poRequest) then
            undo, throw new MethodNotAllowedException (this-object:AllowedMethods (poRequest)) .

        assign oOrder = new OrderHeader () .

        oReader:Merge (this-object:GetBody (poRequest), oOrder, MergeMode:Create) .

        assign oOrder    = oOrderService:CreateOrder (oOrder)
               oResponse = this-object:CreateResponse (StatusCodeEnum:Created, oWriter:Write (oOrder), oWriter) .

        assign cLocation = substitute ("&1/&2":u, poRequest:URI:Path, oOrder:Ordernum) .

        oResponse:SetHeader (HttpHeaderBuilder:Build ("Location":u):Value (cLocation):Header) .

        return this-object:Send (oResponse) .

    end method.

    /**
     * Purpose: PUT /Orders/{Ordernum} - the complete representation
     * Notes  :
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method protected integer ProcessPut (poRequest as IWebRequest):

        return this-object:ProcessUpdate (poRequest, MergeMode:Replace) .

    end method.

    /**
     * Purpose: PATCH /Orders/{Ordernum} - only the fields in the payload
     * Notes  :
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method protected integer ProcessPatch (poRequest as IWebRequest):

        return this-object:ProcessUpdate (poRequest, MergeMode:Patch) .

    end method.

    /**
     * Purpose: DELETE - not part of any version of the API
     * Notes  : A switched-off version still answers 410 Gone
     * @param poRequest The web request
     * @return Never returns, raises 405 Method Not Allowed
     */
    method protected integer ProcessDelete (poRequest as IWebRequest):

        define variable oReader as IOrderReader no-undo .
        define variable oWriter as IOrderWriter no-undo .

        this-object:SelectVersion (poRequest, output oReader, output oWriter) .

        undo, throw new MethodNotAllowedException (this-object:AllowedMethods (poRequest)) .

    end method.

    /**
     * Purpose: Read - merge - write: PUT and PATCH
     * Notes  : Reading the current order first means that fields a client
     *          does not know (WarehouseNum for v2) are never lost
     * @param poRequest The web request
     * @param peMode Replace (PUT) or Patch (PATCH)
     * @return 0 - the response has been written
     */
    method private integer ProcessUpdate (poRequest as IWebRequest,
                                          peMode as MergeMode):

        define variable oReader as IOrderReader no-undo .
        define variable oWriter as IOrderWriter no-undo .
        define variable oOrder  as OrderHeader  no-undo .

        this-object:SelectVersion (poRequest, output oReader, output oWriter) .

        if this-object:IsCollection (poRequest) then
            undo, throw new MethodNotAllowedException (this-object:AllowedMethods (poRequest)) .

        assign oOrder = oOrderService:GetOrder (this-object:GetOrdernum (poRequest)) .   /* read  */

        oReader:Merge (this-object:GetBody (poRequest), oOrder, peMode) .                 /* merge */

        assign oOrder = oOrderService:UpdateOrder (oOrder) .                              /* write */

        return this-object:Send (this-object:CreateResponse (StatusCodeEnum:OK, oWriter:Write (oOrder), oWriter)) .

    end method.

    /***********************************************************************
        Section: Errors
     ***********************************************************************/

    /**
     * Purpose: Raises 405 for every method without a handler method
     * Notes  : With the Allow header (RFC 9110)
     * @param poRequest The web request
     * @return Never returns
     */
    method override protected integer HandleNotAllowedMethod (poRequest as IWebRequest):

        undo, throw new MethodNotAllowedException (this-object:AllowedMethods (poRequest)) .

    end method.

    /**
     * Purpose: Writes every error as an RFC 9457 problem details response
     * Notes  : Called by OpenEdge.Web.WebHandler for every error raised by
     *          a Handle... method. The response carries the headers of the
     *          error (Allow, Link) and of the version (Deprecation, Vary)
     * @param poError The error
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method override protected integer HandleException (poError as Progress.Lang.Error,
                                                       poRequest as IWebRequest):

        define variable oReader   as IOrderReader        no-undo .
        define variable oWriter   as IOrderWriter        no-undo .
        define variable oError    as Progress.Lang.Error no-undo .
        define variable oResponse as IHttpResponse       no-undo .

        /* The version of the request - for field names and version headers */
        do on error undo, throw:
            this-object:SelectVersion (poRequest, output oReader, output oWriter) .

            catch uncaught as Progress.Lang.Error:
                /* the version itself is the problem (404, 406, 410, 415) */
                assign oWriter = ? .
            end catch.
        end.

        assign oError    = this-object:ToApiError (poError, oReader)
               oResponse = new WebResponse () .

        /* status code, type, title, status, detail, errors */
        this-object:InvokeErrorHandler (oError, oResponse) .

        if type-of (oError, IProvidesResponseHeaders) then
            cast (oError, IProvidesResponseHeaders):AddResponseHeaders (oResponse) .

        this-object:AddResponseHeaders (oResponse, oWriter) .

        return this-object:Send (oResponse) .

    end method.

    /**
     * Purpose: Writes the RFC 9457 problem details into the response
     * Notes  : Uses the Rfc7807WebErrorHandler directly, independent of the
     *          error handler registered for the application
     * @param poError The error
     * @param poResponse The response
     */
    method override protected void InvokeErrorHandler (poError as Progress.Lang.Error,
                                                       poResponse as IHttpResponse):

        define variable oErrorHandler as ISmartWebErrorHandler no-undo .

        assign oErrorHandler = new Rfc7807WebErrorHandler () .

        oErrorHandler:HandleError (poError, poResponse) .

    end method.

    /**
     * Purpose: Translates the errors of the business logic into errors of
     *          the API
     * Notes  : The business logic knows nothing about HTTP - and reports
     *          field names of the model. The client gets its own names
     * @param poError The error
     * @param poReader The reader of the request version (may be ?)
     * @return The error to report to the client
     */
    method protected Progress.Lang.Error ToApiError (poError as Progress.Lang.Error,
                                                     poReader as IOrderReader):

        define variable cFieldName as character no-undo .

        if type-of (poError, OrderNotFoundException) then
            return new NotFoundException (poError:GetMessage (1)) .

        if type-of (poError, OrderValidationException) then do:
            assign cFieldName = cast (poError, OrderValidationException):FieldName .

            if valid-object (poReader) then
                assign cFieldName = poReader:ExternalFieldName (cFieldName) .

            return new InvalidFieldException (cFieldName, cast (poError, OrderValidationException):ValidationMessage) .
        end.

        return poError .

    end method.

    /***********************************************************************
        Section: Responses
     ***********************************************************************/

    /**
     * Purpose: Creates a JSON response
     * Notes  :
     * @param peStatusCode The HTTP status code
     * @param poJson The response body
     * @param poWriter The writer of the response version
     * @return The response
     */
    method protected IHttpResponse CreateResponse (peStatusCode as StatusCodeEnum,
                                                   poJson as JsonObject,
                                                   poWriter as IOrderWriter):

        define variable oResponse as IHttpResponse no-undo .

        assign oResponse             = new WebResponse ()
               oResponse:StatusCode  = integer (peStatusCode)
               oResponse:ContentType = this-object:ResponseContentType (poWriter)
               oResponse:Entity      = poJson .

        this-object:AddResponseHeaders (oResponse, poWriter) .

        return oResponse .

    end method.

    /**
     * Purpose: Returns the Content-Type of the responses
     * Notes  : application/json for the URI based variants, the media type
     *          variant overrides it
     * @param poWriter The writer of the response version
     * @return The Content-Type
     */
    method protected character ResponseContentType (poWriter as IOrderWriter):

        return "application/json":u .

    end method.

    /**
     * Purpose: Adds the headers of the response version
     * Notes  : v1: Deprecation, Sunset, Link. The media type variant adds
     *          Vary: Accept
     * @param poResponse The response
     * @param poWriter The writer of the response version (may be ?)
     */
    method protected void AddResponseHeaders (poResponse as IHttpResponse,
                                              poWriter as IOrderWriter):

        if valid-object (poWriter) then
            poWriter:AddResponseHeaders (poResponse) .

    end method.

    /**
     * Purpose: Writes the response
     * Notes  :
     * @param poResponse The response
     * @return 0 - the response has been written
     */
    method protected integer Send (poResponse as IHttpResponse):

        this-object:WriteResponse (poResponse) .

        return 0 .

    end method.

    /**
     * Purpose: Writes a page of orders
     * Notes  : Query parameters skip (default 0) and top (default 10, max 100)
     * @param poRequest The web request
     * @param poWriter The writer of the response version
     * @return { "Orders": [...], "Skip": 0, "Top": 10, "Next": "..." }
     */
    method protected JsonObject WriteCollection (poRequest as IWebRequest,
                                                 poWriter as IOrderWriter):

        define variable oOrders as OrderHeader no-undo extent .
        define variable oArray  as JsonArray   no-undo .
        define variable oJson   as JsonObject  no-undo .
        define variable iSkip   as integer     no-undo .
        define variable iTop    as integer     no-undo .
        define variable iCount  as integer     no-undo .
        define variable i       as integer     no-undo .

        assign iSkip = this-object:GetQueryInteger (poRequest, "skip":u, 0)
               iTop  = this-object:GetQueryInteger (poRequest, "top":u, 10) .

        if iSkip < 0 then
            undo, throw new InvalidFieldException ("skip":u, "skip must not be negative.":u) .

        if iTop < 1 or iTop > 100 then
            undo, throw new InvalidFieldException ("top":u, "top must be between 1 and 100.":u) .

        assign oOrders = oOrderService:GetOrders (iSkip, iTop)
               iCount  = extent (oOrders)
               oArray  = new JsonArray ()
               oJson   = new JsonObject () .

        if iCount = ? then
            assign iCount = 0 .

        do i = 1 to iCount:
            oArray:Add (poWriter:Write (oOrders[i])) .
        end.

        oJson:Add ("Orders":u, oArray) .
        oJson:Add ("Skip":u, iSkip) .
        oJson:Add ("Top":u, iTop) .

        if iCount = iTop then
            oJson:Add ("Next":u, substitute ("&1?skip=&2&&top=&3":u, poRequest:URI:Path, iSkip + iTop, iTop)) .

        return oJson .

    end method.

    /***********************************************************************
        Section: Request helpers
     ***********************************************************************/

    /**
     * Purpose: Returns the methods the addressed resource supports
     * Notes  : Value of the Allow header of a 405 response
     * @param poRequest The web request
     * @return "GET, POST" for the collection, "GET, PUT, PATCH" for an order
     */
    method protected character AllowedMethods (poRequest as IWebRequest):

        if this-object:IsCollection (poRequest) then
            return "GET, POST":u .

        return "GET, PUT, PATCH":u .

    end method.

    /**
     * Purpose: Returns if the request addresses the collection (/Orders)
     *          rather than a single order (/Orders/{Ordernum})
     * Notes  :
     * @param poRequest The web request
     * @return Logical value indicating if the collection is addressed
     */
    method protected logical IsCollection (poRequest as IWebRequest):

        define variable cOrdernum as character no-undo .

        assign cOrdernum = poRequest:GetPathParameter ("Ordernum":u) .

        return cOrdernum = ? or cOrdernum = "":u .

    end method.

    /**
     * Purpose: Returns the URI of the addressed order in another version
     * Notes  : "" when the collection is addressed
     * @param poRequest The web request
     * @param pcCollectionPath The path of the collection in the other version, e.g. "/v2/Orders"
     * @return The URI, e.g. "/web/v2/Orders/6"
     */
    method protected character RecordUri (poRequest as IWebRequest,
                                          pcCollectionPath as character):

        if this-object:IsCollection (poRequest) then
            return "":u .

        return substitute ("&1&2&3/&4":u,
                           poRequest:WebAppPath,
                           poRequest:TransportPath,
                           pcCollectionPath,
                           poRequest:GetPathParameter ("Ordernum":u)) .

    end method.

    /**
     * Purpose: Returns the order number of the request
     * Notes  : Raises 400 when it is not a number
     * @param poRequest The web request
     * @return The order number
     */
    method protected integer GetOrdernum (poRequest as IWebRequest):

        return integer (poRequest:GetPathParameter ("Ordernum":u)) .

        catch err as Progress.Lang.SysError:
            undo, throw new InvalidFieldException ("Ordernum":u, "The order number must be an integer number.":u) .
        end catch.

    end method.

    /**
     * Purpose: Returns the request body
     * Notes  : PASOE delivers a JsonObject for application/json and for
     *          application/vnd...+json alike. Raises 400 otherwise
     * @param poRequest The web request
     * @return The request body
     */
    method protected JsonObject GetBody (poRequest as IWebRequest):

        if not type-of (poRequest:Entity, JsonObject) then
            undo, throw new InvalidRequestBodyException () .

        return cast (poRequest:Entity, JsonObject) .

    end method.

    /**
     * Purpose: Returns an integer query parameter
     * Notes  : Raises 400 when it is not a number
     * @param poRequest The web request
     * @param pcName The name of the query parameter
     * @param piDefault The value when the parameter is missing
     * @return The value
     */
    method protected integer GetQueryInteger (poRequest as IWebRequest,
                                              pcName as character,
                                              piDefault as integer):

        define variable cValue as character no-undo .

        assign cValue = this-object:GetDecodedQueryValue (poRequest, pcName) .

        if cValue = ? or cValue = "":u then
            return piDefault .

        return integer (cValue) .

        catch err as Progress.Lang.SysError:
            undo, throw new InvalidFieldException (pcName, substitute ("&1 must be an integer number.":u, pcName)) .
        end catch.

    end method.

end class.
