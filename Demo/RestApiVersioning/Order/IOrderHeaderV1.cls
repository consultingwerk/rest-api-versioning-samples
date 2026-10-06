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
    File        : Demo.RestApiVersioning.Order.IOrderHeaderV1
    Purpose     : The order header as seen by version 1 (deprecated) of the
                  API
    Syntax      :
    Description : Flat structure: all fields of the Order table plus the
                  address of the customer. The address fields are read-only
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

interface Demo.RestApiVersioning.Order.IOrderHeaderV1:

    /**
     * Purpose: Gets the order number (read-only, assigned by the database)
     * Notes  :
     */
    define public property Ordernum as integer no-undo
    get.

    /**
     * Purpose: Gets and sets the customer number
     * Notes  :
     */
    define public property CustNum as integer no-undo
    get.
    set.

    /**
     * Purpose: Gets the name of the customer (read-only)
     * Notes  :
     */
    define public property Name as character no-undo
    get.

    /**
     * Purpose: Gets the address of the customer (read-only)
     * Notes  :
     */
    define public property Address as character no-undo
    get.

    /**
     * Purpose: Gets the second address line of the customer (read-only)
     * Notes  :
     */
    define public property Address2 as character no-undo
    get.

    /**
     * Purpose: Gets the postal code of the customer (read-only)
     * Notes  :
     */
    define public property PostalCode as character no-undo
    get.

    /**
     * Purpose: Gets the city of the customer (read-only)
     * Notes  :
     */
    define public property City as character no-undo
    get.

    /**
     * Purpose: Gets the state of the customer (read-only)
     * Notes  :
     */
    define public property State as character no-undo
    get.

    /**
     * Purpose: Gets the country of the customer (read-only)
     * Notes  :
     */
    define public property Country as character no-undo
    get.

    /**
     * Purpose: Gets and sets the order date
     * Notes  :
     */
    define public property OrderDate as date no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the ship date
     * Notes  :
     */
    define public property ShipDate as date no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the promise date
     * Notes  :
     */
    define public property PromiseDate as date no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the carrier
     * Notes  :
     */
    define public property Carrier as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the shipping instructions
     * Notes  :
     */
    define public property Instructions as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the purchase order number
     * Notes  :
     */
    define public property PO as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the payment terms
     * Notes  :
     */
    define public property Terms as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the sales rep
     * Notes  :
     */
    define public property SalesRep as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the bill-to address id
     * Notes  :
     */
    define public property BillToID as integer no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the ship-to address id
     * Notes  :
     */
    define public property ShipToID as integer no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the order status
     * Notes  :
     */
    define public property OrderStatus as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the warehouse number - removed in version 2
     * Notes  :
     */
    define public property WarehouseNum as integer no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the credit card
     * Notes  :
     */
    define public property Creditcard as character no-undo
    get.
    set.

end interface.
