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
