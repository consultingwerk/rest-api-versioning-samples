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
    File        : Demo.RestApiVersioning.Errors.InvalidFieldException
    Purpose     : 400 Bad Request - a field (or query parameter) has an
                  invalid value
    Syntax      :
    Description : Wrong JSON type, violated business rule, invalid paging
                  parameter. The field name is the one the client knows
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.OERA.JsdoGenericService.WebHandler.* from propath.
using Demo.RestApiVersioning.Errors.*                     from propath.

class Demo.RestApiVersioning.Errors.InvalidFieldException
    inherits ApiException
    implements IHttp400Error
    serializable:

    /**
     * Purpose: Gets the name of the invalid field
     * Notes  :
     */
    define public property FieldName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the InvalidFieldException class
     * Notes  :
     * @param pcFieldName The name of the invalid field
     * @param pcMessage The description of the problem
     */
    constructor public InvalidFieldException (pcFieldName as character,
                                              pcMessage as character):

        super ("Invalid field value":u) .

        assign this-object:FieldName = pcFieldName .

        this-object:AddFieldMessage (pcMessage, pcFieldName) .

    end constructor.

end class.
