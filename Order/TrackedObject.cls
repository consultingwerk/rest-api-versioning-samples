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
    File        : Demo.RestApiVersioning.Order.TrackedObject
    Purpose     : Remembers which properties of an object were assigned
    Syntax      :
    Description : The setters of the subclasses call MarkAssigned. This is
                  what keeps "field missing in the PATCH payload" (property
                  not assigned) apart from "field sent as null" (property
                  assigned the unknown value)
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

class Demo.RestApiVersioning.Order.TrackedObject
    abstract:

    /* Comma separated list of the properties assigned since the last reset */
    define private variable cAssignedProperties as character no-undo .

    /**
     * Purpose: Records that a property was assigned
     * Notes  : Called from the property setters
     * @param pcProperty The name of the property
     */
    method public void MarkAssigned (pcProperty as character):

        if lookup (pcProperty, cAssignedProperties) = 0 then
            assign cAssignedProperties = cAssignedProperties
                                       + (if cAssignedProperties = "":u then "":u else ",":u)
                                       + pcProperty .

    end method.

    /**
     * Purpose: Returns if a property was assigned since the last reset
     * Notes  :
     * @param pcProperty The name of the property
     * @return Logical value indicating if the property was assigned
     */
    method public logical IsAssigned (pcProperty as character):

        return lookup (pcProperty, cAssignedProperties) > 0 .

    end method.

    /**
     * Purpose: Forgets all assignments
     * Notes  : Called after an object was loaded from the database
     */
    method public void ResetAssigned ():

        assign cAssignedProperties = "":u .

    end method.

end class.
