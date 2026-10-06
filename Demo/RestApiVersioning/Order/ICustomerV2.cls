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
    File        : Demo.RestApiVersioning.Order.ICustomerV2
    Purpose     : The customer of an order as seen by version 2 of the API
    Syntax      :
    Description : The nested "Customer" object of the v2 representation.
                  Only CustNum can be written - the address belongs to the
                  Customer record and is read-only for the Orders API
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

interface Demo.RestApiVersioning.Order.ICustomerV2:

    /**
     * Purpose: Gets and sets the customer number of the order
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

end interface.
