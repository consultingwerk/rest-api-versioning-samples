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
    File        : Demo.RestApiVersioning.Errors.UnknownFieldsException
    Purpose     : 400 Bad Request - the payload contains fields that are not
                  part of the schema of the requested version
    Syntax      :
    Description : One entry in "errors" per unknown field, e.g. WarehouseNum
                  sent to version 2
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.OERA.JsdoGenericService.WebHandler.* from propath.
using Demo.RestApiVersioning.Errors.*                     from propath.

class Demo.RestApiVersioning.Errors.UnknownFieldsException
    inherits ApiException
    implements IHttp400Error
    serializable:

    /**
     * Purpose: Gets the comma separated list of the unknown fields
     * Notes  :
     */
    define public property FieldNames as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the UnknownFieldsException class
     * Notes  :
     * @param pcFieldNames The comma separated list of the unknown fields
     */
    constructor public UnknownFieldsException (pcFieldNames as character):

        define variable iField  as integer no-undo .
        define variable iFields as integer no-undo .

        super ("Unknown field":u) .

        assign this-object:FieldNames = pcFieldNames
               iFields                = num-entries (pcFieldNames) .

        do iField = 1 to iFields:
            this-object:AddFieldMessage (substitute ("The field &1 is not part of this version of the API.":u,
                                                     entry (iField, pcFieldNames)),
                                         entry (iField, pcFieldNames)) .
        end.

    end constructor.

end class.
