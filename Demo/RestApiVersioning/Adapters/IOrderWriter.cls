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
    File        : Demo.RestApiVersioning.Adapters.IOrderWriter
    Purpose     : Writes the (one) order model in the representation of one
                  version of the API
    Syntax      :
    Description : JSON starts here - before the writer, everything is typed
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Demo.RestApiVersioning.Order.* from propath.
using OpenEdge.Net.HTTP.*            from propath.
using Progress.Json.ObjectModel.*    from propath.

interface Demo.RestApiVersioning.Adapters.IOrderWriter:

    /**
     * Purpose: Gets the media type of this version, e.g.
     *          application/vnd.sports2000.order.v2+json
     * Notes  :
     */
    define public property MediaType as character no-undo
    get.

    /**
     * Purpose: Writes an order header as JSON
     * Notes  :
     * @param poOrder The order header
     * @return The JSON representation of this version
     */
    method public JsonObject Write (poOrder as OrderHeader).

    /**
     * Purpose: Adds the headers of this version to a response
     * Notes  : e.g. Deprecation and Sunset for a deprecated version
     * @param poResponse The response
     */
    method public void AddResponseHeaders (poResponse as IHttpResponse).

end interface.
