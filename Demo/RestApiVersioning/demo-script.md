# Demo script - REST API Versioning

curl commands for the live demo against a local PASOE (`http://localhost:8820`, web transport
`/web`). Every block lists the expected status code. `-i` shows the response headers - watch
`Content-Type`, `Deprecation`, `Sunset`, `Link`, `Allow` and `Vary`.

```bash
BASE=http://localhost:8820/web
V0=application/vnd.sports2000.order.v0+json
V1=application/vnd.sports2000.order.v1+json
V2=application/vnd.sports2000.order.v2+json
```

Pick an existing order for the read-only steps and a customer number for the writes:

```bash
ORDER=1
CUST=1
```

## 0. A minimal web handler

```bash
curl -i $BASE/simple/Orders/42                                   # 200 {"Ordernum":42,"OrderStatus":"Shipped"}
curl -i -X PUT $BASE/simple/Orders/42 \
     -H "Content-Type: application/json" -H "Accept: $V2" \
     -d '{"Carrier": "UPS"}'                                     # 200 echoes Content-Type, Accept and the body
curl -i -X DELETE $BASE/simple/Orders/42                         # 405 (HandleNotAllowedMethod)
```

The same order, versioned in the simplest possible way - direct record access, GET only:

```bash
curl -i $BASE/simple/media/Orders/$ORDER -H "Accept: $V1"        # 200 v1 (flat), Content-Type ...v1+json, Vary: Accept
curl -i $BASE/simple/media/Orders/$ORDER -H "Accept: $V2"        # 200 v2 (nested Customer)
curl -i $BASE/simple/media/Orders/$ORDER                         # 200 no Accept --> v2
curl -i $BASE/simple/media/Orders/$ORDER -H "Accept: text/html"  # 406
curl -i $BASE/simple/v1/Orders/$ORDER                            # 200 v1 (flat)
curl -i $BASE/simple/v2/Orders/$ORDER                            # 200 v2 (nested Customer)
curl -i $BASE/simple/v0/Orders/$ORDER                            # 410
curl -i $BASE/simple/v9/Orders/$ORDER                            # 404 unknown version
curl -i $BASE/simple/v2/Orders/99999999                          # 404 unknown order
```

## 1. URI versioning - fixed URIs

### v2 - current

```bash
curl -i "$BASE/v2/Orders?skip=0&top=3"                           # 200 page of 3, "Next" link
curl -i $BASE/v2/Orders/$ORDER                                   # 200 nested "Customer", no WarehouseNum
```

### v1 - deprecated, still working

```bash
curl -i $BASE/v1/Orders/$ORDER                                   # 200 flat, WarehouseNum
                                                                 #     Deprecation: @1782864000
                                                                 #     Sunset: Wed, 30 Jun 2027 23:59:59 GMT
                                                                 #     Link: <...migrate-v2>; rel="deprecation"
```

### v0 - switched off

```bash
curl -i $BASE/v0/Orders/$ORDER                                   # 410 application/problem+json
                                                                 #     Link: </web/v2/Orders/1>; rel="successor-version"
curl -i -X PUT $BASE/v0/Orders/$ORDER \
     -H "Content-Type: application/json" -d '{"Carrier": "UPS"}' # 410 - every method
```

### Writes: one business logic, two contracts

Create an order with v2 and remember its number:

```bash
curl -i -X POST $BASE/v2/Orders -H "Content-Type: application/json" \
     -d "{\"Customer\": {\"CustNum\": $CUST}, \"Carrier\": \"UPS\"}" # 201 + Location: /web/v2/Orders/<n>
NEW=<number from the Location header>
```

v1 still writes WarehouseNum - v2 does not know it:

```bash
curl -i -X PATCH $BASE/v1/Orders/$NEW -H "Content-Type: application/json" \
     -d '{"WarehouseNum": 2}'                                    # 200, WarehouseNum 2
curl -i -X PATCH $BASE/v2/Orders/$NEW -H "Content-Type: application/json" \
     -d '{"WarehouseNum": 3}'                                    # 400 problem details, field "WarehouseNum"
curl -i -X PATCH $BASE/v2/Orders/$NEW -H "Content-Type: application/json" \
     -d '{"Carrier": "DHL", "ShipDate": null}'                   # 200 only Carrier and ShipDate change
curl -i $BASE/v1/Orders/$NEW                                     # 200 WarehouseNum is still 2
```

Contract rules:

```bash
curl -i -X PATCH $BASE/v1/Orders/$NEW -H "Content-Type: application/json" \
     -d '{"Name": "ignored", "City": "ignored"}'                 # 200 address fields are read-only, ignored
curl -i -X PATCH $BASE/v1/Orders/$NEW -H "Content-Type: application/json" \
     -d '{"Discount": 5}'                                        # 400 unknown field "Discount"
curl -i -X PUT $BASE/v1/Orders/$NEW -H "Content-Type: application/json" \
     -d '{"Carrier": "DHL"}'                                     # 400 PUT needs the complete representation
curl -i -X PATCH $BASE/v1/Orders/$NEW -H "Content-Type: application/json" \
     -d '{"CustNum": 99999999}'                                  # 400 field "CustNum" (v1 name)
curl -i -X PATCH $BASE/v2/Orders/$NEW -H "Content-Type: application/json" \
     -d '{"Customer": {"CustNum": 99999999}}'                    # 400 field "Customer.CustNum" (v2 name)
```

DELETE is not part of any version:

```bash
curl -i -X DELETE $BASE/v2/Orders/$NEW                           # 405 Allow: GET, PUT, PATCH
curl -i -X DELETE $BASE/v2/Orders                                # 405 Allow: GET, POST
```

## 2. URI versioning - one web handler, version as path parameter

Same API, one handler (`UriVersion.OrdersHandler`):

```bash
curl -i $BASE/api/v2/Orders/$ORDER                               # 200 v2
curl -i $BASE/api/v1/Orders/$ORDER                               # 200 v1 + Deprecation / Sunset
curl -i $BASE/api/v0/Orders/$ORDER                               # 410 Link: </web/api/v2/Orders/1>
curl -i $BASE/api/v3/Orders/$ORDER                               # 404 unknown version
curl -i -X DELETE $BASE/api/v2/Orders/$ORDER                     # 405 Allow: GET, PUT, PATCH
```

## 3. Media type versioning - one URI

```bash
curl -i $BASE/Orders/$ORDER -H "Accept: $V2"                     # 200 Content-Type: ...v2+json, Vary: Accept
curl -i $BASE/Orders/$ORDER -H "Accept: $V1"                     # 200 Content-Type: ...v1+json + Deprecation
curl -i $BASE/Orders/$ORDER                                      # 200 no Accept --> v2
curl -i $BASE/Orders/$ORDER -H "Accept: application/json"        # 200 --> v2
curl -i $BASE/Orders/$ORDER -H "Accept: $V1;q=0.5, $V2;q=0.9"    # 200 --> v2 (q-values)
curl -i $BASE/Orders/$ORDER -H "Accept: text/html"               # 406 Not Acceptable
curl -i $BASE/Orders/$ORDER -H "Accept: $V0"                     # 410 Link: </web/Orders/1>; rel="successor-version"; type="...v2+json"
```

Send v1, receive v2:

```bash
curl -i -X PATCH $BASE/Orders/$NEW -H "Content-Type: $V1" -H "Accept: $V2" \
     -d '{"WarehouseNum": 4, "Carrier": "FedEx"}'                # 200 v2 response (no WarehouseNum), stored 4
curl -i -X PATCH $BASE/Orders/$NEW -H "Content-Type: text/plain" -H "Accept: $V2" \
     -d '{"Carrier": "FedEx"}'                                   # 415 Unsupported Media Type
curl -i -X DELETE $BASE/Orders/$NEW -H "Accept: $V2"             # 405 Allow + Vary
```

## 4. OpenAPI documents

```bash
curl -i $BASE/openapi/orders-mediatype.openapi.json             # 200 media type variant
curl -i $BASE/openapi/orders-v1.openapi.json                    # 200 URI variant, v1 (deprecated)
curl -i $BASE/openapi/orders-v2.openapi.json                    # 200 URI variant, v2
```

Swagger UI with a drop-down of all three documents: <http://localhost:8820/web/openapi>
(loads Swagger UI from unpkg.com). A single document directly:
`http://localhost:8820/web/openapi?urls.primaryName=URI%20versioning%20-%20v1%20(deprecated)`

## Clean up

The demo order created above can be deleted in the database - the API does not allow it.
