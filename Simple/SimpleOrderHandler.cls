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
    File        : Demo.RestApiVersioning.Simple.SimpleOrderHandler
    Purpose     : A minimal PASOE web handler - before any versioning
    Syntax      :
    Description : Registered for /simple/Orders/{Ordernum}. No database
                  access: GET returns a constant order, PUT echoes the body
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : Uses the VAR statement (OpenEdge 12.3 and later)
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using OpenEdge.Net.HTTP.*         from propath.
using OpenEdge.Web.*              from propath.
using Progress.Json.ObjectModel.* from propath.

class Demo.RestApiVersioning.Simple.SimpleOrderHandler
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
     * Purpose: GET /simple/Orders/{Ordernum}
     * Notes  : No database access
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method override protected integer HandleGet (poRequest as IWebRequest):

        var integer           iOrdernum = integer (poRequest:GetPathParameter ("Ordernum":u)) .
        var JsonObject        oOrder    = new JsonObject () .
        var WebResponse       oResponse = new WebResponse () .
        var WebResponseWriter oWriter .

        oOrder:Add ("Ordernum":u, iOrdernum) .
        oOrder:Add ("OrderStatus":u, "Shipped":u) .

        assign oResponse:StatusCode  = integer (StatusCodeEnum:OK)
               oResponse:ContentType = "application/json":u
               oResponse:Entity      = oOrder .

        oWriter = new WebResponseWriter (oResponse) .
        oWriter:Open () .
        oWriter:Close () .

        return 0 .

    end method.

    /**
     * Purpose: PUT /simple/Orders/{Ordernum} - echoes what the client sent
     * Notes  : No database access
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method override protected integer HandlePut (poRequest as IWebRequest):

        var character         cContentType = poRequest:ContentType .
        var character         cAccept .
        var JsonObject        oEcho        = new JsonObject () .
        var WebResponse       oResponse    = new WebResponse () .
        var WebResponseWriter oWriter .

        if poRequest:HasHeader ("Accept":u) then
            cAccept = poRequest:GetHeader ("Accept":u):Value .

        oEcho:Add ("ContentType":u, cContentType) .
        oEcho:Add ("Accept":u, cAccept) .
        oEcho:Add ("Body":u, cast (poRequest:Entity, JsonObject)) .

        assign oResponse:StatusCode  = integer (StatusCodeEnum:OK)
               oResponse:ContentType = "application/json":u
               oResponse:Entity      = oEcho .

        oWriter = new WebResponseWriter (oResponse) .
        oWriter:Open () .
        oWriter:Close () .

        return 0 .

    end method.

end class.
