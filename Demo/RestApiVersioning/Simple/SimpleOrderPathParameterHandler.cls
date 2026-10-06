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
    File        : Demo.RestApiVersioning.Simple.SimpleOrderPathParameterHandler
    Purpose     : A minimal URI versioned web handler - the version is a
                  path parameter of a GET
    Syntax      :
    Description : Registered for /simple/{Version}/Orders/{Ordernum}. Reads
                  the Order and Customer records directly.
                  v0    --> 410 Gone
                  v1    --> flat representation
                  v2    --> nested representation
                  other --> 404
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : Uses the VAR statement (OpenEdge 12.3 and later)
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Simple.* from propath.
using OpenEdge.Net.HTTP.*             from propath.
using OpenEdge.Web.*                  from propath.
using Progress.Json.ObjectModel.*     from propath.

class Demo.RestApiVersioning.Simple.SimpleOrderPathParameterHandler
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
     * Purpose: GET /simple/{Version}/Orders/{Ordernum}
     * Notes  : The path parameter Version selects the version
     * @param poRequest The web request
     * @return 0 - the response has been written, or an HTTP status code
     */
    method override protected integer HandleGet (poRequest as IWebRequest):

        var character         cVersion  = poRequest:GetPathParameter ("Version":u) .
        var integer           iOrdernum = integer (poRequest:GetPathParameter ("Ordernum":u)) .
        var JsonObject        oOrder .
        var WebResponse       oResponse = new WebResponse () .
        var WebResponseWriter oWriter .

        find Order where Order.Ordernum = iOrdernum no-lock no-error .
        if not available Order then
            return integer (StatusCodeEnum:NotFound) .

        find Customer where Customer.CustNum = Order.CustNum no-lock no-error .

        case cVersion:
            when "v0":u then    /* switched off */
                return integer (StatusCodeEnum:Gone) .
            when "v1":u then    /* deprecated - flat */
                oOrder = SimpleOrderJson:WriteV1 (buffer Order, buffer Customer) .
            when "v2":u then    /* current - nested Customer */
                oOrder = SimpleOrderJson:WriteV2 (buffer Order, buffer Customer) .
            otherwise
                return integer (StatusCodeEnum:NotFound) .
        end case.

        assign oResponse:StatusCode  = integer (StatusCodeEnum:OK)
               oResponse:ContentType = "application/json":u
               oResponse:Entity      = oOrder .

        oWriter = new WebResponseWriter (oResponse) .
        oWriter:Open () .
        oWriter:Close () .

        return 0 .

    end method.

end class.
