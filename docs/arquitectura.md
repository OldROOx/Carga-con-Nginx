# Arquitectura del Sistema

## Diagrama de Red
```
                        Internet
                           |
                           |
                    [ELB/CloudFront] (opcional)
                           |
                           v
                  ┌─────────────────┐
                  │  Nginx Proxy    │
                  │  (Load Balancer)│
                  │  IP: 10.0.1.10  │
                  │  Public: X.X.X.X│
                  └────────┬────────┘
                           |
            ┌──────────────┼──────────────┐
            │              │              │
            v              v              v
     ┌──────────┐   ┌──────────┐   ┌──────────┐
     │Backend 1 │   │Backend 2 │   │Backend 3 │
     │:8080     │   │:8081     │   │:8082     │
     │10.0.1.11 │   │10.0.1.12 │   │10.0.1.13 │
     └──────────┘   └──────────┘   └──────────┘
```

## Detalles de Configuración

### Nginx Load Balancer
- **IP Privada:** 10.0.1.10
- **IP Pública:** [REDACTED]
- **Puertos:** 80, 443
- **Algoritmo:** Least Connections con health checks

### Backends
| Servidor | IP Privada | Puerto | Estado |
|----------|------------|--------|--------|
| Backend-1 | 10.0.1.11 | 8080 | Activo |
| Backend-2 | 10.0.1.12 | 8081 | Activo |
| Backend-3 | 10.0.1.13 | 8082 | Backup |

## Security Groups

### nginx-sg
- Inbound: 22 (SSH), 80 (HTTP), 443 (HTTPS)
- Outbound: All traffic

### backend-sg  
- Inbound: 22 (SSH), 8080-8082 (desde nginx-sg)
- Outbound: All traffic
