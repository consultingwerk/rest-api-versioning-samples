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
    File        : Demo.RestApiVersioning.UriVersion.OrdersHandler
    Purpose     : The service interface of the Orders API: ONE web handler,
                  the version is a path parameter
    Syntax      :
    Description : Registered for /api/{Version}/Orders and
                  /api/{Version}/Orders/{Ordernum}.
                  v0 --> switched off, 410 Gone
                  v1 --> deprecated, flat structure + deprecation headers
                  v2 --> current, nested customer
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Adapters.* from propath.
using Demo.RestApiVersioning.Errors.*   from propath.
using Demo.RestApiVersioning.Web.*      from propath.
using OpenEdge.Web.*                    from propath.

class Demo.RestApiVersioning.UriVersion.OrdersHandler
    inherits OrderHandlerBase:

    /**
     * Purpose: Returns the reader and the writer of the version in the URI
     * Notes  : All versions of the API in one place
     * @param poRequest The web request
     * @param poReader OUTPUT The reader for the request body
     * @param poWriter OUTPUT The writer for the response
     */
    method override protected void SelectVersion (poRequest as IWebRequest,
                                                  output poReader as IOrderReader,
                                                  output poWriter as IOrderWriter):

        define variable cVersion as character no-undo .

        assign cVersion = poRequest:GetPathParameter ("Version":u) .

        case cVersion:
            when "v0":u then    /* switched off */
                undo, throw new VersionGoneException (cVersion, this-object:RecordUri (poRequest, "/api/v2/Orders":u), "":u) .

            when "v1":u then    /* deprecated: the v1 writer adds Deprecation, Sunset and Link */
                assign poReader = new OrderV1Reader ()
                       poWriter = new OrderV1Writer () .

            when "v2":u then    /* current */
                assign poReader = new OrderV2Reader ()
                       poWriter = new OrderV2Writer () .

            otherwise
                undo, throw new NotFoundException (substitute ("Version &1 of the Orders API does not exist.":u, cVersion)) .
        end case.

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
     * Purpose: Handles DELETE requests
     * Notes  : DELETE is not part of any version: 405 Method Not Allowed
     *          with the Allow header. A switched-off version stays 410
     * @param poRequest The web request
     * @return Never returns
     */
    method override protected integer HandleDelete (poRequest as IWebRequest):

        define variable oReader as IOrderReader no-undo .
        define variable oWriter as IOrderWriter no-undo .

        this-object:SelectVersion (poRequest, output oReader, output oWriter) .

        undo, throw new MethodNotAllowedException (this-object:AllowedMethods (poRequest)) .

    end method.

end class.
