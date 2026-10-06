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
