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
    File        : Demo.RestApiVersioning.Order.OrderCustomer
    Purpose     : The customer of an order (CustNum plus the address)
    Syntax      :
    Description : Assigning CustNum is tracked on the owning order, so the
                  data access knows when the customer of the order changed.
                  The address is filled by the data access only
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Order.* from propath.

class Demo.RestApiVersioning.Order.OrderCustomer
    implements ICustomerV2:

    /* The order this customer belongs to - tracks the assignment of CustNum */
    define private variable oOwner as TrackedObject no-undo .

    /**
     * Purpose: Gets and sets the customer number of the order
     * Notes  :
     */
    define public property CustNum as integer no-undo
    get.
    set (arg as integer):
        assign CustNum = arg .
        oOwner:MarkAssigned ("CustNum":u) .
    end set.

    /**
     * Purpose: Gets and sets the name of the customer
     * Notes  : Read-only in both versions of the API
     */
    define public property Name as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the address of the customer
     * Notes  : Read-only in both versions of the API
     */
    define public property Address as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the second address line of the customer
     * Notes  : Read-only in both versions of the API
     */
    define public property Address2 as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the postal code of the customer
     * Notes  : Read-only in both versions of the API
     */
    define public property PostalCode as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the city of the customer
     * Notes  : Read-only in both versions of the API
     */
    define public property City as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the state of the customer
     * Notes  : Read-only in both versions of the API
     */
    define public property State as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the country of the customer
     * Notes  : Read-only in both versions of the API
     */
    define public property Country as character no-undo
    get.
    set.

    /**
     * Purpose: Constructor of the OrderCustomer class
     * Notes  :
     * @param poOwner The order this customer belongs to
     */
    constructor public OrderCustomer (poOwner as TrackedObject):

        super () .

        assign oOwner = poOwner .

    end constructor.

end class.
