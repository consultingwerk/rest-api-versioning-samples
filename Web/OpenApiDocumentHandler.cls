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
    File        : Demo.RestApiVersioning.Web.OpenApiDocumentHandler
    Purpose     : Serves the hand-written OpenAPI documents of the Orders
                  API and a Swagger UI page listing them
    Syntax      :
    Description : Registered for /openapi and /openapi/{Document}
                  /openapi                               --> Swagger UI
                  /openapi/orders-mediatype.openapi.json --> media type variant
                  /openapi/orders-v1.openapi.json        --> URI variant, v1
                  /openapi/orders-v2.openapi.json        --> URI variant, v2
                  The documents are read from the propath
                  (Demo/RestApiVersioning/OpenApi)
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : The Swagger UI page loads Swagger UI from unpkg.com
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.OERA.JsdoGenericService.WebHandler.* from propath.
using Demo.RestApiVersioning.Errors.*                     from propath.
using OpenEdge.Net.HTTP.*                                 from propath.
using OpenEdge.Web.*                                      from propath.
using Progress.Json.ObjectModel.*                         from propath.

class Demo.RestApiVersioning.Web.OpenApiDocumentHandler
    inherits SmartWebHandler:

    /* Only these files are served - no path traversal */
    define private variable cDocuments as character no-undo
        initial "orders-mediatype.openapi.json,orders-v1.openapi.json,orders-v2.openapi.json":u .

    define private variable cFolder as character no-undo
        initial "Demo/RestApiVersioning/OpenApi/":u .

    /**
     * Purpose: Returns an OpenAPI document or the Swagger UI page
     * Notes  :
     * @param poRequest The web request
     * @return 0 - the response has been written
     */
    method override protected integer HandleGet (poRequest as IWebRequest):

        define variable cDocument as character     no-undo .
        define variable oResponse as IHttpResponse no-undo .

        assign cDocument = poRequest:GetPathParameter ("Document":u)
               oResponse = new WebResponse () .

        if cDocument = ? or cDocument = "":u then
            assign oResponse:ContentType = "text/html":u
                   oResponse:Entity      = this-object:GetSwaggerUiPage (poRequest) .
        else
            assign oResponse:ContentType = "application/json":u
                   oResponse:Entity      = this-object:GetDocument (cDocument) .

        assign oResponse:StatusCode = integer (StatusCodeEnum:OK) .

        this-object:WriteResponse (oResponse) .

        return 0 .

        catch err as Progress.Lang.Error:
            this-object:HandleError (err, ?) .
            return 0 .
        end catch.

    end method.

    /**
     * Purpose: Reads an OpenAPI document from the propath
     * Notes  : Raises 404 for any other file name
     * @param pcDocument The file name of the document
     * @return The OpenAPI document
     */
    method private JsonObject GetDocument (pcDocument as character):

        define variable cFile as character no-undo .

        if lookup (pcDocument, cDocuments) = 0 then
            undo, throw new NotFoundException (substitute ("The OpenAPI document &1 does not exist.":u, pcDocument)) .

        assign cFile = search (cFolder + pcDocument) .

        if cFile = ? then
            undo, throw new NotFoundException (substitute ("The OpenAPI document &1 is not deployed.":u, pcDocument)) .

        return cast (new ObjectModelParser ():ParseFile (cFile), JsonObject) .

    end method.

    /**
     * Purpose: Returns the Swagger UI page listing all OpenAPI documents
     * Notes  : The @BASE@ placeholder is replaced with the URI of this handler
     * @param poRequest The web request
     * @return The HTML page
     */
    method private OpenEdge.Core.String GetSwaggerUiPage (poRequest as IWebRequest):

        define variable lcPage as longchar  no-undo .
        define variable cFile  as character no-undo .

        assign cFile = search (cFolder + "swagger-ui.html":u) .

        if cFile = ? then
            undo, throw new NotFoundException ("The Swagger UI page is not deployed.":u) .

        copy-lob from file cFile to lcPage .

        assign lcPage = replace (lcPage,
                                 "@BASE@":u,
                                 substitute ("&1&2/openapi":u, poRequest:WebAppPath, poRequest:TransportPath)) .

        return new OpenEdge.Core.String (lcPage) .

    end method.

end class.
