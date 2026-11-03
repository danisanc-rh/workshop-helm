# customer-portal — solución

Este chart implementa los ejercicios de práctica de `values.yaml` y aplica las convenciones mostradas en la guía de Helm.

## Validar y renderizar

```bash
helm lint .
helm template customer-portal . --namespace customer-dev
helm template customer-portal . --namespace customer-dev -f values-dev.yaml
helm template customer-portal . --namespace customer-prod -f values-prod.yaml
```

## Instalar

```bash
helm upgrade --install customer-portal . -n customer-dev --create-namespace -f values-dev.yaml
helm upgrade --install customer-portal . -n customer-prod --create-namespace -f values-prod.yaml
```

## Comprobar los valores y condiciones

```bash
# Sobrescribir réplicas e imagen
helm template customer-portal . --set replicaCount=4 --set image.tag=1.28.0

# Deshabilitar los recursos RBAC
helm template customer-portal . --set rbac.create=false

# Usar un ServiceAccount existente, sin crearlo
helm template customer-portal . --set serviceAccount.create=false --set serviceAccount.name=my-existing-sa

# Annotation en los pods
helm template customer-portal . --set podAnnotations.owner=platform-team
```

## Decisiones aplicadas

- Archivos separados por recurso Kubernetes y nombres en kebab-case.
- Helpers con prefijo `customer-portal.` para evitar colisiones con subcharts.
- Labels estándar `app.kubernetes.io/*` y `helm.sh/chart`.
- Selectores estables: solo `app.kubernetes.io/name` e `app.kubernetes.io/instance`; no dependen de versión.
- `rbac.create` controla Role y RoleBinding; `serviceAccount.create` controla la creación del ServiceAccount. Son controles independientes.
- El namespace se toma de `.Release.Namespace`, no de un valor duplicado en `values.yaml`.
- Imagen con tag fijo, nunca `latest`.
- Valores distintos para desarrollo y producción.
- `values.schema.json` valida tipos y rangos de algunos valores.

## Nota sobre RBAC

El Role de ejemplo permite únicamente `get`, `list` y `watch` sobre ConfigMaps en el namespace de la release. Ajusta las reglas al mínimo privilegio requerido por la aplicación. Si `rbac.create=false`, el chart no crea Role ni RoleBinding; si además `serviceAccount.create=false`, debe existir el ServiceAccount indicado (o se usará `default`).
