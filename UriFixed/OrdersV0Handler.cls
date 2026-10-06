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
    File        : Demo.RestApiVersioning.UriFixed.OrdersV0Handler
    Purpose     : /v0/Orders - version 0, switched off: 410 Gone
    Syntax      :
    Description : Registered for /v0/Orders and /v0/Orders/{Ordernum}.
                  There is no v0 implementation any more - every request
                  (any method) answers 410 Gone
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

class Demo.RestApiVersioning.UriFixed.OrdersV0Handler
    inherits OrderHandlerBase:

    /**
     * Purpose: Version 0 has been switched off
     * Notes  : 410 Gone, linking to the same order in version 2
     * @param poRequest The web request
     * @param poReader OUTPUT The reader for the request body
     * @param poWriter OUTPUT The writer for the response
     */
    method override protected void SelectVersion (poRequest as IWebRequest,
                                                  output poReader as IOrderReader,
                                                  output poWriter as IOrderWriter):

        undo, throw new VersionGoneException ("v0":u, this-object:RecordUri (poRequest, "/v2/Orders":u), "":u) .

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
     * Purpose: Handles DELETE requests - 410 Gone
     * Notes  :
     * @param poRequest The web request
     * @return Never returns
     */
    method override protected integer HandleDelete (poRequest as IWebRequest):

        return this-object:ProcessDelete (poRequest) .

    end method.

end class.
