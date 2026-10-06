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
    File        : Demo.RestApiVersioning.Order.OrderDataAccess
    Purpose     : Reads and writes order headers (tables Order and Customer
                  of the sports2000 database)
    Syntax      :
    Description : Deliberately plain ABL: FIND / FOR EACH / ASSIGN. Writes
                  only the properties that were assigned since the order was
                  read - a PATCH changes exactly the fields in its payload
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : The address fields belong to the Customer record and are
                  never written here
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Order.* from propath.

class Demo.RestApiVersioning.Order.OrderDataAccess:

    /**
     * Purpose: Reads a single order
     * Notes  :
     * @param piOrdernum The order number
     * @return The order header
     */
    method public OrderHeader FetchOrder (piOrdernum as integer):

        for first Order where Order.Ordernum = piOrdernum no-lock:
            return this-object:ToOrderHeader (buffer Order) .
        end.

        undo, throw new OrderNotFoundException (piOrdernum) .

    end method.

    /**
     * Purpose: Reads a page of orders, sorted by order number
     * Notes  : Returns an indeterminate array when the page is empty
     * @param piSkip The number of orders to skip
     * @param piTop The maximum number of orders to return
     * @return The order headers of the page
     */
    method public OrderHeader extent FetchOrders (piSkip as integer,
                                                  piTop as integer):

        define variable oPage   as OrderHeader no-undo extent .
        define variable oResult as OrderHeader no-undo extent .
        define variable iRow    as integer     no-undo .
        define variable iCount  as integer     no-undo .
        define variable i       as integer     no-undo .

        assign extent (oPage) = piTop .

        orderLoop:
        for each Order no-lock by Order.Ordernum:
            assign iRow = iRow + 1 .

            if iRow <= piSkip then
                next orderLoop .

            assign iCount        = iCount + 1
                   oPage[iCount] = this-object:ToOrderHeader (buffer Order) .

            if iCount = piTop then
                leave orderLoop .
        end.

        if iCount = 0 then
            return oResult .

        assign extent (oResult) = iCount .

        do i = 1 to iCount:
            assign oResult[i] = oPage[i] .
        end.

        return oResult .

    end method.

    /**
     * Purpose: Creates a new order
     * Notes  : The CREATE trigger of the Order table assigns Ordernum,
     *          OrderDate and PromiseDate
     * @param poOrder The order header to create
     * @return The order number assigned by the database
     */
    method public integer CreateOrder (poOrder as OrderHeader):

        do transaction:
            create Order .

            this-object:AssignOrder (poOrder, buffer Order) .

            return Order.Ordernum .
        end.

    end method.

    /**
     * Purpose: Updates an existing order
     * Notes  : Only the assigned properties are written
     * @param poOrder The order header to update
     */
    method public void UpdateOrder (poOrder as OrderHeader):

        for first Order where Order.Ordernum = poOrder:Ordernum exclusive-lock:
            this-object:AssignOrder (poOrder, buffer Order) .
            return .
        end.

        undo, throw new OrderNotFoundException (poOrder:Ordernum) .

    end method.

    /**
     * Purpose: Returns if a customer exists
     * Notes  :
     * @param piCustNum The customer number
     * @return Logical value indicating if the customer exists
     */
    method public logical CustomerExists (piCustNum as integer):

        return can-find (Customer where Customer.CustNum = piCustNum) .

    end method.

    /**
     * Purpose: Writes the assigned properties of an order header into the
     *          Order record
     * Notes  :
     * @param poOrder The order header
     * @param pbOrder The Order record (exclusive-lock)
     */
    method private void AssignOrder (poOrder as OrderHeader,
                                     buffer pbOrder for Order):

        if poOrder:IsAssigned ("CustNum":u) then
            assign pbOrder.CustNum = poOrder:CustNum .
        if poOrder:IsAssigned ("OrderDate":u) then
            assign pbOrder.OrderDate = poOrder:OrderDate .
        if poOrder:IsAssigned ("ShipDate":u) then
            assign pbOrder.ShipDate = poOrder:ShipDate .
        if poOrder:IsAssigned ("PromiseDate":u) then
            assign pbOrder.PromiseDate = poOrder:PromiseDate .
        if poOrder:IsAssigned ("Carrier":u) then
            assign pbOrder.Carrier = poOrder:Carrier .
        if poOrder:IsAssigned ("Instructions":u) then
            assign pbOrder.Instructions = poOrder:Instructions .
        if poOrder:IsAssigned ("PO":u) then
            assign pbOrder.PO = poOrder:PO .
        if poOrder:IsAssigned ("Terms":u) then
            assign pbOrder.Terms = poOrder:Terms .
        if poOrder:IsAssigned ("SalesRep":u) then
            assign pbOrder.SalesRep = poOrder:SalesRep .
        if poOrder:IsAssigned ("BillToID":u) then
            assign pbOrder.BillToID = poOrder:BillToID .
        if poOrder:IsAssigned ("ShipToID":u) then
            assign pbOrder.ShipToID = poOrder:ShipToID .
        if poOrder:IsAssigned ("OrderStatus":u) then
            assign pbOrder.OrderStatus = poOrder:OrderStatus .
        if poOrder:IsAssigned ("WarehouseNum":u) then
            assign pbOrder.WarehouseNum = poOrder:WarehouseNum .
        if poOrder:IsAssigned ("Creditcard":u) then
            assign pbOrder.Creditcard = poOrder:Creditcard .

    end method.

    /**
     * Purpose: Creates the order header object from the Order record and
     *          the address of its Customer
     * Notes  :
     * @param pbOrder The Order record
     * @return The order header
     */
    method private OrderHeader ToOrderHeader (buffer pbOrder for Order):

        define variable oOrder    as OrderHeader   no-undo .
        define variable oCustomer as OrderCustomer no-undo .

        assign oOrder              = new OrderHeader ()
               oOrder:Ordernum     = pbOrder.Ordernum
               oOrder:CustNum      = pbOrder.CustNum
               oOrder:OrderDate    = pbOrder.OrderDate
               oOrder:ShipDate     = pbOrder.ShipDate
               oOrder:PromiseDate  = pbOrder.PromiseDate
               oOrder:Carrier      = pbOrder.Carrier
               oOrder:Instructions = pbOrder.Instructions
               oOrder:PO           = pbOrder.PO
               oOrder:Terms        = pbOrder.Terms
               oOrder:SalesRep     = pbOrder.SalesRep
               oOrder:BillToID     = pbOrder.BillToID
               oOrder:ShipToID     = pbOrder.ShipToID
               oOrder:OrderStatus  = pbOrder.OrderStatus
               oOrder:WarehouseNum = pbOrder.WarehouseNum
               oOrder:Creditcard   = pbOrder.Creditcard
               oCustomer           = cast (oOrder:Customer, OrderCustomer) .

        for first Customer where Customer.CustNum = pbOrder.CustNum no-lock:
            assign oCustomer:Name       = Customer.Name
                   oCustomer:Address    = Customer.Address
                   oCustomer:Address2   = Customer.Address2
                   oCustomer:PostalCode = Customer.PostalCode
                   oCustomer:City       = Customer.City
                   oCustomer:State      = Customer.State
                   oCustomer:Country    = Customer.Country .
        end.

        /* freshly read - nothing is assigned yet from the point of view of an update */
        oOrder:ResetAssigned () .

        return oOrder .

    end method.

end class.
