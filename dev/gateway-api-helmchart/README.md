# gateway-api-helmchart

Deploys the Gateway API objects for one gateway application. Keep the
controller installation and Gateway API CRDs in platform infrastructure;
this chart contains application-owned objects such as Gateway, HTTPRoute,
GRPCRoute, ReferenceGrant, and backend policy resources.

The chart can be installed once as a single Argo CD application while values
contain any number of gateways and routes.
