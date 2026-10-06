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
    File        : Demo.RestApiVersioning.Simple.SimpleOrderMediaTypeHandler
    Purpose     : A minimal media type versioned web handler - the Accept
                  header of a GET selects the v1 or the v2 representation
    Syntax      :
    Description : Registered for /simple/media/Orders/{Ordernum}. Reads the
                  Order and Customer records directly.
                  ...order.v1+json                   --> v1 (flat)
                  ...order.v2+json, application/json,
                  wildcard or no Accept              --> v2 (nested)
                  anything else                      --> 406
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : Simplified: no q-values (see MediaType.MediaTypeNegotiator
                  for the complete negotiation). Uses the VAR statement
                  (OpenEdge 12.3 and later)
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Simple.* from propath.
using OpenEdge.Net.HTTP.*             from propath.
using OpenEdge.Web.*                  from propath.
using Progress.Json.ObjectModel.*     from propath.

class Demo.RestApiVersioning.Simple.SimpleOrderMediaTypeHandler
    inherits WebHandler:

    /**
     * Purpose: Any method this handler does not implement: 405
     * Notes  :
     * @param poRequest The web request
     * @return The HTTP status code
     */
    method override protected integer HandleNotAllowedMethod (poRequest as IWebRequest):

        return integer (StatusCodeEnum:MethodNotAllowed) .

    end method.

    /**
     * Purpose: Any method PASOE does not know: 501
     * Notes  :
     * @param poRequest The web request
     * @return The HTTP status code
     */
    method override protected integer HandleNotImplemented (poRequest as IWebRequest):

        return integer (StatusCodeEnum:NotImplemented) .

    end method.

    /**
     * Purpose: GET /simple/media/Orders/{Ordernum}
     * Notes  : The Accept header selects the version
     * @param poRequest The web request
     * @return 0 - the response has been written, or an HTTP status code
     */
    method override protected integer HandleGet (poRequest as IWebRequest):

        var integer           iOrdernum = integer (poRequest:GetPathParameter ("Ordernum":u)) .
        var character         cAccept   = "":u .
        var character         cMediaType .
        var JsonObject        oOrder .
        var WebResponse       oResponse = new WebResponse () .
        var WebResponseWriter oWriter .

        if poRequest:HasHeader ("Accept":u) then
            cAccept = poRequest:GetHeader ("Accept":u):Value .

        find Order where Order.Ordernum = iOrdernum no-lock no-error .
        if not available Order then
            return integer (StatusCodeEnum:NotFound) .

        find Customer where Customer.CustNum = Order.CustNum no-lock no-error .

        if index (cAccept, "application/vnd.sports2000.order.v1+json":u) > 0 then
            assign cMediaType = "application/vnd.sports2000.order.v1+json":u
                   oOrder     = SimpleOrderJson:WriteV1 (buffer Order, buffer Customer) .
        else if cAccept = "":u or index (cAccept, "application/vnd.sports2000.order.v2+json":u) > 0
             or index (cAccept, "application/json":u) > 0 or index (cAccept, "*/*":u) > 0 then
            assign cMediaType = "application/vnd.sports2000.order.v2+json":u
                   oOrder     = SimpleOrderJson:WriteV2 (buffer Order, buffer Customer) .
        else
            return integer (StatusCodeEnum:NotAcceptable) .

        assign oResponse:StatusCode  = integer (StatusCodeEnum:OK)
               oResponse:ContentType = cMediaType
               oResponse:Entity      = oOrder .

        /* the response depends on the Accept header - tell the caches */
        oResponse:SetHeader (HttpHeaderBuilder:Build ("Vary":u):Value ("Accept":u):Header) .

        oWriter = new WebResponseWriter (oResponse) .
        oWriter:Open () .
        oWriter:Close () .

        return 0 .

    end method.

end class.
