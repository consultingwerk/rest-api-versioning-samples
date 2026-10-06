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
    File        : Demo.RestApiVersioning.MediaType.MediaTypeNegotiator
    Purpose     : Selects the API version from the Accept header (response)
                  and the Content-Type header (request body)
    Syntax      :
    Description : application/vnd.sports2000.order.v0+json --> v0 (410)
                  application/vnd.sports2000.order.v1+json --> v1
                  application/vnd.sports2000.order.v2+json --> v2
                  application/json, wildcard or no Accept  --> v2
                  anything else: 406 (Accept) / 415 (Content-Type)
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2026-10-06
    Notes       : Pure logic - no HTTP objects, easy to unit test
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Demo.RestApiVersioning.Errors.* from propath.

class Demo.RestApiVersioning.MediaType.MediaTypeNegotiator:

    define private variable cSupported as character no-undo
        initial "application/vnd.sports2000.order.v1+json, application/vnd.sports2000.order.v2+json, application/json":u .

    /**
     * Purpose: Returns the version a media type stands for
     * Notes  : Media type names are case-insensitive - so is CASE
     * @param pcMediaType The media type without parameters
     * @return The version (v0, v1, v2) or "" for an unknown media type
     */
    method public character VersionOf (pcMediaType as character):

        case pcMediaType:
            when "application/vnd.sports2000.order.v0+json":u then
                return "v0":u .
            when "application/vnd.sports2000.order.v1+json":u then
                return "v1":u .
            when "application/vnd.sports2000.order.v2+json":u or
            when "application/json":u then
                return "v2":u .
        end case.

        return "":u .

    end method.

    /**
     * Purpose: Selects the version of the response from the Accept header
     * Notes  : Highest q-value wins; on equal q-values a vendor media type
     *          wins over application/json, which wins over a wildcard.
     *          q=0 means "not acceptable". Raises 406 when nothing matches
     * @param pcAccept The Accept header (? or "" when missing)
     * @return The version (v0, v1, v2)
     */
    method public character SelectResponseVersion (pcAccept as character):

        define variable cRange     as character no-undo .
        define variable cMediaType as character no-undo .
        define variable cVersion   as character no-undo .
        define variable cBest      as character no-undo .
        define variable deQuality  as decimal   no-undo .
        define variable deBest     as decimal   no-undo .
        define variable iRank      as integer   no-undo .
        define variable iBestRank  as integer   no-undo .
        define variable iRange     as integer   no-undo .
        define variable iRanges    as integer   no-undo .

        if pcAccept = ? or trim (pcAccept) = "":u then
            return "v2":u .  /* no preference: the current version */

        assign iRanges = num-entries (pcAccept) .

        rangeLoop:
        do iRange = 1 to iRanges:
            assign cRange     = entry (iRange, pcAccept)
                   cMediaType = trim (entry (1, cRange, ";":u))
                   deQuality  = this-object:Quality (cRange)
                   cVersion   = this-object:VersionOf (cMediaType)
                   iRank      = (if cMediaType begins "application/vnd.":u then 3
                                 else if cVersion > "":u then 2
                                 else 1) .

            /* wildcards: the current version */
            if cMediaType = "*/*":u or cMediaType = "application/*":u then
                assign cVersion = "v2":u .

            if cVersion = "":u or deQuality <= 0 then
                next rangeLoop .

            if deQuality > deBest or (deQuality = deBest and iRank > iBestRank) then
                assign cBest     = cVersion
                       deBest    = deQuality
                       iBestRank = iRank .
        end.

        if cBest = "":u then
            undo, throw new NotAcceptableException (pcAccept, cSupported) .

        return cBest .

    end method.

    /**
     * Purpose: Selects the version of the request body from the
     *          Content-Type header
     * Notes  : Parameters such as charset are ignored. Raises 415 for an
     *          unknown media type
     * @param pcContentType The Content-Type header
     * @return The version (v0, v1, v2)
     */
    method public character SelectRequestVersion (pcContentType as character):

        define variable cVersion as character no-undo .

        if pcContentType = ? then
            assign pcContentType = "":u .

        assign cVersion = this-object:VersionOf (trim (entry (1, pcContentType, ";":u))) .

        if cVersion = "":u then
            undo, throw new UnsupportedMediaTypeException (pcContentType, cSupported) .

        return cVersion .

    end method.

    /**
     * Purpose: Returns the q-value of a media range of the Accept header
     * Notes  : 1 when there is no q parameter, 0 for an invalid value
     * @param pcRange The media range, e.g. "application/json;q=0.8"
     * @return The q-value (0 to 1)
     */
    method private decimal Quality (pcRange as character):

        define variable cParameter  as character no-undo .
        define variable iParameter  as integer   no-undo .
        define variable iParameters as integer   no-undo .

        assign iParameters = num-entries (pcRange, ";":u) .

        do iParameter = 2 to iParameters:
            assign cParameter = replace (entry (iParameter, pcRange, ";":u), " ":u, "":u) .

            /* q-values always use a decimal point - independent of the session */
            if cParameter begins "q=":u then
                return decimal (replace (substring (cParameter, 3, -1, "character":u), ".":u, session:numeric-decimal-point)) .
        end.

        return 1 .

        catch uncaught as Progress.Lang.SysError:
            /* an invalid q-value makes the media range unacceptable */
            return 0 .
        end catch.

    end method.

end class.
