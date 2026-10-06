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
    File        : Demo.RestApiVersioning.Adapters.OrderV2Reader
    Purpose     : Reads the v2 representation of an order (customer as a
                  nested object, no WarehouseNum)
    Syntax      :
    Description : Works through IOrderHeaderV2 only. WarehouseNum is not
                  part of the v2 schema, so a v2 client sending it gets
                  400 Bad Request - like for any other unknown field
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Adapters.* from propath.
using Demo.RestApiVersioning.Order.*    from propath.
using Progress.Json.ObjectModel.*       from propath.

class Demo.RestApiVersioning.Adapters.OrderV2Reader
    inherits JsonReader
    implements IOrderReader:

    /* The v2 schema - WarehouseNum is not in it, so it is rejected with 400 */
    define private variable cKnownFields as character no-undo
        initial "Ordernum,Customer,OrderDate,ShipDate,PromiseDate,Carrier,Instructions,PO,Terms,SalesRep,BillToID,ShipToID,OrderStatus,Creditcard":u .

    /* The nested customer object */
    define private variable cKnownCustomerFields as character no-undo
        initial "CustNum,Name,Address,Address2,PostalCode,City,State,Country":u .

    /* What a v2 client can write - Ordernum and the address are read-only */
    define private variable cWritableFields as character no-undo
        initial "Customer.CustNum,OrderDate,ShipDate,PromiseDate,Carrier,Instructions,PO,Terms,SalesRep,BillToID,ShipToID,OrderStatus,Creditcard":u .

    /**
     * Purpose: Merges a v2 request body into an order header
     * Notes  : Only the fields contained in the payload are assigned, null
     *          assigns the unknown value. Read-only fields are ignored
     * @param poJson The request body
     * @param poOrder The order header (new for POST, current for PUT/PATCH)
     * @param peMode How to merge: Create, Replace or Patch
     */
    method public void Merge (poJson as JsonObject,
                              poOrder as OrderHeader,
                              peMode as MergeMode):

        define variable oOrder    as IOrderHeaderV2 no-undo .
        define variable oCustomer as JsonObject     no-undo .

        /* From here on, the v2 reader only sees the v2 contract */
        assign oOrder    = poOrder
               oCustomer = this-object:GetObject (poJson, "Customer":u) .

        this-object:CheckUnknownFields (poJson, cKnownFields, "":u) .

        if valid-object (oCustomer) then
            this-object:CheckUnknownFields (oCustomer, cKnownCustomerFields, "Customer.":u) .

        this-object:CheckRequiredFields (poJson, this-object:RequiredFields (peMode)) .

        if this-object:Has (poJson, "Customer.CustNum":u) then
            assign oOrder:Customer:CustNum = this-object:GetInteger (poJson, "Customer.CustNum":u) .
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
        if this-object:Has (poJson, "Creditcard":u) then
            assign oOrder:Creditcard = this-object:GetCharacter (poJson, "Creditcard":u) .

    end method.

    /**
     * Purpose: Returns the name a field of the model has in v2
     * Notes  : The model has the shape of v2 - the names are identical
     * @param pcModelField The field name in the model
     * @return The field name in v2
     */
    method public character ExternalFieldName (pcModelField as character):

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
                return "Customer.CustNum":u .
            when MergeMode:Replace then
                return cWritableFields .
        end case.

        return "":u .

    end method.

end class.
