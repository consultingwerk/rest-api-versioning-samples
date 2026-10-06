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
    File        : Demo.RestApiVersioning.Errors.ApiException
    Purpose     : Base class of the errors the Orders API returns to the
                  client
    Syntax      :
    Description : Every subclass implements one IHttp<nnn>Error marker
                  interface - that marker selects the HTTP status code.
                  Title becomes the "title", the messages become the
                  "detail" and the "errors" of the RFC 9457 problem details
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : A message may carry the name of the field it refers to,
                  separated by chr (4) - it becomes "field" in "errors"
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Exceptions.*     from propath.
using Demo.RestApiVersioning.Errors.* from propath.
using OpenEdge.Net.HTTP.*             from propath.

class Demo.RestApiVersioning.Errors.ApiException
    inherits Consultingwerk.Exceptions.Exception
    implements IErrorTitle, IProvidesResponseHeaders
    abstract
    serializable:

    /**
     * Purpose: Gets the short, human readable summary of the problem
     * Notes  : "title" of the problem details
     */
    define public property Title as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the ApiException class
     * Notes  : The subclass adds the messages
     * @param pcTitle The short, human readable summary of the problem
     */
    constructor protected ApiException (pcTitle as character):

        super () .

        assign this-object:Title = pcTitle .

    end constructor.

    /**
     * Purpose: Constructor of the ApiException class
     * Notes  :
     * @param pcTitle The short, human readable summary of the problem
     * @param pcDetail The explanation of this occurrence of the problem
     */
    constructor protected ApiException (pcTitle as character,
                                        pcDetail as character):

        super (pcDetail, 0) .

        assign this-object:Title = pcTitle .

    end constructor.

    /**
     * Purpose: Adds the headers of this error to the error response
     * Notes  : No headers by default
     * @param poResponse The error response
     */
    method public void AddResponseHeaders (poResponse as IHttpResponse):

        /* noop */

    end method.

    /**
     * Purpose: Adds a message that refers to a field
     * Notes  : Becomes { "message": ..., "field": ... } in "errors"
     * @param pcMessage The message text
     * @param pcFieldName The name of the field (as the client knows it)
     */
    method protected void AddFieldMessage (pcMessage as character,
                                           pcFieldName as character):

        this-object:AddMessage (pcMessage + chr (4) + pcFieldName, 0) .

    end method.

end class.
