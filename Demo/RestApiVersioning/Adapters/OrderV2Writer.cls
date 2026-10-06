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
    File        : Demo.RestApiVersioning.Adapters.OrderV2Writer
    Purpose     : Writes the v2 representation of an order (customer as a
                  nested object, no WarehouseNum)
    Syntax      :
    Description : Works through IOrderHeaderV2 only - WarehouseNum cannot
                  slip into a v2 response, the interface does not offer it
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

class Demo.RestApiVersioning.Adapters.OrderV2Writer
    implements IOrderWriter:

    /**
     * Purpose: Gets the media type of version 2
     * Notes  :
     */
    define public property MediaType as character no-undo
        initial "application/vnd.sports2000.order.v2+json":u
    get.

    /**
     * Purpose: Writes an order header in the v2 representation
     * Notes  :
     * @param poOrder The order header
     * @return The v2 JSON representation
     */
    method public JsonObject Write (poOrder as OrderHeader):

        define variable oOrder    as IOrderHeaderV2 no-undo .
        define variable oJson     as JsonObject     no-undo .
        define variable oCustomer as JsonObject     no-undo .

        /* From here on, the v2 writer only sees the v2 contract */
        assign oOrder    = poOrder
               oJson     = new JsonObject ()
               oCustomer = new JsonObject () .

        oCustomer:Add ("CustNum":u,    oOrder:Customer:CustNum) .
        oCustomer:Add ("Name":u,       oOrder:Customer:Name) .
        oCustomer:Add ("Address":u,    oOrder:Customer:Address) .
        oCustomer:Add ("Address2":u,   oOrder:Customer:Address2) .
        oCustomer:Add ("PostalCode":u, oOrder:Customer:PostalCode) .
        oCustomer:Add ("City":u,       oOrder:Customer:City) .
        oCustomer:Add ("State":u,      oOrder:Customer:State) .
        oCustomer:Add ("Country":u,    oOrder:Customer:Country) .

        oJson:Add ("Ordernum":u,     oOrder:Ordernum) .
        oJson:Add ("Customer":u,     oCustomer) .
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
        oJson:Add ("Creditcard":u,   oOrder:Creditcard) .

        return oJson .

    end method.

    /**
     * Purpose: Adds the headers of version 2 to a response
     * Notes  : The current version needs no extra headers
     * @param poResponse The response
     */
    method public void AddResponseHeaders (poResponse as IHttpResponse):

        /* noop */

    end method.

end class.
