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
    File        : Demo.RestApiVersioning.Simple.SimpleOrderJson
    Purpose     : Writes the v1 and the v2 representation of an order
                  directly from the Order and Customer records
    Syntax      :
    Description : The simple handlers use it. Each version is just a list
                  of fields - v1 flat incl. WarehouseNum, v2 with a nested
                  Customer object and without WarehouseNum
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : Uses the VAR statement (OpenEdge 12.3 and later)
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Simple.* from propath.
using Progress.Json.ObjectModel.*     from propath.

class Demo.RestApiVersioning.Simple.SimpleOrderJson:

    /**
     * Purpose: Writes the flat v1 representation
     * Notes  :
     * @param pbOrder The Order record
     * @param pbCustomer The Customer record of the order
     * @return The v1 JSON representation
     */
    method public static JsonObject WriteV1 (buffer pbOrder for Order,
                                             buffer pbCustomer for Customer):

        var JsonObject oJson = new JsonObject () .

        SimpleOrderJson:AddFields (oJson, buffer pbOrder:handle, "Ordernum,CustNum":u) .
        SimpleOrderJson:AddFields (oJson, buffer pbCustomer:handle, "Name,Address,Address2,PostalCode,City,State,Country":u) .
        SimpleOrderJson:AddFields (oJson, buffer pbOrder:handle, "OrderDate,ShipDate,PromiseDate,Carrier,Instructions,PO,Terms,SalesRep,BillToID,ShipToID,OrderStatus,WarehouseNum,Creditcard":u) .

        return oJson .

    end method.

    /**
     * Purpose: Writes the v2 representation
     * Notes  : Customer as a nested object, no WarehouseNum
     * @param pbOrder The Order record
     * @param pbCustomer The Customer record of the order
     * @return The v2 JSON representation
     */
    method public static JsonObject WriteV2 (buffer pbOrder for Order,
                                             buffer pbCustomer for Customer):

        var JsonObject oJson     = new JsonObject () .
        var JsonObject oCustomer = new JsonObject () .

        SimpleOrderJson:AddFields (oCustomer, buffer pbCustomer:handle, "CustNum,Name,Address,Address2,PostalCode,City,State,Country":u) .

        SimpleOrderJson:AddFields (oJson, buffer pbOrder:handle, "Ordernum":u) .
        oJson:Add ("Customer":u, oCustomer) .
        SimpleOrderJson:AddFields (oJson, buffer pbOrder:handle, "OrderDate,ShipDate,PromiseDate,Carrier,Instructions,PO,Terms,SalesRep,BillToID,ShipToID,OrderStatus,Creditcard":u) .

        return oJson .

    end method.

    /**
     * Purpose: Adds fields of a record to a JSON object
     * Notes  : The unknown value (and a missing record) is written as null
     * @param poJson The JSON object
     * @param phBuffer The buffer
     * @param pcFields The comma separated list of the field names
     */
    method private static void AddFields (poJson as JsonObject,
                                          phBuffer as handle,
                                          pcFields as character):

        var integer iFields = num-entries (pcFields) .
        var integer iField .
        var handle  hField .

        do iField = 1 to iFields:
            assign hField = phBuffer:buffer-field (entry (iField, pcFields)) .

            if not phBuffer:available or hField:buffer-value = ? then
                poJson:AddNull (hField:name) .
            else
                case hField:data-type:
                    when "integer":u then
                        poJson:Add (hField:name, integer (hField:buffer-value)) .
                    when "date":u then
                        poJson:Add (hField:name, date (hField:buffer-value)) .
                    otherwise
                        poJson:Add (hField:name, string (hField:buffer-value)) .
                end case.
        end.

    end method.

end class.
