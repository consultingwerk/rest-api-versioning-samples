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
