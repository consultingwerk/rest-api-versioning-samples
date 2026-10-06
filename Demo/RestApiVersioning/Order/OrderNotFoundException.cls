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
    File        : Demo.RestApiVersioning.Order.OrderNotFoundException
    Purpose     : Raised when an order does not exist
    Syntax      :
    Description : A plain ABL error of the business logic - it knows nothing
                  about HTTP. The web handlers translate it into 404
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

class Demo.RestApiVersioning.Order.OrderNotFoundException
    inherits Progress.Lang.AppError
    serializable:

    /**
     * Purpose: Gets the number of the order that was not found
     * Notes  :
     */
    define public property Ordernum as integer no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the OrderNotFoundException class
     * Notes  :
     * @param piOrdernum The number of the order that was not found
     */
    constructor public OrderNotFoundException (piOrdernum as integer):

        super (substitute ("Order &1 does not exist.":u, piOrdernum), 0) .

        assign this-object:Ordernum = piOrdernum .

    end constructor.

end class.
