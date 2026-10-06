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
