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
