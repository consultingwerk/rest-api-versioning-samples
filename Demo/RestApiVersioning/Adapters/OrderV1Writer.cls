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
    File        : Demo.RestApiVersioning.Adapters.OrderV1Writer
    Purpose     : Writes the flat v1 representation of an order - and marks
                  every v1 response as deprecated
    Syntax      :
    Description : Works through IOrderHeaderV1 only. Still writes
                  WarehouseNum
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Adapters.* from propath.
using Demo.RestApiVersioning.Order.*    from propath.
using OpenEdge.Net.HTTP.*               from propath.
using Progress.Json.ObjectModel.*       from propath.

class Demo.RestApiVersioning.Adapters.OrderV1Writer
    implements IOrderWriter:

    /* Where v1 clients learn how to migrate to v2 */
    define private variable cMigrationGuideLink as character no-undo
        initial "<https://docs.example.com/api/orders/migrate-v2>; rel=~"deprecation~"; type=~"text/html~"":u .

    /**
     * Purpose: Gets the media type of version 1
     * Notes  :
     */
    define public property MediaType as character no-undo
        initial "application/vnd.sports2000.order.v1+json":u
    get.

    /**
     * Purpose: Writes an order header in the flat v1 representation
     * Notes  :
     * @param poOrder The order header
     * @return The v1 JSON representation
     */
    method public JsonObject Write (poOrder as OrderHeader):

        define variable oOrder as IOrderHeaderV1 no-undo .
        define variable oJson  as JsonObject     no-undo .

        /* From here on, the v1 writer only sees the v1 contract */
        assign oOrder = poOrder
               oJson  = new JsonObject () .

        oJson:Add ("Ordernum":u,     oOrder:Ordernum) .
        oJson:Add ("CustNum":u,      oOrder:CustNum) .
        oJson:Add ("Name":u,         oOrder:Name) .
        oJson:Add ("Address":u,      oOrder:Address) .
        oJson:Add ("Address2":u,     oOrder:Address2) .
        oJson:Add ("PostalCode":u,   oOrder:PostalCode) .
        oJson:Add ("City":u,         oOrder:City) .
        oJson:Add ("State":u,        oOrder:State) .
        oJson:Add ("Country":u,      oOrder:Country) .
        oJson:Add ("OrderDate":u,    oOrder:OrderDate) .
        oJson:Add ("ShipDate":u,     oOrder:ShipDate) .
        oJson:Add ("PromiseDate":u,  oOrder:PromiseDate) .
        oJson:Add ("Carrier":u,      oOrder:Carrier) .
        oJson:Add ("Instructions":u, oOrder:Instructions) .
        oJson:Add ("PO":u,           oOrder:PO) .
        oJson:Add ("Terms":u,        oOrder:Terms) .
        oJson:Add ("SalesRep":u,     oOrder:SalesRep) .
        oJson:Add ("BillToID":u,     oOrder:BillToID) .
        oJson:Add ("ShipToID":u,     oOrder:ShipToID) .
        oJson:Add ("OrderStatus":u,  oOrder:OrderStatus) .
        oJson:Add ("WarehouseNum":u, oOrder:WarehouseNum) .
        oJson:Add ("Creditcard":u,   oOrder:Creditcard) .

        return oJson .

    end method.

    /**
     * Purpose: Marks the response as deprecated
     * Notes  : Deprecation (RFC 9745): deprecated since 2026-07-01 00:00 UTC
     *          Sunset (RFC 8594): switched off after 2027-06-30
     *          Link rel="deprecation": the migration guide
     * @param poResponse The response
     */
    method public void AddResponseHeaders (poResponse as IHttpResponse):

        poResponse:SetHeader (HttpHeaderBuilder:Build ("Deprecation":u):Value ("@1782864000":u):Header) .
        poResponse:SetHeader (HttpHeaderBuilder:Build ("Sunset":u):Value ("Wed, 30 Jun 2027 23:59:59 GMT":u):Header) .
        poResponse:SetHeader (HttpHeaderBuilder:Build ("Link":u):Value (cMigrationGuideLink):Header) .

    end method.

end class.
