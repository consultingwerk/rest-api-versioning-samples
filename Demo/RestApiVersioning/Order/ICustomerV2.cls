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
