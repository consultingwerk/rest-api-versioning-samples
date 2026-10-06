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
    File        : Demo.RestApiVersioning.Adapters.IOrderReader
    Purpose     : Reads the request body of one version of the API into
                  the (one) order model
    Syntax      :
    Description : JSON ends here - behind the reader, everything is typed
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Demo.RestApiVersioning.Adapters.* from propath.
using Demo.RestApiVersioning.Order.*    from propath.
using Progress.Json.ObjectModel.*       from propath.

interface Demo.RestApiVersioning.Adapters.IOrderReader:

    /**
     * Purpose: Merges the request body into an order header
     * Notes  : Raises 400 for unknown fields, missing required fields and
     *          invalid values
     * @param poJson The request body
     * @param poOrder The order header (new for POST, current for PUT/PATCH)
     * @param peMode How to merge: Create, Replace or Patch
     */
    method public void Merge (poJson as JsonObject,
                              poOrder as OrderHeader,
                              peMode as MergeMode).

    /**
     * Purpose: Returns the name a field of the model has in this version
     * Notes  : Used to report business rule violations with the field names
     *          the client knows
     * @param pcModelField The field name in the model, e.g. "Customer.CustNum"
     * @return The field name in this version, e.g. "CustNum" in v1
     */
    method public character ExternalFieldName (pcModelField as character).

end interface.
