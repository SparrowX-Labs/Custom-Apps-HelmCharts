# gateway-api-helmchart

Deploys the shared Gateway API entry point and application-owned HTTPRoutes.
Keep the Traefik controller installation and Gateway API CRDs in platform
infrastructure. Environment-specific application values are supplied by the
`gateway-api` repository.

The chart creates one shared GatewayClass and Gateway, then creates one
HTTPRoute for every entry under `apis`. A ReferenceGrant is created only for
entries that explicitly set `referenceGrant.enabled: true`.
