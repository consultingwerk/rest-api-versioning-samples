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
    File        : Demo.RestApiVersioning.Order.OrderValidationException
    Purpose     : Raised when an order violates a business rule
    Syntax      :
    Description : FieldName uses the names of the model (= v2), e.g.
                  "Customer.CustNum". The web handlers translate the field
                  name into the name the client knows (v1: "CustNum") and
                  the error into 400 Bad Request
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

class Demo.RestApiVersioning.Order.OrderValidationException
    inherits Progress.Lang.AppError
    serializable:

    /**
     * Purpose: Gets the name of the invalid field (model / v2 naming)
     * Notes  :
     */
    define public property FieldName as character no-undo
    get.
    private set.

    /**
     * Purpose: Gets the description of the violated rule
     * Notes  :
     */
    define public property ValidationMessage as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the OrderValidationException class
     * Notes  :
     * @param pcFieldName The name of the invalid field (model / v2 naming)
     * @param pcValidationMessage The description of the violated rule
     */
    constructor public OrderValidationException (pcFieldName as character,
                                                 pcValidationMessage as character):

        super (pcValidationMessage, 0) .

        assign this-object:FieldName         = pcFieldName
               this-object:ValidationMessage = pcValidationMessage .

    end constructor.

end class.
