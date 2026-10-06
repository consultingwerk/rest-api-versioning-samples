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
    File        : Demo.RestApiVersioning.Adapters.OrderV1Reader
    Purpose     : Reads the flat v1 representation of an order
    Syntax      :
    Description : Works through IOrderHeaderV1 only - it cannot even see
                  the nested Customer object of v2. Still reads WarehouseNum
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Adapters.* from propath.
using Demo.RestApiVersioning.Order.*    from propath.
using Progress.Json.ObjectModel.*       from propath.

class Demo.RestApiVersioning.Adapters.OrderV1Reader
    inherits JsonReader
    implements IOrderReader:

    /* The v1 schema - any other field is rejected with 400 */
    define private variable cKnownFields as character no-undo
        initial "Ordernum,CustNum,Name,Address,Address2,PostalCode,City,State,Country,OrderDate,ShipDate,PromiseDate,Carrier,Instructions,PO,Terms,SalesRep,BillToID,ShipToID,OrderStatus,WarehouseNum,Creditcard":u .

    /* What a v1 client can write - Ordernum and the address are read-only */
    define private variable cWritableFields as character no-undo
        initial "CustNum,OrderDate,ShipDate,PromiseDate,Carrier,Instructions,PO,Terms,SalesRep,BillToID,ShipToID,OrderStatus,WarehouseNum,Creditcard":u .

    /**
     * Purpose: Merges a v1 request body into an order header
     * Notes  : Only the fields contained in the payload are assigned, null
     *          assigns the unknown value. Read-only fields are ignored
     * @param poJson The request body
     * @param poOrder The order header (new for POST, current for PUT/PATCH)
     * @param peMode How to merge: Create, Replace or Patch
     */
    method public void Merge (poJson as JsonObject,
                              poOrder as OrderHeader,
                              peMode as MergeMode):

        define variable oOrder as IOrderHeaderV1 no-undo .

        /* From here on, the v1 reader only sees the v1 contract */
        assign oOrder = poOrder .

        this-object:CheckUnknownFields (poJson, cKnownFields, "":u) .
        this-object:CheckRequiredFields (poJson, this-object:RequiredFields (peMode)) .

        if this-object:Has (poJson, "CustNum":u) then
            assign oOrder:CustNum = this-object:GetInteger (poJson, "CustNum":u) .
        if this-object:Has (poJson, "OrderDate":u) then
            assign oOrder:OrderDate = this-object:GetDate (poJson, "OrderDate":u) .
        if this-object:Has (poJson, "ShipDate":u) then
            assign oOrder:ShipDate = this-object:GetDate (poJson, "ShipDate":u) .
        if this-object:Has (poJson, "PromiseDate":u) then
            assign oOrder:PromiseDate = this-object:GetDate (poJson, "PromiseDate":u) .
        if this-object:Has (poJson, "Carrier":u) then
            assign oOrder:Carrier = this-object:GetCharacter (poJson, "Carrier":u) .
        if this-object:Has (poJson, "Instructions":u) then
            assign oOrder:Instructions = this-object:GetCharacter (poJson, "Instructions":u) .
        if this-object:Has (poJson, "PO":u) then
            assign oOrder:PO = this-object:GetCharacter (poJson, "PO":u) .
        if this-object:Has (poJson, "Terms":u) then
            assign oOrder:Terms = this-object:GetCharacter (poJson, "Terms":u) .
        if this-object:Has (poJson, "SalesRep":u) then
            assign oOrder:SalesRep = this-object:GetCharacter (poJson, "SalesRep":u) .
        if this-object:Has (poJson, "BillToID":u) then
            assign oOrder:BillToID = this-object:GetInteger (poJson, "BillToID":u) .
        if this-object:Has (poJson, "ShipToID":u) then
            assign oOrder:ShipToID = this-object:GetInteger (poJson, "ShipToID":u) .
        if this-object:Has (poJson, "OrderStatus":u) then
            assign oOrder:OrderStatus = this-object:GetCharacter (poJson, "OrderStatus":u) .
        if this-object:Has (poJson, "WarehouseNum":u) then
            assign oOrder:WarehouseNum = this-object:GetInteger (poJson, "WarehouseNum":u) .
        if this-object:Has (poJson, "Creditcard":u) then
            assign oOrder:Creditcard = this-object:GetCharacter (poJson, "Creditcard":u) .

    end method.

    /**
     * Purpose: Returns the name a field of the model has in v1
     * Notes  : The customer is flat in v1: "Customer.CustNum" --> "CustNum"
     * @param pcModelField The field name in the model
     * @return The field name in v1
     */
    method public character ExternalFieldName (pcModelField as character):

        if pcModelField begins "Customer.":u then
            return entry (2, pcModelField, ".":u) .

        return pcModelField .

    end method.

    /**
     * Purpose: Returns the fields required by a merge mode
     * Notes  :
     * @param peMode The merge mode
     * @return The comma separated list of the required fields
     */
    method private character RequiredFields (peMode as MergeMode):

        case peMode:
            when MergeMode:Create then
                return "CustNum":u .
            when MergeMode:Replace then
                return cWritableFields .
        end case.

        return "":u .

    end method.

end class.
