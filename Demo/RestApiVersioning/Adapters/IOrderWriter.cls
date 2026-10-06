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
    File        : Demo.RestApiVersioning.Adapters.IOrderWriter
    Purpose     : Writes the (one) order model in the representation of one
                  version of the API
    Syntax      :
    Description : JSON starts here - before the writer, everything is typed
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Demo.RestApiVersioning.Order.* from propath.
using OpenEdge.Net.HTTP.*            from propath.
using Progress.Json.ObjectModel.*    from propath.

interface Demo.RestApiVersioning.Adapters.IOrderWriter:

    /**
     * Purpose: Gets the media type of this version, e.g.
     *          application/vnd.sports2000.order.v2+json
     * Notes  :
     */
    define public property MediaType as character no-undo
    get.

    /**
     * Purpose: Writes an order header as JSON
     * Notes  :
     * @param poOrder The order header
     * @return The JSON representation of this version
     */
    method public JsonObject Write (poOrder as OrderHeader).

    /**
     * Purpose: Adds the headers of this version to a response
     * Notes  : e.g. Deprecation and Sunset for a deprecated version
     * @param poResponse The response
     */
    method public void AddResponseHeaders (poResponse as IHttpResponse).

end interface.
