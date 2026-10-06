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
    File        : Demo.RestApiVersioning.Order.IOrderHeaderV2
    Purpose     : The order header as seen by version 2 (current) of the API
    Syntax      :
    Description : Compared to version 1:
                  - the customer (CustNum and address) is a nested object
                  - WarehouseNum is not part of the contract any more
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : The business logic is written against this interface
  ----------------------------------------------------------------------*/

@lowercase.

using Demo.RestApiVersioning.Order.* from propath.

interface Demo.RestApiVersioning.Order.IOrderHeaderV2:

    /**
     * Purpose: Gets the order number (read-only, assigned by the database)
     * Notes  :
     */
    define public property Ordernum as integer no-undo
    get.

    /**
     * Purpose: Gets the customer of the order (nested object)
     * Notes  :
     */
    define public property Customer as ICustomerV2 no-undo
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
     * Purpose: Gets and sets the credit card
     * Notes  :
     */
    define public property Creditcard as character no-undo
    get.
    set.

end interface.
