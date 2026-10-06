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
    File        : Demo.RestApiVersioning.Order.OrderService
    Purpose     : The ONE business logic for order headers - shared by all
                  versions of the API
    Syntax      :
    Description : Works with strongly typed objects only - never with JSON.
                  The business rules are written against the current
                  contract (IOrderHeaderV2)
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Order.* from propath.

class Demo.RestApiVersioning.Order.OrderService:

    define private variable oDataAccess as OrderDataAccess no-undo .

    /**
     * Purpose: Constructor of the OrderService class
     * Notes  :
     */
    constructor public OrderService ():

        super () .

        assign oDataAccess = new OrderDataAccess () .

    end constructor.

    /**
     * Purpose: Returns a single order
     * Notes  : Raises OrderNotFoundException
     * @param piOrdernum The order number
     * @return The order header
     */
    method public OrderHeader GetOrder (piOrdernum as integer):

        return oDataAccess:FetchOrder (piOrdernum) .

    end method.

    /**
     * Purpose: Returns a page of orders
     * Notes  : Returns an indeterminate array when the page is empty
     * @param piSkip The number of orders to skip
     * @param piTop The maximum number of orders to return
     * @return The order headers of the page
     */
    method public OrderHeader extent GetOrders (piSkip as integer,
                                                piTop as integer):

        return oDataAccess:FetchOrders (piSkip, piTop) .

    end method.

    /**
     * Purpose: Creates a new order
     * Notes  : Only the assigned properties are written, all others keep
     *          the initial values of the database
     * @param poOrder The new order header
     * @return The order header as stored in the database
     */
    method public OrderHeader CreateOrder (poOrder as OrderHeader):

        this-object:Validate (poOrder) .

        return oDataAccess:FetchOrder (oDataAccess:CreateOrder (poOrder)) .

    end method.

    /**
     * Purpose: Updates an existing order
     * Notes  : Only the assigned properties are written (read - merge -
     *          write: properties the client did not send stay untouched)
     * @param poOrder The changed order header
     * @return The order header as stored in the database
     */
    method public OrderHeader UpdateOrder (poOrder as OrderHeader):

        this-object:Validate (poOrder) .

        oDataAccess:UpdateOrder (poOrder) .

        return oDataAccess:FetchOrder (poOrder:Ordernum) .

    end method.

    /**
     * Purpose: Validates an order header against the business rules
     * Notes  : Written against the current contract (v2) - the field names
     *          in the errors are v2 names
     * @param poOrder The order header to validate
     */
    method private void Validate (poOrder as IOrderHeaderV2):

        if not oDataAccess:CustomerExists (poOrder:Customer:CustNum) then
            undo, throw new OrderValidationException ("Customer.CustNum":u,
                                                      substitute ("Customer &1 does not exist.":u,
                                                                  poOrder:Customer:CustNum)) .

        if poOrder:PromiseDate < poOrder:OrderDate then
            undo, throw new OrderValidationException ("PromiseDate":u,
                                                      "The promise date must not be before the order date.":u) .

    end method.

end class.
