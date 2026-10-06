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
    File        : Demo.RestApiVersioning.Order.OrderHeader
    Purpose     : The ONE implementation of the order header - shaped like
                  the current version (v2) of the API
    Syntax      :
    Description : Implements the contracts of all supported versions:
                  - properties common to v1 and v2 satisfy both interfaces
                  - the flat v1 customer properties delegate to the nested
                    Customer object
                  - a future v3 adds IOrderHeaderV3, the v1 code stays as is
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : Contract <> database: WarehouseNum was removed from the v2
                  contract, NOT from the data. The model is the newest shape
                  PLUS every field an older, still supported version needs.
                  IOrderHeaderV1 exposes WarehouseNum, IOrderHeaderV2 does not
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Order.* from propath.

class Demo.RestApiVersioning.Order.OrderHeader
    inherits TrackedObject
    implements IOrderHeaderV1, IOrderHeaderV2:

    /***********************************************************************
        Section: Common to v1 and v2
     ***********************************************************************/

    /**
     * Purpose: Gets and sets the order number
     * Notes  : Read-only for API clients, assigned by the database
     */
    define public property Ordernum as integer no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the order date
     * Notes  :
     */
    define public property OrderDate as date no-undo
    get.
    set (arg as date):
        assign OrderDate = arg .
        this-object:MarkAssigned ("OrderDate":u) .
    end set.

    /**
     * Purpose: Gets and sets the ship date
     * Notes  :
     */
    define public property ShipDate as date no-undo
    get.
    set (arg as date):
        assign ShipDate = arg .
        this-object:MarkAssigned ("ShipDate":u) .
    end set.

    /**
     * Purpose: Gets and sets the promise date
     * Notes  :
     */
    define public property PromiseDate as date no-undo
    get.
    set (arg as date):
        assign PromiseDate = arg .
        this-object:MarkAssigned ("PromiseDate":u) .
    end set.

    /**
     * Purpose: Gets and sets the carrier
     * Notes  :
     */
    define public property Carrier as character no-undo
    get.
    set (arg as character):
        assign Carrier = arg .
        this-object:MarkAssigned ("Carrier":u) .
    end set.

    /**
     * Purpose: Gets and sets the shipping instructions
     * Notes  :
     */
    define public property Instructions as character no-undo
    get.
    set (arg as character):
        assign Instructions = arg .
        this-object:MarkAssigned ("Instructions":u) .
    end set.

    /**
     * Purpose: Gets and sets the purchase order number
     * Notes  :
     */
    define public property PO as character no-undo
    get.
    set (arg as character):
        assign PO = arg .
        this-object:MarkAssigned ("PO":u) .
    end set.

    /**
     * Purpose: Gets and sets the payment terms
     * Notes  :
     */
    define public property Terms as character no-undo
    get.
    set (arg as character):
        assign Terms = arg .
        this-object:MarkAssigned ("Terms":u) .
    end set.

    /**
     * Purpose: Gets and sets the sales rep
     * Notes  :
     */
    define public property SalesRep as character no-undo
    get.
    set (arg as character):
        assign SalesRep = arg .
        this-object:MarkAssigned ("SalesRep":u) .
    end set.

    /**
     * Purpose: Gets and sets the bill-to address id
     * Notes  :
     */
    define public property BillToID as integer no-undo
    get.
    set (arg as integer):
        assign BillToID = arg .
        this-object:MarkAssigned ("BillToID":u) .
    end set.

    /**
     * Purpose: Gets and sets the ship-to address id
     * Notes  :
     */
    define public property ShipToID as integer no-undo
    get.
    set (arg as integer):
        assign ShipToID = arg .
        this-object:MarkAssigned ("ShipToID":u) .
    end set.

    /**
     * Purpose: Gets and sets the order status
     * Notes  :
     */
    define public property OrderStatus as character no-undo
    get.
    set (arg as character):
        assign OrderStatus = arg .
        this-object:MarkAssigned ("OrderStatus":u) .
    end set.

    /**
     * Purpose: Gets and sets the credit card
     * Notes  :
     */
    define public property Creditcard as character no-undo
    get.
    set (arg as character):
        assign Creditcard = arg .
        this-object:MarkAssigned ("Creditcard":u) .
    end set.

    /***********************************************************************
        Section: v2 - the customer as a nested object
     ***********************************************************************/

    /**
     * Purpose: Gets the customer of the order (CustNum plus the address)
     * Notes  : IOrderHeaderV2
     */
    define public property Customer as ICustomerV2 no-undo
    get.
    private set.

    /***********************************************************************
        Section: v1 only - still part of the model
     ***********************************************************************/

    /**
     * Purpose: Gets and sets the warehouse number
     * Notes  : IOrderHeaderV1 only - removed from the v2 contract, but still
     *          stored, so v1 clients keep reading and writing it
     */
    define public property WarehouseNum as integer no-undo
    get.
    set (arg as integer):
        assign WarehouseNum = arg .
        this-object:MarkAssigned ("WarehouseNum":u) .
    end set.

    /**
     * Purpose: Gets and sets the customer number (flat, v1)
     * Notes  : Delegates to the nested Customer object
     */
    define public property CustNum as integer no-undo
    get:
        return this-object:Customer:CustNum .
    end get.
    set (arg as integer):
        assign this-object:Customer:CustNum = arg .
    end set.

    /**
     * Purpose: Gets the name of the customer (flat, v1)
     * Notes  : Delegates to the nested Customer object
     */
    define public property Name as character no-undo
    get:
        return this-object:Customer:Name .
    end get.

    /**
     * Purpose: Gets the address of the customer (flat, v1)
     * Notes  : Delegates to the nested Customer object
     */
    define public property Address as character no-undo
    get:
        return this-object:Customer:Address .
    end get.

    /**
     * Purpose: Gets the second address line of the customer (flat, v1)
     * Notes  : Delegates to the nested Customer object
     */
    define public property Address2 as character no-undo
    get:
        return this-object:Customer:Address2 .
    end get.

    /**
     * Purpose: Gets the postal code of the customer (flat, v1)
     * Notes  : Delegates to the nested Customer object
     */
    define public property PostalCode as character no-undo
    get:
        return this-object:Customer:PostalCode .
    end get.

    /**
     * Purpose: Gets the city of the customer (flat, v1)
     * Notes  : Delegates to the nested Customer object
     */
    define public property City as character no-undo
    get:
        return this-object:Customer:City .
    end get.

    /**
     * Purpose: Gets the state of the customer (flat, v1)
     * Notes  : Delegates to the nested Customer object
     */
    define public property State as character no-undo
    get:
        return this-object:Customer:State .
    end get.

    /**
     * Purpose: Gets the country of the customer (flat, v1)
     * Notes  : Delegates to the nested Customer object
     */
    define public property Country as character no-undo
    get:
        return this-object:Customer:Country .
    end get.

    /**
     * Purpose: Constructor of the OrderHeader class
     * Notes  :
     */
    constructor public OrderHeader ():

        super () .

        assign this-object:Customer = new OrderCustomer (this-object) .

    end constructor.

end class.
