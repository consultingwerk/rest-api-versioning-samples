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
    File        : Demo.RestApiVersioning.Adapters.MergeMode
    Purpose     : How a reader merges a request body into an order
    Syntax      :
    Description : Create  (POST)  - CustNum is required
                  Replace (PUT)   - the complete writable representation
                                    of the version is required
                  Patch   (PATCH) - nothing is required, only the fields in
                                    the payload change, null sets unknown
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

enum Demo.RestApiVersioning.Adapters.MergeMode:

    define enum Create
                Replace
                Patch .

end enum.
