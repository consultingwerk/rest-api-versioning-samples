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
